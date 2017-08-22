# Use like this in your Makefile:
#     MONO_PATH=/usr/local/openmono
#     include $(MONO_PATH)/mono.mk

include $(MONO_PATH)/mono-env.mk

.PHONY: all flash clean debug

BUILD_DIR ?= build
MKDIR ?= mkdir -p
RM_F ?= rm -f
RM_RF ?= rm -rf

C_SOURCES := $(wildcard *.c)
CPP_SOURCES := $(wildcard *.cpp)
HEADERS := $(wildcard *.h) $(wildcard *.hpp)
OBJECTS := $(patsubst %.c,$(BUILD_DIR)/%.o,$(C_SOURCES)) $(patsubst %.cpp,$(BUILD_DIR)/%.o,$(CPP_SOURCES))


all: $(BUILD_DIR)/$(MONO_APP).bin

$(BUILD_DIR)/%.o: %.c $(HEADERS)
	echo "Compiling C: $<"
	$(MKDIR) $(dir $@)
	$(CC) -c $(CPPFLAGS) $(CFLAGS) $(INCFLAGS) -o $@ $<

$(BUILD_DIR)/%.o: %.cpp $(HEADERS)
	echo "Compiling C++: $<"
	$(MKDIR) $(dir $@)
	$(CC) -c $(CPPFLAGS) $(CXXFLAGS) $(INCFLAGS) -o $@ $<

$(BUILD_DIR)/$(MONO_APP).elf: $(OBJECTS)
	$(CC) $^ $(LDFLAGS) -o $@ -Wl,-Map=$(BUILD_DIR)/$(MONO_APP).map

$(BUILD_DIR)/$(MONO_APP).bin: $(BUILD_DIR)/$(MONO_APP).elf
	python $(ESP_LIB_DIR)/esptool.py \
		--chip esp32 \
		elf2image \
		--flash_mode dio \
		--flash_freq 40m \
		--flash_size 2MB \
		-o $@ \
		$<

flash: $(BUILD_DIR)/$(MONO_APP).bin
	python $(ESP_LIB_DIR)/esptool.py \
		--chip esp32 \
		--port $${SERIAL_PORT:?not set} \
		--baud 115200 \
		--before default_reset \
		--after hard_reset write_flash \
		-z \
		--flash_mode dio \
		--flash_freq 40m \
		--flash_size detect \
		0x1000 $(ESP_LIB_DIR)/bootloader.bin \
		0x8000 $(ESP_LIB_DIR)/partitions_singleapp.bin \
		0x10000 $<

clean:
	$(RM_RF) $(BUILD_DIR)

debug:
	@echo C_SOURCES = $(C_SOURCES)
	@echo CPP_SOURCES = $(CPP_SOURCES)
	@echo HEADERS = $(HEADERS)
	@echo OBJECTS = $(OBJECTS)
