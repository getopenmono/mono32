PROJECT_NAME := framework
BATCH_BUILD=1
include $(IDF_PATH)/make/project.mk

MONO_OUTPUT_DIR := output
MONO_LIB_DIR := $(MONO_OUTPUT_DIR)
MONO_INCLUDE_DIR := $(MONO_LIB_DIR)/include
ESP_LIB_DIR := $(MONO_OUTPUT_DIR)/esp
ESP_INCLUDE_DIR := $(ESP_LIB_DIR)/include
ESP_LDSCRIPT_DIR := $(ESP_LIB_DIR)/ld

.PHONY: framework framework-clean debug components component-headers esptool

framework: bootloader partition_table components component-headers esptool
	mkdir -p $(ESP_LIB_DIR)
	cp $(BUILD_DIR_BASE)/bootloader/bootloader.bin $(ESP_LIB_DIR)/
	cp $(BUILD_DIR_BASE)/partitions_singleapp.bin $(ESP_LIB_DIR)/

framework-clean:
	rm -rf $(MONO_OUTPUT_DIR) $(BUILD_DIR_BASE) *.old

sdkconfig: defconfig
	@echo $(SEPARATOR)
	@echo If the above gave errors, you can most likely ignore them.

INCLUDE_DIRS := $(wildcard $(COMPONENT_INCLUDES))

components: $(foreach component,$(COMPONENT_PATHS),component-$(notdir $(component)-build))
	mkdir -p $(ESP_LIB_DIR)
	cp $(foreach libcomp,$(COMPONENT_LIBRARIES),$(BUILD_DIR_BASE)/$(libcomp)/lib$(libcomp).a) $(ESP_LIB_DIR)/
	cp $(IDF_PATH)/components/esp32/libhal.a $(ESP_LIB_DIR)/
	cp $(IDF_PATH)/components/newlib/lib/*.a $(ESP_LIB_DIR)/
	cp $(IDF_PATH)/components/esp32/lib/*.a $(ESP_LIB_DIR)/
	mkdir -p $(ESP_LDSCRIPT_DIR)
	cp $(BUILD_DIR_BASE)/esp32/*.ld $(ESP_LDSCRIPT_DIR)/
	cp $(IDF_PATH)/components/esp32/ld/*.ld $(ESP_LDSCRIPT_DIR)/
	find $(ESP_LIB_DIR) \( -name '*.ld' -o -name '*.a' \) -exec chmod -x '{}' ';'

component-headers:
	mkdir -p $(ESP_INCLUDE_DIR)
	cp -r $(foreach dir,$(INCLUDE_DIRS),$(dir)/*) $(ESP_INCLUDE_DIR)/
	find $(ESP_INCLUDE_DIR) -type f -exec chmod -x '{}' ';'

esptool:
	cp $(IDF_PATH)/components/esptool_py/esptool/esptool.py $(ESP_LIB_DIR)/

debug:
	@echo Component paths: $(COMPONENT_PATHS)
	@echo Components: $(foreach component,$(COMPONENT_PATHS),$(notdir $(component)))
	@echo $(SEPARATOR)
	@echo CPPFLAGS=$(CPPFLAGS)
	@echo CFLAGS=$(CFLAGS)
	@echo CXXFLAGS=$(CXXFLAGS)
	@echo $(SEPARATOR)
	@echo LDFLAGS=$(LDFLAGS)
	@echo CC=$(CC)
	@echo CXX=$(CXX)
	@echo LD=$(LD)
	@echo AR=$(AR)
	@echo OBJCOPY=$(OBJCOPY)
	@echo SIZE=$(SIZE)
