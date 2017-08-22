PROJECT_NAME := framework
BATCH_BUILD=1
include $(IDF_PATH)/make/project.mk

MONO_OUTPUT_DIR := output
MONO_LIB_DIR := $(MONO_OUTPUT_DIR)
MONO_INCLUDE_DIR := $(MONO_LIB_DIR)/include
ESP_LIB_DIR := $(MONO_OUTPUT_DIR)/esp
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

# Remove non-existing include dirs and this "project" include (which is last).
INCLUDE_DIRS := $(wildcard $(filter-out $(lastword $(COMPONENT_INCLUDES)),$(COMPONENT_INCLUDES)))

component-headers:
	$(foreach dir,$(INCLUDE_DIRS),mkdir -p $(ESP_LIB_DIR)/$(subst $(IDF_PATH)/components/,,$(dir)); cp -R $(dir)/ $(ESP_LIB_DIR)/$(subst $(IDF_PATH)/components/,,$(dir));)
	find $(ESP_LIB_DIR) -name '*.h' -exec chmod -x '{}' ';'

esptool:
	cp $(IDF_PATH)/components/esptool_py/esptool/esptool.py $(ESP_LIB_DIR)/

debug:
	@echo INCLUDE_DIRS=$(INCLUDE_DIRS)
	@echo ESP_INCLUDE_DIR=$(foreach dir,$(INCLUDE_DIRS),$(subst $(IDF_PATH)/components/,,$(dir)))
