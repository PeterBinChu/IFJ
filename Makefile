# IFJ24
# @brief Makefile for IFJ24 project
# @author: Václav Paťorek(xpator00), modified for multi-platform use

# Operating system detection
ifeq ($(OS),Windows_NT)
    DETECTED_OS := Windows
else
    DETECTED_OS := $(shell uname -s)
endif

# Compiler and flags
CC = gcc
CFLAGS = -std=c99 -Wall -Wextra -pedantic -g

# Directories
SRC_DIR = src
OBJ_DIR = obj
TEST_DIR = tests

# Executable names
ifeq ($(DETECTED_OS),Windows)
    TARGET = ifj24.exe
else
    TARGET = ifj24
endif

# Source files
SOURCES = $(wildcard $(SRC_DIR)/*.c)
TEST_SOURCES = $(wildcard $(TEST_DIR)/*.c)

# Object files
OBJECTS = $(SOURCES:$(SRC_DIR)/%.c=$(OBJ_DIR)/%.o)
TEST_OBJECTS = $(TEST_SOURCES:$(TEST_DIR)/%.c=$(OBJ_DIR)/%.o)

# Phony targets
.PHONY: all clean test test-all test-success test-err1 test-err2 test-err3 test-err4 \
        test-err5 test-err6 test-err7 test-err8 test-err9 test-err10 test-err99 \
        clean-summary memcheck

# Default target (build program)
all: $(TARGET)

# Rule for building the target program
$(TARGET): $(OBJECTS)
	@mkdir -p $(OBJ_DIR)
	$(CC) $(CFLAGS) -o $@ $^

# Rule for compiling source files
$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c
	@mkdir -p $(OBJ_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

# Test targets
test: clean-summary test-all

test-all: test-success test-err1 test-err2 test-err3 test-err4 test-err5 \
         test-err6 test-err7 test-err8 test-err9 test-err10 test-err99

test-success: $(TARGET)
	-@bash $(TEST_DIR)/test.sh success ./$(TARGET) | tee -a results_summary.tmp

test-err1: $(TARGET)
	-@bash $(TEST_DIR)/test.sh err1 ./$(TARGET) | tee -a results_summary.tmp

test-err2: $(TARGET)
	-@bash $(TEST_DIR)/test.sh err2 ./$(TARGET) | tee -a results_summary.tmp

test-err3: $(TARGET)
	-@bash $(TEST_DIR)/test.sh err3 ./$(TARGET) | tee -a results_summary.tmp

test-err4: $(TARGET)
	-@bash $(TEST_DIR)/test.sh err4 ./$(TARGET) | tee -a results_summary.tmp

test-err5: $(TARGET)
	-@bash $(TEST_DIR)/test.sh err5 ./$(TARGET) | tee -a results_summary.tmp

test-err6: $(TARGET)
	-@bash $(TEST_DIR)/test.sh err6 ./$(TARGET) | tee -a results_summary.tmp

test-err7: $(TARGET)
	-@bash $(TEST_DIR)/test.sh err7 ./$(TARGET) | tee -a results_summary.tmp

test-err8: $(TARGET)
	-@bash $(TEST_DIR)/test.sh err8 ./$(TARGET) | tee -a results_summary.tmp

test-err9: $(TARGET)
	-@bash $(TEST_DIR)/test.sh err9 ./$(TARGET) | tee -a results_summary.tmp

test-err10: $(TARGET)
	-@bash $(TEST_DIR)/test.sh err10 ./$(TARGET) | tee -a results_summary.tmp

test-err99: $(TARGET)
	-@bash $(TEST_DIR)/test.sh err99 ./$(TARGET) | tee -a results_summary.tmp

# Cleanup old summary file
clean-summary:
	@rm -f results_summary.tmp

# Cleanup
clean:
ifeq ($(DETECTED_OS),Windows)
	if exist $(OBJ_DIR) rmdir /s /q $(OBJ_DIR)
	if exist $(TARGET) del $(TARGET)
	-for /d %i in (tests\*\out) do @if exist "%i" rmdir /s /q "%i"
else
	rm -rf $(OBJ_DIR) $(TARGET) results_summary.tmp
endif

# Clean outputs only
clean-out:
ifeq ($(DETECTED_OS),Windows)
	-for /d %i in (tests\*\out) do @if exist "%i" rmdir /s /q "%i"
else
	rm -rf tests/*/out
endif

# Target to check for memory leaks using Valgrind
memcheck: $(TARGET)
ifeq ($(DETECTED_OS),Windows)
	@echo "Valgrind is not supported on Windows"
else
	valgrind --leak-check=full --show-leak-kinds=all ./$(TARGET)
endif