# cl-ej
Simple scraping script that translate English word to Japanese.

<a href="https://youtu.be/kv6nR9gg4SI"><img src="https://github.com/biofermin2/cl-ej/blob/7e0b9dac5d14935f54554c7c276bcc962ec7f2be/cl-ej.gif"></a>

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
