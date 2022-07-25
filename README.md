# cl-ej
Simple scraping script that translate English word to Japanese.

## usage
you give execute priviledge first.

~~~shellscript
$ sudo chmod +x *.ros
~~~  

then build ros script and move it on ~~/usr/bin~~ ~/.roswell/bin.

```shellscript
$ ros build cl-ej.ros
$ mv cl-ej ~/.roswell/bin
```
now you can translate english words or idioms.

~~~shellscript  
$ cl-ej [English word] or [idioms]
~~~  

this script makes database file too.

you can see the database by print-db.ros.

```shellscript
;; after you build print-db.ros like above.
$ print-db <db file>
```

That's all.

# special thanks!
Lastly, I would like to take this opportunity to thank 
ALC PRESS INC. and GRAS Group Inc. 
for their wonderful web services.
