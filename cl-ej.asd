;;;; cl-ej.asd
;;
;;;; Copyright (c) 2022 biofermin2


(asdf:defsystem #:cl-ej
  :description "this script translate english to japanese on your commandline with voice."
  :author "biofermin2"
  :license  "MIT"
  :version "0.1.0"
  :serial t
  :depends-on (#:dexador #:lquery)
  :components ((:file "cl-ej")))
