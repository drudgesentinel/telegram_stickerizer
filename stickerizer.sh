#!/bin/bash
#usage: run from inside picture directory, specify absolute path to destination directory
PICDIR=$1
DESTDIR=$2

if [ ! -d $PICDIR ] || [ $# -lt 1 ] ; then
echo "Provide a picture directory as the argument."
exit 64
fi

echo "The last character of the picture directory is " + ${PICDIR: -1}
if [ "${PICDIR: -1}" != "/" ] ; then

#Make sure to not confuse any little ubuntu babbies
echo "Appending backslash to dirname"
PICDIR=${PICDIR}/
fi

if [ ! -d $DESTDIR ] || [ $# -lt 2 ] ; then
echo "provide a destination directory"
exit 64
fi
for FILE in $(find "$PICDIR") 
do
EXT=${FILE##*\.}
case "$EXT" in
	jpg) echo "$FILE : Ready to convert"
;;
	gif) echo "$FILE : Ready to convert"
;;
	png) echo "$FILE : Already png, ready to resize"
;;
    
esac
done

echo 'Confirm the above files should be converted to .png and resized (y/n)'
read CONFIRM
if [[ $CONFIRM =~ [yY] ]]; then
echo "Confirmed."
echo "Converting files...."
for FILE in $(find "$PICDIR")
do
EXT=${FILE##*\.}
case "$EXT" in
	jpg) convert $FILE -resize 512x512 $(echo $FILE | sed s/.jpg/\_stickerized.png/)
;;
	gif) convert $FILE -resize 512x512 $(echo $FILE | sed s/.gif/\_stickerized.png/)
;;
	png) convert $FILE -resize 512x512 $(echo $FILE | sed s/.png/\_stickerized.png/)
;;
esac
done
mv ${PICDIR}*_stickerized.png $DESTDIR
else
echo "Aborted."
fi
