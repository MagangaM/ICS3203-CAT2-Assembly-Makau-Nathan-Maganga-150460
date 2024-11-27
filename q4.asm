section .data
    sensor_value db 0            ; Simulated sensor value (0-255 range)
    motor_status db 0            ; Simulated motor status (0: off, 1: on)
    alarm_status db 0            ; Simulated alarm status (0: off, 1: on)

    msg_sensor db "Sensor Value: ", 0
    msg_motor_on db "Motor ON", 0
    msg_motor_off db "Motor OFF", 0
    msg_alarm_on db "ALARM TRIGGERED!", 0
    newline db 10, 0

section .bss
    input_buffer resb 4          ; Buffer for user input (simulated sensor value)

section .text
    global _start

_start:
    ; Display prompt for user to enter a sensor value
    mov eax, 4                  ; sys_write
    mov ebx, 1                  ; stdout
    mov ecx, msg_sensor         ; Message to display
    mov edx, 14                 ; Length of message
    int 0x80                    ; Call system write

    ; Read user input (simulated sensor value)
    mov eax, 3                  ; sys_read
    mov ebx, 0                  ; stdin
    mov ecx, input_buffer       ; Input buffer address
    mov edx, 4                  ; Max input size
    int 0x80                    ; Call system read

    ; Convert the input string to an integer
    xor eax, eax                ; Clear eax (set to 0)
    mov ecx, input_buffer       ; Load address of input buffer

convert_input:
    cmp byte [ecx], 0x0A        ; Check for newline (end of input)
    je check_sensor             ; Jump to sensor check if newline found
    sub byte [ecx], '0'         ; Convert ASCII digit to integer
    imul eax, eax, 10           ; Multiply eax by 10 (shift left by 1 digit)
    add eax, [ecx]              ; Add the current digit to eax
    inc ecx                     ; Move to the next character
    jmp convert_input           ; Repeat the process for the next digit

check_sensor:
    mov [sensor_value], al      ; Store the sensor value (only low byte, 8-bit)

    ; Check sensor value and determine the action
    mov al, [sensor_value]      ; Load sensor value into al
    cmp al, 200                 ; Check if water level is too high
    ja trigger_alarm            ; If > 200, trigger the alarm

    cmp al, 100                 ; Check if water level is moderate
    ja motor_off                ; If 100 < sensor <= 200, turn off the motor

    ; If water level is low (sensor <= 100), turn the motor on
    mov byte [motor_status], 1  ; Motor ON
    mov byte [alarm_status], 0  ; Alarm OFF
    call print_motor_on         ; Call to print motor status
    jmp end_program             ; Jump to program exit

motor_off:
    ; Turn off motor for moderate water level
    mov byte [motor_status], 0  ; Motor OFF
    mov byte [alarm_status], 0  ; Alarm OFF
    call print_motor_off        ; Call to print motor status
    jmp end_program             ; Jump to program exit

trigger_alarm:
    ; Trigger alarm for high water level
    mov byte [motor_status], 0  ; Motor OFF
    mov byte [alarm_status], 1  ; Alarm ON
    call print_alarm_on         ; Call to print alarm status
    jmp end_program             ; Jump to program exit

print_motor_on:
    ; Print "Motor ON"
    mov eax, 4                  ; sys_write
    mov ebx, 1                  ; stdout
    mov ecx, msg_motor_on       ; Message to print
    mov edx, 8                  ; Length of message
    int 0x80                    ; Call system write
    ret

print_motor_off:
    ; Print "Motor OFF"
    mov eax, 4                  ; sys_write
    mov ebx, 1                  ; stdout
    mov ecx, msg_motor_off      ; Message to print
    mov edx, 9                  ; Length of message
    int 0x80                    ; Call system write
    ret

print_alarm_on:
    ; Print "ALARM TRIGGERED!"
    mov eax, 4                  ; sys_write
    mov ebx, 1                  ; stdout
    mov ecx, msg_alarm_on       ; Message to print
    mov edx, 17                 ; Length of message
    int 0x80                    ; Call system write
    ret

end_program:
    ; Print newline for better readability
    mov eax, 4                  ; sys_write
    mov ebx, 1                  ; stdout
    mov ecx, newline            ; Newline character
    mov edx, 1                  ; Length of newline
    int 0x80                    ; Call system write

    ; Exit program
    mov eax, 1                  ; sys_exit
    xor ebx, ebx                ; Exit code 0
    int 0x80                    ; Call system exit
