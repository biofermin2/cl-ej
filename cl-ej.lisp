;;;; package.lisp
;;
;;;; Copyright (c) 2022 biofermin2

(defpackage #:cl-ej
  (:use #:cl)
  (:shadowing-import-from :dexador
		       :get)
  (:import-from :lquery
		:$)
  (:export :init-db :say :weblio :alc))	; => #<PACKAGE "CL-EJ">

(in-package #:cl-ej)			; => #<PACKAGE "CL-EJ">

;; (defun set-utils ()
;;   (let ((file "~/howm/junk/utils.lisp"))
;;     (when (probe-file file)
;;       (load file))))			; => SET-UTILS

(defun system (control-string &rest args)
  "Interpolate ARGS into CONTROL-STRING as if by FORMAT, and
synchronously execute the result using a Bourne-compatible shell, with
output to *verbose-out*.  Returns the shell's exit code."
  (let ((command (apply #'format nil control-string args)))
    (format t "; $ ~A~%" command)
    #+sbcl
    ;; (sb-impl::process-exit-code
     (sb-ext:run-program
      "/usr/bin/bash"
      (list  "-c" command)
       :input nil :output nil)
      ;; :input nil :output *standard-output*)
     ;; )
    #+(or cmu scl)
    (ext:process-exit-code
     (ext:run-program
      "/bin/sh"
      (list  "-c" command)
      :input nil :output *verbose-out*))
    #+clisp             ;XXX not exactly *verbose-out*, I know
    (ext:run-shell-command  command :output :terminal :wait t))) ; => SYSTEM

(defun say (word)
  (let* ((init (car (coerce word 'list)))
	 (tts (if (standard-char-p init)
		  "flite"
		  "ojtalk")))
    (system (format nil "~a~a~a~a" "echo \"" word "\" | " tts)))) ; => SAY

(defun init-db (file)
  "該当するdbが存在するかどうか調べて存在しない場合空のハッシュテーブルが
入ったdbファイルを作成する。初期化処理"
  (let ((filename (merge-pathnames (make-pathname
				    :directory '(:relative "howm" "junk")
				    :name (string-downcase file)
				    :type "db"
				    :version :newest)
				   (user-homedir-pathname))))
    (unless (probe-file filename)
      (let ((ht (make-hash-table :test #'equal)))
	(save-db ht file)))))		; => INIT-DB

(defun load-db (file ht)
  "ロード元のファイルを読み込み登録用の辞書テーブルに展開する"
  (init-db file)
  (let ((infile (merge-pathnames (make-pathname
				  :directory '(:relative "howm" "junk")
				  :name (string-downcase file)
				  :type "db"
				  :version :newest)
				 (user-homedir-pathname))))
    (with-open-file (in infile)
      (with-standard-io-syntax
        (setf ht (read in))))))		; => LOAD-DB

(defun save-db (ht file)
  "ハッシュテーブルの保存"
  (let ((ofile (merge-pathnames (make-pathname
				   :directory '(:relative "howm" "junk")
				   :name (string-downcase file)
				   :type "db"
				   :version :newest)
				  (user-homedir-pathname))))
    (with-open-file (out ofile
                         :direction :output
                         :if-exists :supersede
			 :if-does-not-exist :create
                         :external-format :utf-8)
      (with-standard-io-syntax
        (print ht out)))))		; => SAVE-DB


(defun weblio (&rest argv)
  (declare (ignorable argv))
  (if argv
      (let ((ht (make-hash-table :test #'equal)))
	(setf ht (load-db "weblio" ht))
	(let* ((str (format nil "~{~a~^+~}" (apply #'append argv)))
	       (result (gethash str ht)))
	  (if result
	      (print result)
	      (let* ((url "https://ejje.weblio.jp/content/")
		     (con (dex:get (concatenate 'string url str)))
		     (p-con ($ (initialize con)))
		     (result (string-trim '(#\return #\space #\newline)
					  (aref ($ p-con ".content-explanation" (text)) 0))))
		(setf (gethash str ht) result)
		(save-db ht "weblio")
		(format nil "~a~%" result)))))
      (error "put something english words that you want to translate."))) ; => WEBLIO

(defun alc (&rest argv)
  (declare (ignorable argv))
  (if argv
      (let ((ht (make-hash-table :test #'equal)))
	(setf ht (load-db "alc" ht))
	(let* ((str (format nil "~{~a~^+~}" (apply #'append argv)))
	       (result (gethash str ht)))
	  (if result
	      (print result)
	      (let* ((url "https://eow.alc.co.jp/search?q=")
		     (con (dex:get (format nil "~a~a" url str)))
		     (p-con ($ (initialize con)))
		     (result (format nil "~a~%" (elt ($ p-con "#resultsList li" (text)) 0))))
		(setf (gethash str ht) result)
		(save-db ht "alc")
		(format nil "~a~%" result)))))
      (error "put something english words that you want to translate."))) ; => ALC
