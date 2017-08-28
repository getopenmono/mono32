# Mono32 framework

The Mono32 framework is based on the [ESP libraries](https://github.com/espressif/esp-idf).  The result of building the framework is a set of static libraries and include files that constitutes the Mono32 framework.

To build the framework: `make framework`.

To clean: `make framework-clean`.

Note: Running just `make` will start ESP-IDF build procedure that expects this directory to be an app, which is is not, so that will not work.
