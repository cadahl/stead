#!/bin/bash

LOVEVERSION=0.7.0

GVERSION=`date +%F`
GNAME="stead"
GNAME_LINUX=${GNAME}"-linux"
LOVEDISTPATH=${PWD}/lovedist
SRCPATH=${PWD}/src
DISTPATH=${PWD}/dist/${GNAME}-${GVERSION}

echo ${DISTPATH}
echo Building ${GNAME}-${GVERSION}...
rm -R ${DISTPATH}
mkdir -p ${DISTPATH}

cd ${SRCPATH}

echo Packaging generic version...
zip -9r ${DISTPATH}/${GNAME}.love .


echo Packaging Linux version...
cd ${DISTPATH}
cat `which love` ${GNAME}.love > ${GNAME_LINUX}
chmod 755 ${GNAME_LINUX}
bzip2 -9k ${GNAME_LINUX}

ls -al ${DIST_PATH}

