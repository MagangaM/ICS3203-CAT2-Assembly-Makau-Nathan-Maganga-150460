# CAT2 Assembly Programming Project

This repository contains assembly code for four distinct tasks, each designed to demonstrate key concepts of low-level programming and the efficient management of CPU resources. The project covers various fundamental programming techniques, such as conditional logic, loops, and memory manipulation.

---

## Overview of Source Files

### Assembly Source Files
- **`question_1.asm`**: 
  - **Goal**: Implements basic arithmetic operations and demonstrates the management of CPU registers and sequencing of operations.
  - **Challenges**: The primary challenge was to use registers effectively without overwriting intermediate values.
  
- **`question_2.asm`**: 
  - **Goal**: Solves a more advanced computational problem by incorporating loops and conditional branching.
  - **Challenges**: Keeping track of loop counters and ensuring proper branching logic to handle multiple cases.

- **`question_3.asm`**: 
  - **Goal**: Handles memory manipulation, including access and storage operations for data.
  - **Challenges**: Ensuring proper memory alignment and preventing access violations while dealing with raw memory.

- **`question_4.asm`**: 
  - **Goal**: Simulates a real-world scenario involving complex logic and coordination of registers.
  - **Challenges**: Optimizing for execution speed while ensuring clarity and correctness of the logic.

### Additional Files
- **Compiled Object Files (`*.o`)**: Precompiled object files of the source code for easy execution.
- **`question_4_explained.txt`**: A detailed walkthrough of the logic behind the `question_4.asm` implementation.
- **`register_management.txt`**: A document outlining insights into efficient register usage during assembly programming.

---

## How to Use

### Prerequisites
1. Install an assembler and linker (such as **NASM** or **GAS**).
2. Set up a terminal or shell environment (Linux/WSL is recommended) to compile and run assembly programs.

### Compilation
To compile any `.asm` source file, run the following command in your terminal:
```bash
nasm -f elf64 -o <output-file>.o <input-file>.asm
