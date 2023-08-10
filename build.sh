#!/bin/bash

DEST=mopse.awk

[[ -f $DEST ]] && rm $DEST

cat src/utils.awk >> $DEST
cat src/const.awk >> $DEST
cat src/array.awk >> $DEST
cat src/xml.awk   >> $DEST
cat src/tree.awk  >> $DEST
cat src/main.awk  >> $DEST