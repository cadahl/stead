#!/bin/bash
rm *~
xbuild /p:Configuration=Release All.sln
rm -rf deploy/*
cp bin/Release/*.exe deploy/
cp bin/Release/*.dll deploy/
cp -P libmdwrkapi/libmdwrkapi.so* deploy/ 
cp bin/external/libczmq.so deploy/
cd deploy
tar acvf stead.tar.bz2 *
cd ..
