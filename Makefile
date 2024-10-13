include ../Makefile.common

TI_DIR := ../ti-c6000-toolchain/c6000_7.4.24
TI_INC_DIR := $(TI_DIR)/include
TI_BIN_DIR := $(TI_DIR)/bin

SRC_DIR := ./protobuf-c
BUILD_DIR := ./build
LIB_DIR := ./lib

INCLUDES += $(TI_INC_DIR)

LIB = libprotobuf-c.lib
PROTOBUF_LIB = $(LIB_DIR)/$(LIB)

OBJECTS := $(patsubst $(SRC_DIR)/%.c,$(BUILD_DIR)/%.obj,$(shell find $(SRC_DIR) -type f -name "*.c"))

CC := $(TI_BIN_DIR)/cl6x
AR := $(TI_BIN_DIR)/ar6x

.PHONY: all clean

all:
	@make --silent -j"$(shell nproc)" $(PROTOBUF_LIB)

clean:
	@rm -rf "$(BUILD_DIR)" "$(PROTOBUF_LIB)"

$(BUILD_DIR)/%.obj: $(SRC_DIR)/%.c
	@echo "Building $@ from $<..."
	@mkdir -p "$(dir $@)"
	@$(CC) "$<" $(CFLAGS) -fr"$(dir $@)"

$(PROTOBUF_LIB): $(OBJECTS)
	@echo "Building $@ from $<..."
	@mkdir -p "$(dir $@)"
	@$(AR) rs $@ $<
