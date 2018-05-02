FROM ubuntu:16.04

RUN apt-get update && apt-get install -y curl xz-utils build-essential unzip

RUN    mkdir -p /rpi/ghc/ \
    && curl -sSL http://releases.mobilehaskell.org/x86_64-linux/9824f6e473/ghc-8.4.0.20180109-arm-linux-gnueabihf.tar.xz -o ghc.tar.xz\
    && tar -xvf ghc.tar.xz -C /rpi/ghc/\
    && rm -f ghc.tar.xz

RUN    mkdir -p /rpi/prebuilt/ \
    && curl -sSL http://releases.llvm.org/5.0.0/clang+llvm-5.0.0-linux-x86_64-ubuntu16.04.tar.xz -o llvm.tar.xz\
    && tar -xvf llvm.tar.xz -C /rpi/prebuilt/ --strip-components=1\
    && rm -f llvm.tar.xz

RUN mkdir -p /binutils/ \
    && curl -sSL http://ftp.gnu.org/gnu/binutils/binutils-2.30.tar.xz -o binutils.tar.xz\
    && tar -xvf binutils.tar.xz -C /binutils/ --strip-components=1\
    && rm -f binutils.tar.xz

RUN cd /binutils/\
    && ./configure --prefix="/rpi/prebuilt" \
            --target=arm-linux-gnueabihf \
            --enable-gold=yes \
            --enable-ld=yes \
            --enable-targets=arm-linux-gnueabihf \
            --enable-multilib \
            --enable-interwork \
            --disable-werror \
            --quiet\
   && make && make install

RUN    mkdir -p /rpi/prebuilt/arm-linux-gnueabihf/ \
    && curl -sSL https://github.com/zw3rk/toolchain-wrapper/archive/master.zip -o toolchain-wrapper.zip \
    && unzip -j -d /rpi/prebuilt/arm-linux-gnueabihf/bin/ toolchain-wrapper.zip\
    && rm -f toolchain-wrapper.zip

ADD raspberrypi-toolchain.config /rpi/prebuilt/arm-linux-gnueabihf/bin/
RUN cd /rpi/prebuilt/arm-linux-gnueabihf/bin && /rpi/prebuilt/arm-linux-gnueabihf/bin/bootstrap

ENV PATH "/rpi/prebuilt/bin:/rpi/prebuilt/arm-linux-gnueabihf/bin:/rpi/ghc/bin:${PATH}"
RUN mkdir -p /rpi/sysroot/


