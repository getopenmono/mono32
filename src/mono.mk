# macro to remove quotes from an argument, ie $(call dequote,$(CONFIG_BLAH))
define dequote
$(subst ",,$(1))
endef
# " comment kept here to keep syntax highlighting happy

CONFIG_TOOLPREFIX="xtensa-esp32-elf-"
CC := $(call dequote,$(CONFIG_TOOLPREFIX))gcc
CXX := $(call dequote,$(CONFIG_TOOLPREFIX))c++
LD := $(call dequote,$(CONFIG_TOOLPREFIX))ld
export CC CXX LD

MONO_OUTPUT_DIR := $(MONO_PATH)/output
MONO_LIB_DIR := $(MONO_OUTPUT_DIR)
MONO_INCLUDE_DIR := $(MONO_LIB_DIR)/include
ESP_LIB_DIR := $(MONO_OUTPUT_DIR)/esp
# Wrong:
ESP_INCLUDE_DIR := $(wildcard $(ESP_LIB_DIR)/*/include)
ESP_LDSCRIPT_DIR := $(ESP_LIB_DIR)/ld

LDFLAGS=-nostdlib -u call_user_start_cpu0 -Wl,--gc-sections -Wl,-static -Wl,--start-group \
	-L$(ESP_LIB_DIR) \
		-lapp_trace -lapp_update -lbootloader_support -lbt -lcoap -ldriver -lesp32 -lethernet -lexpat -lfatfs -lheap -ljsmn -ljson -llibsodium -llog -llwip -lmbedtls -lmdns -lmicro-ecc -lnewlib -lnghttp -lnvs_flash -lopenssl -lsdmmc -lsoc \
		-lspi_flash -ltcpip_adapter -lulp -lvfs -lwear_levelling -lwpa_supplicant -lxtensa-debug-module \
		-lhal \
		-lcxx -u __cxa_guard_dummy \
		-lfreertos -Wl,--undefined=uxTopUsedPriority \
		-lcore -lrtc -lphy -lcoexist -lnet80211 -lpp -lwpa -lsmartconfig -lcoexist -lwps -lwpa2 \
		-lc -lm \
		-L$(ESP_LDSCRIPT_DIR) -T esp32_out.ld -u ld_include_panic_highint_hdl -T esp32.common.ld -T esp32.rom.ld -T esp32.peripherals.ld \
	-lgcc -lstdc++ -Wl,--end-group -Wl,-EL

CPPFLAGS=-DESP_PLATFORM -D IDF_VER="v3.0-dev-265-g969f1bb9" -MMD -MP
CFLAGS=-std=gnu99 -Og -ggdb -ffunction-sections -fdata-sections -fstrict-volatile-bitfields -mlongcalls -nostdlib -Wall -Werror=all -Wno-error=unused-function -Wno-error=unused-but-set-variable -Wno-error=unused-variable -Wno-error=deprecated-declarations -Wextra -Wno-unused-parameter -Wno-sign-compare -Wno-old-style-declaration -DWITH_POSIX -DMBEDTLS_CONFIG_FILE="mbedtls/esp_config.h" -DHAVE_CONFIG_H
CXXFLAGS=-std=gnu++11 -fno-exceptions -fno-rtti -Og -ggdb -ffunction-sections -fdata-sections -fstrict-volatile-bitfields -mlongcalls -nostdlib -Wall -Werror=all -Wno-error=unused-function -Wno-error=unused-but-set-variable -Wno-error=unused-variable -Wno-error=deprecated-declarations -Wextra -Wno-unused-parameter -Wno-sign-compare
export CPPFLAGS CFLAGS CXXFLAGS

INCFLAGS=-I $(MONO_INCLUDE_DIR) -I $(ESP_INCLUDE_DIR)
