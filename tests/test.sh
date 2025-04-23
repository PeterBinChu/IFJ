#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Function to get expected exit code based on category
get_expected_exit_code() {
    case "$1" in
        "success") echo "0" ;;
        "err1") echo "1" ;;
        "err2") echo "2" ;;
        "err3") echo "3" ;;
        "err4") echo "4" ;;
        "err5") echo "5" ;;
        "err6") echo "6" ;;
        "err7") echo "7" ;;
        "err8") echo "8" ;;
        "err9") echo "9" ;;
        "err10") echo "10" ;;
        "err99") echo "99" ;;
        *) echo "-1" ;;
    esac
}

# Get category description
get_category_description() {
    case "$1" in
        "success") echo "Successful compilation" ;;
        "err1") echo "Lexical analysis errors" ;;
        "err2") echo "Syntactic analysis errors" ;;
        "err3") echo "Undefined function/variable errors" ;;
        "err4") echo "Function parameter/return errors" ;;
        "err5") echo "Variable/function redefinition errors" ;;
        "err6") echo "Return statement errors" ;;
        "err7") echo "Type compatibility errors" ;;
        "err8") echo "Type inference errors" ;;
        "err9") echo "Unused variable errors" ;;
        "err10") echo "Other semantic errors" ;;
        "err99") echo "Internal compiler errors" ;;
        *) echo "Unknown category" ;;
    esac
}

# Test category and paths
CATEGORY=$1
EXECUTABLE=$2
EXPECTED_EXIT=$(get_expected_exit_code "$CATEGORY")
CATEGORY_DESC=$(get_category_description "$CATEGORY")

# Check arguments
if [ $# -lt 2 ]; then
    echo -e "${RED}Usage: $0 <category> <executable>${NC}"
    echo "Categories: success, err1, err2, err3, err4, err5, err6, err7, err8, err9, err10, err99"
    exit 1
fi

# Paths setup
IN_DIR="tests/$CATEGORY/in"
OUT_DIR="tests/$CATEGORY/out"

# Check if directories exist
if [ ! -d "$IN_DIR" ]; then
    echo -e "No test files found in $IN_DIR"
    exit 0
fi

# Create output directory if it doesn't exist
mkdir -p "$OUT_DIR"

# Print header
echo -e "${BLUE}===================================="
echo "Running tests for $CATEGORY_DESC"
echo "Expected exit code: $EXPECTED_EXIT"
echo "====================================${NC}"

# Initialize counters
TOTAL=0
PASSED=0
FAILED=0

# Run tests for each .ifj file
for test_file in "$IN_DIR"/*.ifj; do
    # Check if any test files exist
    if [ ! -f "$test_file" ]; then
        echo -e "No test files found in $IN_DIR"
        exit 0
    fi

    base_name=$(basename "$test_file" .ifj)
    out_file="$OUT_DIR/${base_name}.out"
    TOTAL=$((TOTAL + 1))
    
    # Run the test and save output
    $EXECUTABLE < "$test_file" > "$out_file" 2>&1
    actual_exit=$?
    
    if [ "$actual_exit" -eq "$EXPECTED_EXIT" ]; then
        echo -e "${GREEN}✓ PASSED${NC} - $base_name"
        PASSED=$((PASSED + 1))
    else
        echo -e "${RED}✗ FAILED${NC} - $base_name"
        echo "  Expected exit code: $EXPECTED_EXIT"
        echo "  Actual exit code: $actual_exit"
        FAILED=$((FAILED + 1))
    fi
done

# Calculate percentage
if [ $TOTAL -gt 0 ]; then
    PERCENT=$((PASSED * 100 / TOTAL))
else
    PERCENT=0
fi

# Print summary for the category
echo "----------------------------------------"
echo -e "${BLUE}Results for $CATEGORY_DESC:${NC}"
echo "Total tests: $TOTAL"
echo -e "Passed: ${GREEN}$PASSED${NC}"
echo -e "Failed: ${RED}$FAILED${NC}"
echo -e "Success rate: ${YELLOW}$PERCENT%${NC}"
echo "----------------------------------------"

# Append results to global summary
echo "$CATEGORY ($CATEGORY_DESC): $PASSED/$TOTAL ($PERCENT%)" >> results_summary.tmp

[ $FAILED -eq 0 ]