#!/bin/sh
set -e # To stop as soon as an error occured
sudo apt-get install -y bison flex gzip gcc-multilib libz1 libncurses5 libbz2-1.0 make

export IDIR=$PWD"/build"
cd build/

if [ ! -f "simplesim-3v0e.tgz" ]
then
    TEXT="Download  http://www.simplescalar.com/agreement.php3?simplesim-3v0e.tgz\n- Place the archive in the build/ directory.\n- Launch this script again"
    echo -e $TEXT
    exit 1
fi

wget http://www.simplescalar.com/downloads/simpletools-2v0.tgz
wget http://www.simplescalar.com/downloads/simpleutils-2v0.tgz

gunzip  *.tgz
tar -xf simpletools-*.tar
tar -xf simpleutils-*.tar
tar -xf simplesim-*.tar

cd binutils-*

export HOST=i386-pc-linux

./configure --host=$HOST --target=sslittle-na-sstrix --with-gnu-as --with-gnu-ld --prefix=$IDIR

sed -i -e "s/va_list ap = args;/va_list ap; va_copy(ap, args);/g" libiberty/vasprintf.c

sed -i -e "s/char \*malloc ();/\/\/char \*malloc ();/g" libiberty/vasprintf.c

sed -i -e "s/#if CLOCKS_PER_SEC <= 1000000/#define CLOCKS_PER_SEC_SUPPOSED ((clock)1000000)\n#if #CLOCKS_PER_SEC == #CLOCKS_PER_SEC_SUPPOSED\n#define CLOCKS_PER_SEC 1000000\n#endif\n#if CLOCKS_PER_SEC <= 1000000/g" libiberty/getruntime.c

sed -i -e "s/yy_current_buffer/YY_CURRENT_BUFFER/g" ld/ldlex.l
sed -i -e "s/varargs.h/stdarg.h/g" ld/ldmisc.c

sed -i -e "s/  va_list arg;/\/\/  va_list arg;/g" ld/ldmisc.c
sed -i -e "s/  va_start/\/\/  va_start/g" ld/ldmisc.c
sed -i -e "s/  file/\/\/  file/g" ld/ldmisc.c
sed -i -e "s/  fmt/\/\/  fmt/g" ld/ldmisc.c
sed -i -e "s/  vfinfo/\/\/  vfinfo/g" ld/ldmisc.c
sed -i -e "s/  va_end/\/\/  va_end/g" ld/ldmisc.c

sed -i -e "s/(va_alist)/()/g" ld/ldmisc.c
sed -i -e "s/     va_dcl/\/\/     va_dcl/g" ld/ldmisc.c
sed -i -e "s/     FILE \*fp;/\/\/     FILE \*fp;/g" ld/ldmisc.c
sed -i -e "s/     char \*fmt;/\/\/     char \*fmt;/g" ld/ldmisc.c
sed -i -e "s/vfinfo(fp, fmt, arg)/vfinfo(FILE \*fp, char \*fmt, va_list arg)/g" ld/ldmisc.c

sed -i -e "s/NEED_sys_errlist/NEED_sys_errPROTECTEDlist/g" libiberty/strerror.c
sed -i -e "s/sys_nerr/sys_nerr_2/g" libiberty/strerror.c
sed -i -e "s/sys_errlist/sys_errlist_2/g" libiberty/strerror.c
sed -i -e "s/NEED_sys_errPROTECTEDlist/NEED_sys_errlist/g" libiberty/strerror.c

make all
make install


cd ../simplesim*
make config-pisa
make
# You can check that SimpleScalar (not the toolchain) works with the command-line:
# ./sim-safe tests-alpha/bin/test-math

cd ../
cd gcc-*

./configure --host=$HOST --target=sslittle-na-sstrix --with-gnu-as --with-gnu-ld --prefix=$IDIR

sed -i 's/return \\"FIXME\\\\n/return \\"FIXME\\\\n\\\\/g' config/ss/ss.md
#sed -i 's/return \"FIXME\\n/return \"FIXME\\n\\/g' insn-output.c

set +e
make LANGUAGES="c c++" CFLAGS="-O3" CC="gcc"
set -e

sed -i 's/^inline$//g' cp/input.c
sed -i 's/^inline$//g' cp/hash.h
sed -i 's/^__inline$//g' cp/lex.c

sed -i -e "s/\*((void \*\*)__o->next_free)++ = ((void \*)datum);/\*((void \*\*)__o->next_free++) = ((void \*)datum);/g" obstack.h

sed -i -e "s/#include <syms.h>/#include \"gsyms.h\"/g" sdbout.c

sed -i -e "s/extern char \*sys_errlist\[\];/\/\/extern const char \* const sys_errlist\[\];/g" cccp.c
sed -i -e "s/extern char \*sys_errlist\[\];/\/\/extern char \*sys_errlist\[\];/g" cp/g++.c
sed -i -e "s/extern char \*sys_errlist\[\];/\/\/extern char \*sys_errlist\[\];/g" gcc.c

make LANGUAGES="c c++" CFLAGS="-O3" CC="gcc"
make install LANGUAGES="c c++" CFLAGS="-O3" CC="gcc"

echo 'PATH='$IDIR'/bin:$PATH' >> ~/.bashrc
cd ../simplesim-*
echo 'PATH='$IDIR':$PATH' >> ~/.bashrc

echo "Praise B-Jesus!!!!"
echo "Execute: source ~/.bashrc to reset global variables"
echo "Test\n Compile: sslittle-na-sstrix-gcc -x c++ main.c -o main inside the example folder"
echo "Execution: ../build/simplesim-3.0/sim-safe main"
