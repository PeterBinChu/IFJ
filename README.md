# IFJ24 Project

## Authors

- **Damir Amankulov** – `xamank00`
- **Daria Kinash** – `xkinas00`
- **Vaclav Patorek** – `xpator00`

## Overview

This repository contains the implementation of the IFJ24 compiler/interpreter, including lexer, parser, and code generator. For specifics check [Documentation.pdf](./Documentation.pdf) file

## Project Structure

- **src/**: Source files
  - `main.c`: Entry point of the compiler
  - `scanner.c/h`: Lexical analysis
  - `parser.c/h`: Syntax analysis and parsing
  - `pars_expr.c/h`: Expression parsing and evaluation
  - `symtable.c/h`: Symbol table implementation
  - `generator.c/h`: Intermediate code generation
  - `stack.c/h`: Stack utilities
  - `prec_stack.c/h`: Operator precedence stack
  - `dstring.c/h`: Dynamic string management
  - `file.c/h`: File handling
  - `token.c/h`: Token definitions and handling
  - `error_codes.c/h`: Error handling and definitions

- **tests/**: Testing scripts and cases
  - `test.sh`: Script to automate testing
  - Subdirectories (`err1`, `err2`, ..., `success`) contain various IFJ test cases.

## Building and Running

### Build

Use the provided Makefile to compile the project:
```bash
make
```

### Run

Run the compiled binary:
```bash
./ifj24 < input_file.ifj
```

### Testing

To run tests:
```bash
cd tests
./test.sh
```

## Error Codes

Defined in `error_codes.h`, used throughout the program for consistent error reporting.

## Dependencies

- GCC compiler
- Standard C library

## License

This project is part of an academic course and is intended for educational use only.
