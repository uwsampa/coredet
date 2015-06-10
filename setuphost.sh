#!/bin/bash

ROOT=`pwd`

LLVMSRC=/nvtmp/build-tbergan/coredet/llvm-src
LLVMGCC=/nvtmp/build-tbergan/coredet/llvm-gcc
POOLSRC=/nvtmp/build-tbergan/coredet/llvm-poolalloc
INSTALL=/nvtmp/build-tbergan/coredet/llvm-install
PARSECBUILD=/nvtmp/build-tbergan/coredet/parsec
PARSECINPUTS=/sampa/share/parsec-inputs

if [ ! -d /nvtmp ]; then
	echo "/nvtmp doesn't exist"
	exit 1
fi

if [ ! -d src/benchmarks/parsec ]; then
	echo "Script run from wrong directory"
	exit 1
fi

mkdir -p /nvtmp/build-tbergan/coredet

echo "Downloading LLVM ..."
svn co http://llvm.org/svn/llvm-project/llvm/branches/release_29 $LLVMSRC

echo "Downloading LLVM-gcc ..."
svn co http://llvm.org/svn/llvm-project/llvm-gcc-4.2/branches/release_29 $LLVMGCC

echo "Downloading LLVM-poolalloc ..."
#svn co http://llvm.org/svn/llvm-project/poolalloc/branches/release_29 $POOLSRC
cp -R ~/testing/src/llvm-poolalloc $POOLSRC

echo "Linking CoreDet to LLVM ..."
cd src/compiler
./link-to-llvm.sh $LLVMSRC
./link-poolalloc-to-llvm.sh $LLVMSRC $POOLSRC

echo "Linking CoreDet to parsec inputs ..."
cd $ROOT
cd src/benchmarks/parsec
./link-to-inputs.sh $PARSECINPUTS

echo "Building LLVM ..."
cd $LLVMSRC
./configure --enable-optimized --with-llvmgccdir=$INSTALL --prefix=$INSTALL
make -j 8
make -j 8 install

echo "Building LLVM-gcc ..."
cd $LLVMGCC
mkdir -p obj
cd obj
../configure --prefix=$INSTALL --enable-llvm=$LLVMSRC --disable-bootstrap \
             --program-prefix=llvm- --enable-languages=c,c++
make -j 8
make -j 8 install

echo "Making parsec build directories ..."
cd $ROOT
cd src/benchmarks/parsec
mkdir -p $PARSECBUILD

for p in `ls pkgs`; do
	for d in `ls pkgs/$p`; do
		for s in "inst" "obj" "run"; do
			sub=pkgs/$p/$d/$s
			echo "LINK: $sub"
			mkdir -p $PARSECBUILD/$sub
			ln -s $PARSECBUILD/$sub $sub
		done
	done
done

echo "LINK: log"
mkdir -p $PARSECBUILD/log
ln -s $PARSECBUILD/log log

echo "Done!"
cd $ROOT
