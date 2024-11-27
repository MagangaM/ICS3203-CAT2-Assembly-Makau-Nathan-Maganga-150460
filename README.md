# CAT2 Assembly Project

This repository contains assembly code for four distinct tasks, each addressing a specific challenge or functionality. The project emphasizes key concepts in low-level programming and effective CPU resource management.

---

## File Breakdown

### Assembly Source Files
- **`question_1.asm`**:
  - **Description**: Implements basic arithmetic operations, demonstrating register management and operation sequencing.
  - **Challenges**: Efficiently utilizing registers without overwriting intermediate results.
- **`question_2.asm`**:
  - **Description**: Solves a more intricate computation problem using loops and conditional statements.
  - **Challenges**: Managing loop counters and ensuring accurate branching logic.
- **`question_3.asm`**:
  - **Description**: Handles data manipulation and storage, including memory access and storage operations.
  - **Challenges**: Ensuring proper memory alignment and avoiding access violations.
- **`question_4.asm`**:
  - **Description**: Simulates a real-world scenario requiring advanced logic and coordination of registers.
  - **Challenges**: Optimizing execution time while ensuring clarity and correctness.

### Other Files
- **Compiled Object Files (`*.o`)**: Pre-compiled versions of the source code.
- **`question_4_explained.txt`**: Detailed explanation of the logic in `question_4.asm`.
- **`register_management.txt`**: Insights on efficient register usage in assembly.

---

## How to Use

### Prerequisites
1. Install an assembler and linker, such as **NASM** or **GAS**.
2. Set up a terminal or shell environment (Linux/WSL is recommended) for compiling and running assembly programs.

### Compilation
To compile any `.asm` file, use the following command:
```bash
nasm -f elf64 -o <output-file>.o <input-file>.asm
