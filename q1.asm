section .bss
    input resb 10         ; Buffer to store user input

section .data
    prompt db "Enter a number: ", 0
    pos_msg db "The number is POSITIVE", 0
    neg_msg db "The number is NEGATIVE", 0
    zero_msg db "The number is ZERO", 0
    invalid_msg db "Invalid input!", 0

section .text
global _start

_start:
    ; Display a prompt asking the user to enter a number
    mov eax, 4            ; syscall for writing data
    mov ebx, 1            ; use standard output (stdout)
    mov ecx, prompt       ; address of the prompt message
    mov edx, 17           ; length of the prompt message
    int 0x80              ; call the kernel

    ; Read the user input into the buffer
    mov eax, 3            ; syscall for reading data
    mov ebx, 0            ; use standard input (stdin)
    mov ecx, input        ; address of the input buffer
    mov edx, 10           ; maximum number of characters to read
    int 0x80              ; call the kernel

    ; Initialize variables for conversion
    mov eax, 0            ; clear accumulator (result)
    mov esi, input        ; point to the start of the input buffer
    mov ebx, 0            ; flag for negative numbers

    ; Check if the first character is a negative sign
    cmp byte [esi], '-'   ; compare the first character with '-'
    jne convert_to_int    ; if not '-', skip to number conversion
    inc esi               ; move past the '-' sign
    mov ebx, 1            ; set flag indicating a negative number

convert_to_int:
    ; Process each character in the buffer
    movzx ecx, byte [esi] ; load the current character
    cmp cl, 10            ; check if it’s the newline character
    je check_value        ; if newline, finish conversion
    cmp cl, '0'           ; check if the character is less than '0'
    jl invalid_input      ; if true, input is invalid
    cmp cl, '9'           ; check if the character is greater than '9'
    jg invalid_input      ; if true, input is invalid

    sub cl, '0'           ; convert ASCII to numeric value
    imul eax, eax, 10     ; multiply the current result by 10
    add eax, ecx          ; add the new digit to the result
    inc esi               ; move to the next character
    jmp convert_to_int    ; repeat the loop

check_value:
    ; Determine if the number is negative
    cmp ebx, 1            ; check if the negative flag is set
    jne check_zero        ; if not negative, check if zero
    neg eax               ; make the number negative

check_zero:
    ; Check if the number is zero
    cmp eax, 0            ; compare the number with zero
    je print_zero         ; if zero, go to zero message
    jl print_negative     ; if less than zero, go to negative message

    ; If the number is neither zero nor negative, it is positive
    jmp print_positive

print_positive:
    ; Output "POSITIVE" message
    mov eax, 4            ; syscall for writing data
    mov ebx, 1            ; use standard output
    mov ecx, pos_msg      ; address of positive message
    mov edx, 23           ; length of the positive message
    int 0x80              ; call the kernel
    jmp exit              ; end the program

print_negative:
    ; Output "NEGATIVE" message
    mov eax, 4            ; syscall for writing data
    mov ebx, 1            ; use standard output
    mov ecx, neg_msg      ; address of negative message
    mov edx, 23           ; length of the negative message
    int 0x80              ; call the kernel
    jmp exit              ; end the program

print_zero:
    ; Output "ZERO" message
    mov eax, 4            ; syscall for writing data
    mov ebx, 1            ; use standard output
    mov ecx, zero_msg     ; address of zero message
    mov edx, 18           ; length of the zero message
    int 0x80              ; call the kernel
    jmp exit              ; end the program

invalid_input:
    ; Output an error message for invalid input
    mov eax, 4            ; syscall for writing data
    mov ebx, 1            ; use standard output
    mov ecx, invalid_msg  ; address of invalid input message
    mov edx, 15           ; length of the invalid input message
    int 0x80              ; call the kernel

exit:
    ; Exit the program
    mov eax, 1            ; syscall for exiting a program
    xor ebx, ebx          ; return code 0 (success)
    int 0x80              ; call the kernel
