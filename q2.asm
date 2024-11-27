section .data
    prompt db "Enter 5 integers separated by spaces: ", 0
    prompt_len equ $-prompt

    result_msg db "Reversed array: ", 0
    result_msg_len equ $-result_msg

section .bss
    input resb 128         ; Buffer to store user input
    numbers resd 5         ; Array to hold the 5 integers

section .text
    global _start

_start:
    ; Display a prompt to the user
    mov eax, 4              ; syscall for sys_write
    mov ebx, 1              ; file descriptor for stdout
    mov ecx, prompt         ; address of the prompt string
    mov edx, prompt_len     ; length of the prompt
    int 0x80                ; call kernel

    ; Read input from the user
    mov eax, 3              ; syscall for sys_read
    mov ebx, 0              ; file descriptor for stdin
    mov ecx, input          ; address of the input buffer
    mov edx, 128            ; maximum input size
    int 0x80                ; call kernel

    ; Parse the input and convert it into integers
    xor esi, esi            ; initialize index for numbers array to 0
    xor edx, edx            ; clear the current number accumulator
    mov ecx, input          ; set ecx to point to the input buffer

parse_input:
    cmp byte [ecx], 0x0A    ; check for newline character (end of input)
    je reverse_array         ; if newline, jump to reversing the array
    cmp byte [ecx], ' '     ; check if the current character is a space
    je store_number          ; if space, store the accumulated number
    sub byte [ecx], '0'     ; convert ASCII digit to an integer
    imul edx, edx, 10       ; multiply current accumulator by 10
    add edx, dword [ecx]    ; add the new digit to the accumulator
    jmp next_char           ; move to the next character

store_number:
    mov [numbers + esi * 4], edx ; store the accumulated number in the array
    inc esi                     ; increment the index in the array
    xor edx, edx                ; reset the accumulator for the next number
next_char:
    inc ecx                     ; move to the next character in the buffer
    jmp parse_input             ; continue parsing input

reverse_array:
    ; Reverse the array in place
    mov esi, 0                  ; start index (first element)
    mov edi, 4                  ; end index (last element)

reverse_loop:
    cmp esi, edi                ; check if start index meets or exceeds end index
    jge display_result          ; if indices meet, proceed to display the result
    mov eax, [numbers + esi * 4] ; load the start element into eax
    mov ebx, [numbers + edi * 4] ; load the end element into ebx
    mov [numbers + edi * 4], eax ; swap start element with end element
    mov [numbers + esi * 4], ebx ; swap end element with start element
    inc esi                     ; increment the start index
    dec edi                     ; decrement the end index
    jmp reverse_loop            ; repeat the process

display_result:
    ; Display the "Reversed array" message
    mov eax, 4                  ; syscall for sys_write
    mov ebx, 1                  ; file descriptor for stdout
    mov ecx, result_msg         ; address of the result message
    mov edx, result_msg_len     ; length of the result message
    int 0x80                    ; call kernel

    ; Print each number in the reversed array
    mov esi, 0                  ; reset index for numbers array
print_loop:
    mov eax, [numbers + esi * 4] ; load the current number into eax
    call print_integer           ; print the number
    inc esi                      ; move to the next number in the array
    cmp esi, 5                   ; check if all numbers are printed
    je exit_program              ; if yes, exit the program
    ; Print a space between numbers
    mov eax, 4
    mov ebx, 1
    mov ecx, " "
    mov edx, 1
    int 0x80
    jmp print_loop

print_integer:
    ; Convert the integer in eax to a string and print it
    push eax                    ; save the original value of eax
    xor ecx, ecx                ; clear digit counter
    xor edx, edx                ; clear remainder
    mov ebx, 10                 ; divisor (base 10)
convert_to_string:
    xor edx, edx                ; clear edx before dividing
    div ebx                     ; divide eax by 10
    add dl, '0'                 ; convert remainder to ASCII
    push edx                    ; store ASCII digit on the stack
    inc ecx                     ; increment digit count
    test eax, eax               ; check if quotient is 0
    jnz convert_to_string       ; if not, continue conversion

print_digits:
    pop edx                     ; get the next digit from the stack
    mov [input], dl             ; store it in the input buffer temporarily
    mov eax, 4                  ; syscall for sys_write
    mov ebx, 1                  ; stdout
    mov ecx, input              ; address of the digit
    mov edx, 1                  ; length = 1
    int 0x80                    ; call kernel to print the digit
    loop print_digits           ; repeat for all digits
    pop eax                     ; restore the original value of eax
    ret

exit_program:
    ; Exit the program
    mov eax, 1                  ; syscall for sys_exit
    xor ebx, ebx                ; return code 0
    int 0x80                    ; call kernel
