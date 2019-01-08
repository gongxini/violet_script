 #!/bin/bash

ME="$(whoami)"
################# Installation of stp  ###############################
sudo apt-get install sudo build-essential curl libcap-dev git cmake libncurses5-dev python-minimal python-pip unzip libtcmalloc-minimal4 libgoogle-perftools-dev
sudo apt-get install cmake bison flex libboost-all-dev python perl zlib1g-dev

mkdir /home/"$ME"/software/stp
mkdir /home/"$ME"/software/stp/2.1.2
mkdir /home/"$ME"/software/stp/minisat

cd /home/"$ME"/source
mkdir stp
cd stp
git clone https://github.com/stp/minisat.git
cd minisat
mkdir build
cd build

cmake -DSTATIC_BINARIES=ON -DCMAKE_INSTALL_PREFIX=/home/yigonghu/software/stp/minisat/ ../
make -j 16
sudo make install

cd ../../
git clone https://github.com/stp/stp.git 2.1.2
cd 2.1.2
git checkout tags/2.1.2
mkdir build 
cd build
export PATH=$HOME/software/stp/minisat/bin:$PATH
cmake -DBUILD_SHARED_LIBS:BOOL=OFF -DENABLE_PYTHON_INTERFACE:BOOL=OFF -DCMAKE_INSTALL_PREFIX=/home/"$ME"/software/stp/2.1.2/ ..
make
sudo make install
cd ..

################# Installation of klee  ###############################

mkdir /home/"$ME"/software/klee

cd /home/"$ME"/source
mkdir klee
cd klee

git clone https://github.com/klee/klee-uclibc.git 
cd klee-uclibc 
./configure --make-llvm-lib 
make -j2 
cd .. 

curl -OL https://github.com/google/googletest/archive/release-1.7.0.zip
unzip release-1.7.0.zip

sudo pip install lit

git clone https://github.com/klee/klee.git
cd klee
mkdir build
cd build
export PATH=$HOME/software/stp/2.1.2/bin:$PATH
CXXFLAGS="-D_GLIBCXX_USE_CXX11_ABI=0" cmake  -DENABLE_SOLVER_STP=ON -DENABLE_POSIX_RUNTIME=ON -DENABLE_KLEE_UCLIBC=ON -DKLEE_UCLIBC_PATH=../../klee-uclibc -DGTEST_SRC_DIR=../../googletest-release-1.7.0 -DCMAKE_INSTALL_PREFIX=/home/"$ME"/software/klee/ -DENABLE_SYSTEM_TESTS=ON -DENABLE_UNIT_TESTS=ON ../
make
sudo make install
make systemtests
make unittests
