VER="11.7.11"
gcc -fPIC -c -Wall mdwrkapi.c
gcc -shared -lczmq -Wl,-soname,libmdwrkapi.so.1 -o libmdwrkapi.so.$VER mdwrkapi.o -lc
ln -fs libmdwrkapi.so.$VER libmdwrkapi.so
strip libmdwrkapi.so