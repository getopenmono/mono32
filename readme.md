# Mono with ESP32

This is the [Mono Framework](http://developer.openmono.com) for [Mono](http://openmono.com) devices based on [ESP32](https://espressif.com/en/products/hardware/esp32/overview).

## Setup

The goal is to end up with a directories like

    xtensa-esp32-elf/
    esp-idf/
    mono32/

that is, the compiler tool chain, the [ESP libraries](https://github.com/espressif/esp-idf), and [Mono32 framework](https://github.com/getopenmono/mono32).  The important part is that your `PATH` must include the `xtensa-esp32-elf/bin` directory, and you must have an environment variable `IDF_PATH` pointing to the `esp-idf` directory.

To install the dependencies, see

- [Espressif IoT Development Framework](https://github.com/espressif/esp-idf).
- Tool chain: [MacOS](https://dl.espressif.com/dl/xtensa-esp32-elf-osx-1.22.0-61-gab8375a-5.2.0.tar.gz) or [Windows](http://esp-idf.readthedocs.io/en/latest/get-started/windows-setup.html) or [Linux](http://esp-idf.readthedocs.io/en/latest/get-started/linux-setup.html).

To update the dependencies, run `update-dependencies.sh`.

For single-step debugging etc., see [`debugging.md`](debugging.md).

## External documentation

- [Espressif IoT Development Framework](http://esp-idf.readthedocs.io/en/latest/).
- [Espressif Datasheets](https://espressif.com/en/products/hardware/esp32/resources).

## Plan

- [x] Create a build system that produces a trivial Mono framework, such that the framework and tool chain are the only dependencies needed to build applications and flash them to Mono32 hardware.
- [x] Setup continuous integration infrastructure to monitor and build when this repo changes.
- [ ] Make the trivial framework and Mono32 work with [OpenOCD](https://github.com/espressif/openocd-esp32) such that it is possible to single-step debug.
- [ ] Auto detect which serial port the Mono32 is running on so that one does not have to specify the port.
- [x] Make transfer speed (flash) configurable (`--baud 2000000`).
- [ ] Port one [app](http://kiosk.openmono.com) at a time to this new framework, building up the framework along the way.
- [x] Generate (parts of) `mono.mk` instead of hard-coding settings dug out from ESP-IDF.
- [ ] Cleanup non-header files, eg. in `console/`.
- [ ] Encapsulate ESP32 SPI to the screen into mbed spi.
- [ ] Autobuild a distributable bundle with the libs, headers, and xtensa-esp-elf tool chain.

----

[![Build Status](https://travis-ci.org/getopenmono/mono32.svg?branch=master)](https://travis-ci.org/getopenmono/mono32)
