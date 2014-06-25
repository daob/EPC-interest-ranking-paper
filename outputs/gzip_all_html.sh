#!/bin/bash

for file in $(ls *.html)
do
  lynx -width 1000 -dump $file > $file.txt
  gzip $file.txt
  gzip $file
  python read_LG_html.py --filename=$file.txt.gz
done
