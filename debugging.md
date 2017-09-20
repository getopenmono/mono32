# Debugging

See https://github.com/espressif/openocd-esp32/issues/18

Install OpenOCD next to the other tools:

	$ cd ..
    $ wget https://dl.espressif.com/dl/openocd-esp32-macos-a859564.tar.gz
	$ tar xfz openocd-esp32-macos-a859564.tar.gz

You might need to unload the FTDI driver:

    $ sudo kextunload FTDIUSBSerialDriver.kext          // Linux
    $ sudo kextunload -b com.apple.driver.AppleUSBFTDI  // MacOS

## Configure and connect JTAG interface

{Need a supported JTAG adapter. jlink. FT232R USB UART}

{segger?}

## Run OpenOCD

Copy & modify the board/esp-wroom-32.cfg file to read

    transport select jtag
    adapter_khz 20000
    set ESP32_ONLYCPU 1
    set ESP32_RTOS none
    source [find target/esp32.cfg]

The options

    set ESP32_ONLYCPU 1
    set ESP32_RTOS none

makes it simpler to debug ony the app.

Then start

    $ bin/openocd -s share/openocd/scripts -f interface/jlink.cfg -f board/esp-wroom-32.cfg

should give

    Info : No device selected, using first device.
    Info : J-Link compiled Mar 29 2006 19:58:46 ARM Rev.5
    Info : Hardware version: 5.30
    Info : VTarget = 3.300 V
    Info : Reduced speed from 20000 kHz to 12000 kHz (maximum).
    Info : Reduced speed from 20000 kHz to 12000 kHz (maximum).
    Info : clock speed 20000 kHz
    Info : JTAG tap: esp32.cpu0 tap/device found: 0x120034e5 (mfg: 0x272 (Tensilica), part: 0x2003, ver: 0x1)
    Info : JTAG tap: esp32.ignored tap/device found: 0x120034e5 (mfg: 0x272 (Tensilica), part: 0x2003, ver: 0x1)
    Info : esp32.cpu0: Target halted, pc=0x400D0920

## Using the debugger

http://esp-idf.readthedocs.io/en/latest/api-guides/jtag-debugging/using-debugger.html#command-line

Create file `gdbinit`:

    target remote :3333
    mon reset halt
    thb app_main
    x $a1=0
    c

Start debugger

    $ xtensa-esp32-elf-gdb -x gdbinit build/my-app.elf

gives output in GDB:

    JTAG tap: esp32.cpu0 tap/device found: 0x120034e5 (mfg: 0x272 (Tensilica), part: 0x2003, ver: 0x1)
    JTAG tap: esp32.ignored tap/device found: 0x120034e5 (mfg: 0x272 (Tensilica), part: 0x2003, ver: 0x1)
    esp32.cpu0: Debug controller was reset (pwrstat=0x5F, after clear 0x0F).
    esp32.cpu0: Core was reset (pwrstat=0x5F, after clear 0x0F).
    esp32.cpu0: Target halted, pc=0x5000004B
    esp32.cpu0: target state: halted
    esp32.cpu0: Core was reset (pwrstat=0x1F, after clear 0x0F).
    esp32.cpu0: Target halted, pc=0x40000400
    esp32.cpu0: target state: halted
    Hardware assisted breakpoint 1 at 0x400d0884: file display.c, line 258.
    0x0:    0x00000000
    esp32.cpu0: Target halted, pc=0x400D0884

gives OCD output:

    Info : accepting 'gdb' connection on tcp/3333
    Info : Target halted. PRO_CPU: PC=0x4000940E (active)    APP_CPU: PC=0x00000000 
    esp32: target state: halted
    Info : Use core0 of target 'esp32'
    Info : Target halted. PRO_CPU: PC=0x40091D07 (active)    APP_CPU: PC=0x00000000 
    Info : Auto-detected flash size 4096 KB
    Info : Using flash size 4096 KB
    Info : Set current thread to 0x00000000, old= 0x00000000
    openocd(4701,0x7fffa7b063c0) malloc: *** mach_vm_map(size=18446744027419164672) failed (error code=3)
    *** error: can't allocate region
    *** set a breakpoint in malloc_error_break to debug
    Error: Error allocating memory for -1446574693 threads
    Info : JTAG tap: esp32.cpu0 tap/device found: 0x120034e5 (mfg: 0x272 (Tensilica), part: 0x2003, ver: 0x1)
    Info : JTAG tap: esp32.cpu1 tap/device found: 0x120034e5 (mfg: 0x272 (Tensilica), part: 0x2003, ver: 0x1)
    Info : esp32: Debug controller was reset (pwrstat=0x5F, after clear 0x0F).
    Info : esp32: Core was reset (pwrstat=0x5F, after clear 0x0F).
    Info : Target halted. PRO_CPU: PC=0x5000004B (active)    APP_CPU: PC=0x00000000 
    esp32: target state: halted
    Info : esp32: Core was reset (pwrstat=0x1F, after clear 0x0F).
    Info : Target halted. PRO_CPU: PC=0x40000400 (active)    APP_CPU: PC=0x40000400 
    esp32: target state: halted


## External documentation

- [ESP32 JTAG debugging](https://github.com/espressif/esp-idf/blob/master/docs/api-guides/jtag-debugging/index.rst).
- [OpenOCD-ESP32](https://github.com/espressif/openocd-esp32).
- [Workarounds](http://espressif.com/sites/default/files/documentation/eco_and_workarounds_for_bugs_in_esp32_en.pdf)

Install board configuration:

    $ cp openocd-esp32/tcl/target/esp32.cfg /usr/local/share/openocd/scripts/board/

