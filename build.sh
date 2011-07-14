#!/bin/bash

PUBLISH=0
while getopts ":p" opt; do
  case $opt in
    p)
      PUBLISH=1
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      ;;
  esac
done
                                    
echo "Building"
xbuild /verbosity:quiet /nologo /p:Configuration=Release All.sln
rm -rf deploy/*

echo "Copying"
echo "  binaries"
cp bin/Release/*.exe deploy/
cp bin/Release/*.dll deploy/

echo "  libmdwrkapi"
cp -P libmdwrkapi/libmdwrkapi.so* deploy/ 

echo "  libczmq"
cp bin/external/libczmq.so deploy/

echo "Compressing"
cd deploy
tar acvf stead.tar.bz2 * > /dev/null
cd ..
echo "  done"

if [ $PUBLISH -eq 1 ]
  then
    echo "Publishing" 
    ssh carl@adahl.dyndns.org cat < deploy/stead.tar.bz2 ">" /home/carl/stead/stead.tar.bz2
    echo "  done"
fi
 
