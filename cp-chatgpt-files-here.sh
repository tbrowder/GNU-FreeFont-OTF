#/usr/bin/bash

RDIR=/home/tbrowde/ChatGPT/gnu-freefont-otf/

echo "copy from dir: ${RDIR}"
ls ${RDIR}
cp -r ${RDIR}/* .
