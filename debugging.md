# Debugging

Install OpenOCD next to the other tools:

	$ cd ..
	$ git clone --recursive https://github.com/espressif/openocd-esp32.git
    $ brew install openocd

You might need to unload the FTDI driver:

    $ sudo kextunload FTDIUSBSerialDriver.kext          // Linux
    $ sudo kextunload -b com.apple.driver.AppleUSBFTDI  // MacOS

Install board configuration:

    $ cp openocd-esp32/tcl/target/esp32.cfg /usr/local/share/openocd/scripts/board/

## External documentation

- [ESP32 JTAG debugging](https://github.com/espressif/esp-idf/blob/master/docs/api-guides/jtag-debugging/index.rst).
- [OpenOCD-ESP32](https://github.com/espressif/openocd-esp32).
