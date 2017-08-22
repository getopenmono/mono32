BATCH_BUILD=1
include $(IDF_PATH)/make/project.mk

MONO_OUTPUT_DIR := output
MONO_LIB_DIR := $(MONO_OUTPUT_DIR)
MONO_INCLUDE_DIR := $(MONO_LIB_DIR)/include
ESP_LIB_DIR := $(MONO_OUTPUT_DIR)/esp
ESP_LDSCRIPT_DIR := $(ESP_LIB_DIR)/ld

MONO_SNIPPET := $(MONO_OUTPUT_DIR)/mono-env.mk

.PHONY: framework framework-clean debug components component-headers esptool snippets

framework: bootloader partition_table components component-headers esptool snippets
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

# Remove non-existing include dirs and this "project"'s' include (which is last in the list).
# This "project"'s' include containes configurations, and it will be added again later.
INCLUDE_DIRS := $(wildcard $(filter-out $(lastword $(COMPONENT_INCLUDES)),$(COMPONENT_INCLUDES)))

component-headers:
	$(foreach dir,$(INCLUDE_DIRS),mkdir -p $(ESP_LIB_DIR)/$(subst $(IDF_PATH)/components/,,$(dir)); cp -R $(dir)/ $(ESP_LIB_DIR)/$(subst $(IDF_PATH)/components/,,$(dir));)
	cp -R $(BUILD_DIR_BASE)/include $(ESP_LIB_DIR)/
	find $(ESP_LIB_DIR) -name '*.h' -exec chmod -x '{}' ';'

esptool:
	cp $(IDF_PATH)/components/esptool_py/esptool/esptool.py $(ESP_LIB_DIR)/

snippets:
	mkdir -p $(MONO_OUTPUT_DIR)
	@echo Creating $(MONO_SNIPPET)
	@echo '# Generated Mono framework environment.' > $(MONO_SNIPPET)
	@echo '' >> $(MONO_SNIPPET)
	@echo ESP_LIB_DIR := $$\(MONO_PATH\)/esp >> $(MONO_SNIPPET)
	@echo ESP_LDSCRIPT_DIR := $$\(ESP_LIB_DIR\)/ld >> $(MONO_SNIPPET)
	@echo ESP_INCLUDE_DIRS := $(foreach dir,$(INCLUDE_DIRS),$(subst $(IDF_PATH)/components/,$$\(ESP_LIB_DIR\)/,$(dir))) $$\(ESP_LIB_DIR\)/include >> $(MONO_SNIPPET)
	@echo CC := $(CC) >> $(MONO_SNIPPET)
	@echo CXX := $(CXX) >> $(MONO_SNIPPET)
	@echo LD := $(LD) >> $(MONO_SNIPPET)
	@echo export CC CXX LD >> $(MONO_SNIPPET)
	@echo CPPFLAGS := -DESP_PLATFORM -D IDF_VER="v3.0-dev-265-g969f1bb9" -MMD -MP >> $(MONO_SNIPPET)
	@echo CFLAGS := -std=gnu99 -Og -ggdb -ffunction-sections -fdata-sections -fstrict-volatile-bitfields -mlongcalls -nostdlib -Wall -Werror=all -Wno-error=unused-function -Wno-error=unused-but-set-variable -Wno-error=unused-variable -Wno-error=deprecated-declarations -Wextra -Wno-unused-parameter -Wno-sign-compare -Wno-old-style-declaration -DWITH_POSIX -DMBEDTLS_CONFIG_FILE="mbedtls/esp_config.h" -DHAVE_CONFIG_H >> $(MONO_SNIPPET)
	@echo CXXFLAGS := -std=gnu++11 -fno-exceptions -fno-rtti -Og -ggdb -ffunction-sections -fdata-sections -fstrict-volatile-bitfields -mlongcalls -nostdlib -Wall -Werror=all -Wno-error=unused-function -Wno-error=unused-but-set-variable -Wno-error=unused-variable -Wno-error=deprecated-declarations -Wextra -Wno-unused-parameter -Wno-sign-compare >> $(MONO_SNIPPET)
	@echo export CPPFLAGS CFLAGS CXXFLAGS >> $(MONO_SNIPPET)
	@echo INCFLAGS := -I $$\(MONO_PATH\) $$\(foreach dir,$$\(ESP_INCLUDE_DIRS\),-I $$\(dir\)\) >> $(MONO_SNIPPET)
	@echo LDFLAGS := -nostdlib -u call_user_start_cpu0 -Wl,--gc-sections -Wl,-static -Wl,--start-group \
		-L$$\(ESP_LIB_DIR\) \
			-lapp_trace -lapp_update -lbootloader_support -lbt -lcoap -ldriver -lesp32 -lethernet -lexpat -lfatfs -lheap -ljsmn -ljson -llibsodium -llog -llwip -lmbedtls -lmdns -lmicro-ecc -lnewlib -lnghttp -lnvs_flash -lopenssl -lsdmmc -lsoc \
			-lspi_flash -ltcpip_adapter -lulp -lvfs -lwear_levelling -lwpa_supplicant -lxtensa-debug-module \
			-lhal \
			-lcxx -u __cxa_guard_dummy \
			-lfreertos -Wl,--undefined=uxTopUsedPriority \
			-lcore -lrtc -lphy -lcoexist -lnet80211 -lpp -lwpa -lsmartconfig -lcoexist -lwps -lwpa2 \
			-lc -lm \
		-L$$\(ESP_LDSCRIPT_DIR\) \
			-T esp32_out.ld -u ld_include_panic_highint_hdl -T esp32.common.ld -T esp32.rom.ld -T esp32.peripherals.ld \
		-lgcc -lstdc++ -Wl,--end-group -Wl,-EL \
	>> $(MONO_SNIPPET)
	cp mono.mk $(MONO_OUTPUT_DIR)/

debug:
	@echo INCLUDE_DIRS=$(INCLUDE_DIRS)
	@echo ESP_INCLUDE_DIR=$(foreach dir,$(INCLUDE_DIRS),$(subst $(IDF_PATH)/components/,esp/,$(dir)))
	@echo COMPONENT_INCLUDES=$(COMPONENT_INCLUDES)
