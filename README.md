
Dockerfile to cross compile Haskell to Raspberry Pi
===================================================

Follow the [instructions by zw3rk](https://medium.com/@zw3rk/making-a-raspbian-cross-compilation-sdk-830fe56d75ba)
to get the sysroot from your Raspberry Pi for the libraries:

      mkdir sysroot
      rsync -rzLR --safe-links \
          pi@raspberrypi:/usr/lib/arm-linux-gnueabihf \
          pi@raspberrypi:/usr/lib/gcc/arm-linux-gnueabihf \
          pi@raspberrypi:/usr/include \
          pi@raspberrypi:/lib/arm-linux-gnueabihf \
          sysroot/

Use the prebuilt docker image

    docker run --rm -it -v $(pwd)/sysroot/:/rpi/sysroot/ tritlo/ghc-to-rpi

or build the container with:
  
    docker build -t ghc-to-rpi .

Then run it with:

    docker run --rm -it -v $(pwd)/sysroot/:/rpi/sysroot/ ghc-to-rpi

And you can now cross-compile with

    arm-linux-gnueabihf-ghc 

and use `cabal` with

    arm-linux-gnueabihf-cabal
