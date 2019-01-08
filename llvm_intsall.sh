 #!/bin/bash

ME="$(whoami)"
################# Installation of binutils 2.31.51  ###############################
mkdir /home/"$ME"/software/binutils
mkdir /home/"$ME"/software/binutils/2.31.51
sudo apt-get install texinfo
cd /home/"$ME"/source
mkdir binutils
cd binutils
git clone --depth 1 git://sourceware.org/git/binutils-gdb.git 2.31.51
cd 2.31.51
mkdir build
cd build
../configure --prefix=/home/yigonghu/software/binutils/2.31.51 --enable-gold --enable-plugins --disable-werror
make -j 16
make install

cd /home/"$ME"/software/binutils/2.31.51/bin
mv ld ld.default
mv ld.gold ld

################# Installation of LLVM 5.0.0  ###############################
sudo apt install subversion cmake

mkdir /home/"$ME"/software/llvm
mkdir /home/"$ME"/software/llvm/5.0.0

cd /home/"$ME"/source
mkdir llvm
cd llvm
svn co http://llvm.org/svn/llvm-project/llvm/tags/RELEASE_500/final 5.0.0
cd 5.0.0/tools
svn co http://llvm.org/svn/llvm-project/cfe/tags/RELEASE_500/final clang
cd ..
cd tools/clang/tools
svn co http://llvm.org/svn/llvm-project/clang-tools-extra/tags/RELEASE_500/final extra
cd ../../..
cd projects
svn co http://llvm.org/svn/llvm-project/compiler-rt/tags/RELEASE_500/final compiler-rt
cd ..
cd projects
svn co http://llvm.org/svn/llvm-project/libcxx/tags/RELEASE_500/final libcxx
svn co http://llvm.org/svn/llvm-project/libcxxabi/tags/RELEASE_500/final libcxxabi
cd ..

mkdir build
cd ./build

cmake -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=Release -DLLVM_TARGETS_TO_BUILD="X86" -DCMAKE_INSTALL_PREFIX=/home/"$ME"/software/llvm/5.0.0 -DLLVM_BINUTILS_INCDIR=/home/"$ME"/software/binutils/2.31.51/include ../
make -j 16
sudo make install

cd /home/"$ME"/software/binutils/2.31.51/lib
mkdir bfd-plugins
ln -s /home/"$ME"/software/llvm/2.31.51/lib/LLVMgold.so

################ Installation of LLVM 3.4.0  ##############################


mkdir /home/"$ME"/software/llvm
mkdir /home/"$ME"/software/llvm/3.4.0

cd /home/"$ME"/source/llvm
svn co http://llvm.org/svn/llvm-project/llvm/tags/RELEASE_34/final 3.4.0
cd 3.4.0/tools
svn co http://llvm.org/svn/llvm-project/cfe/tags/RELEASE_34/final clang
cd ..
cd tools/clang/tools
svn co http://llvm.org/svn/llvm-project/clang-tools-extra/tags/RELEASE_34/final extra
cd ../../..
cd projects
svn co http://llvm.org/svn/llvm-project/compiler-rt/tags/RELEASE_34/final compiler-rt
cd ..
cd projects
svn co http://llvm.org/svn/llvm-project/libcxx/tags/RELEASE_34/final libcxx
svn co http://llvm.org/svn/llvm-project/libcxxabi/tags/RELEASE_30/final libcxxabi
cd ..

./configure --prefix=/home/"$ME"/software/llvm/3.4.0 --with-binutils-include=/home/yigonghu/software/binutils/2.31.51/include --enable-debug-symbols --enable-debug-runtime --enable-assertions --disable-optimized

make -j 16
make install

cd /home/"$ME"/software/binutils/2.31.51/lib
mkdir bfd-plugins
ln -s /home/"$ME"/software/llvm/2.31.51/lib/LLVMgold.so

make -j 16make -j 16
