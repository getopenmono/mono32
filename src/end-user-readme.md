# Mono32 Framework

## Usage

In your project, create a Makefile like this:

    MONO_APP := my-app
    MONO_PATH=/usr/local/openmono
    include $(MONO_PATH)/mono.mk
    export SERIAL_PORT=/dev/cu.usbserial-A6007v3M

Then you can simply run

    $ make

to compile a binary app (`.bin`).  To transfer the app to your Mono32, run

    $ make flash

If you do not want the serial port embedded in the makefile, you can get awaty with specifying it at the command line when you flash your Mono32:

    $ SERIAL_PORT=/dev/cu.usbserial-A6007v3M make flash

If your serial cable can handle it, you can speed up transfer time by

    $ BAUD_RATE=2000000 make flash
