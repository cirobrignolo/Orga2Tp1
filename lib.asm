; FUNCIONES de C
    extern malloc
    extern free
    extern fopen
    extern fclose
    extern fprintf

section .rodata

section .data

; Offset

%define off_list_first 0
%define off_list_last 8

%define off_elem_data 0
%define off_elem_next 8
%define off_elem_prev 16

%define off_tree_first 0

%define off_tree_elem_data 0
%define off_tree_elem_left 8
%define off_tree_elem_center 16
%define off_tree_elem_right 24
; Size Struct

%define size_list 16
%define size_elem 24
%define size_tree 8
%define size_tree_elem 32

%define NULL 0

FORMATO_STR: db "%s",0
PRINTNULL: db "NULL",0
CORCHETE1: db "[",0
CORCHETE2: db "]",0
COMA: db ",",0

section .text

extern malloc
extern free
extern fprintf

global strLen
global strClone
global strCmp
global strConcat
global strDelete
global strPrint
global listNew
global listAddFirst
global listAddLast
global listAdd
global listRemove
global listRemoveFirst
global listRemoveLast
global listDelete
global listPrint
global n3treeNew
global n3treeAdd
global n3treeRemoveEq
global n3treeDelete
global nTableNew
global nTableAdd
global nTableRemoveSlot
global nTableDeleteSlot
global nTableDelete

strLen:
    push rbp
    mov rbp, rsp
    push r12
    subb rsp, 8
    mov r12, rdi
    xor r8, r8

.ciclo:
    cmp BYTE [r12 + r8], 0
    je .fin
    inc r8
    jmp .ciclo

.fin:
    mov eax, r8d
    add rsp, 8
    pop r12
    pop rbp
    ret

strClone:
    push rbp
    mov rbp, rsp
    push r12
    push r13
    push r14
    sub rsp, 8
    mov r12, rdi
    call strLen
    mov r13d, eax
    inc r13d
    mov edi, r13d
    call malloc
    mov r14, rax
    mov ecx, r13d

.ciclo:
    
    mov r8b, [r12]
    mov [r14], r8b
    inc r14
    inc r12
    loop .ciclo
    add rsp, 8
    pop r14
    pop r13
    pop r12
    pop rbp
    ret

strCmp:
    push rbp
    mov rbp, rsp
    push r12
    push r13
    mov r12, rdi
    mov r13, rsi

.ciclo:
    mov r8, [r13]
    cmp BYTE [r12], r8
    .jg .mayor
    .jl .menor
    cmp BYTE [r12], 0
    je .iguales
    inc r12
    inc r13
    jmp .ciclo

.mayor:
    mov eax, -1
    jmp .fin

.menor:
    mov eax, 1
    jmp .fin

.iguales:
    mov eax, 0

.fin:
    pop r13
    pop r12
    pop rbp
    ret

strConcat:
    push rbp
    mov rbp, rsp
    push rbx
    push r12
    push r13
    push r14
    mov rbx, rdi
    mov r12, rsi
    call strLen
    mov r13d, eax
    xor r8, r8
    mov r8d, r13d
    mov rdi, r12
    call strLen
    add r13d, eax
    inc r13d
    mov edi, r13d
    call malloc
    mov r14, rax
    mov ecx, r8d

.ciclo1
    mov r9b, [rbx]
    mov [r14], r9b
    inc rbx
    inc r14
    loop .ciclo1
    sub r13d, r8d
    mov ecx, r13d

.ciclo2
    mov r9b, [r12]
    mov [r14], r9b
    inc r12
    inc r14
    pop r14
    pop r13
    pop r12
    pop rbx
    pop rbp
    ret

strRemove:
    push rbp
    mov rbp, rsp
    push rbx
    sub rsp, 8
    mov rbx, rdi
    cmp QWORD [rbx], 0
    je .es_null
    mov rdi, [rbx] 
    call free
    mov QWORD [rbx], 0 
 
 .es_null:
    mov rax, rbx
    add rsp, 8
    pop rbx
    pop rbp
    ret

strDelete:
    push rbp
    mov rbp, rsp
    push rbx
    sub rsp, 8
    mov rbx, rdi
    call strRemove
    mov rdi, rbx
    call free
    add rsp, 8
    pop rbx
    pop rbp
    ret
 
strPrint:
    push rbp
    mov rbp, rsp
    push rbx
    sub rsp, 8
    mov rbx, rdi
    mov rdi, rsi
    mov rsi, FORMATO_STR
    mov rdx, [rbx + offset_str_data]
    cmp rdx, 0
    je .es_null
    call fprintf
    jmp .fin
 
 .es_null:
    mov rdx, PRINTNULL
    call fprintf

  .fin:
    add rsp, 8
    pop rbx
    pop rbp
    ret
    
listNew:
    push rbp
    mov rbp, rsp
    mov rdi, size_list
    call malloc
 
    mov qword [rax + off_list_first], NULL
    mov qword [rax + off_list_last], NULL

    pop rbp
    ret

listAddFirst:
    push rbp
    mov rbp, rsp
    push r12
    push r13
    mov r12, rdi
    mov r13, rsi

    mov rdi, size_elem
    call malloc ;rax = nuevo elem

    mov [rax + off_elem_data], r13 ;el puntero al valor apunta al indicado

    mov r8, [r12 + off_list_first]
    cmp r8, NULL                     ;comparo si el primero es null
    je .firstNull
    jne .firstNotNull

    .firstNull
    mov r8, [r12 + off_list_first]       ;r8 es el primer elem de la lista antes de agregar el nuevo
    mov [rax + off_elem_next], r8        ;el elemento que agregue apunta al siguiente (antes primero)
    mov [r8 + off_elem_prev], rax        ;el segundo elemento apunta al primero
    mov [r12 + off_list_last], r8        ;el puntero al ultimo apunta al ultimo elemento
    mov [rax + off_elem_prev], NULL      ;el primer elemnto apunta a NULL en el puntero al previo
    mov [r12 + off_list_first], rax      ;el puntero al primer elemento apunta al nuevo elemento

    .firstNotNull
    mov r8, [r12 + off_list_first]       ;r8 es el primer elem de la lista antes de agregar el nuevo
    mov [rax + off_elem_next], r8        ;el elemento que agregue apunta al siguiente (antes primero)
    mov [r8 + off_elem_prev], rax        ;el segundo elemento apunta al primero
    mov [rax + off_elem_prev], NULL      ;el primer elemnto apunta a NULL en el puntero al previo
    mov [r12 + off_list_first], rax      ;el puntero al primer elemento apunta al nuevo elemento


    mov rax, r12
    pop r13
    pop r12
    pop rbp
    ret

listAddLast:
    push rbp
    mov rbp, rsp
    push r12
    push r13
    mov r12, rdi
    mov r13, rsi

    mov rdi, size_elem
    call malloc ;rax = nuevo elem

    mov [rax + off_elem_data], r13 ;el puntero al valor apunta al indicado

    mov r8, [r12 + off_list_last]
    cmp r8, NULL                     ;comparo si el ultimo es null
    je .lastNull
    jne .lastNotNull

    .lastNull
    mov r8, [r12 + off_list_last]        ;r8 es el ultimo elem de la lista antes de agregar el nuevo
    mov [rax + off_elem_prev], r8        ;el elemento que agregue apunta al anterior (antes primero)
    mov [r8 + off_elem_next], rax        ;el ultimo elemento apunta al nuevo ultimo
    mov [r12 + off_list_first], r8       ;el puntero al primero apunta al ultimo elemento
    mov [rax + off_elem_next], NULL      ;el ultimo elemnto apunta a NULL en el puntero al siguiente
    mov [r12 + off_list_last], rax       ;el puntero al ultimo elemento apunta al nuevo elemento

    .lastNotNull
    mov r8, [r12 + off_list_last]        ;r8 es el ultimo elem de la lista antes de agregar el nuevo
    mov [rax + off_elem_prev], r8        ;el elemento que agregue apunta al anterior (antes primero)
    mov [r8 + off_elem_next], rax        ;el ultimo elemento apunta al nuevo ultimo
    mov [rax + off_elem_next], NULL      ;el ultimo elemnto apunta a NULL en el puntero al siguiente
    mov [r12 + off_list_last], rax       ;el puntero al ultimo elemento apunta al nuevo elemento


    mov rax, r12
    pop r13
    pop r12
    pop rbp
    ret

listAdd:
    push rbp
    mov rbp, rsp
    push r12
    push r13
    push r14
    push r15
    push rbx
    sub rsp, 8
    mov r12, rdi
    mov r13, rsi
    mov r14, rdx

    lea r15, [r12 + off_list_first]
    mov rbx, [r15]

    .ciclo:
        cmp rbx, NULL
        je .insertar
        mov rdi, [rbx]
        mov rsi, r13
        call r14

        cmp rax, -1
        je .insertar

        lea r15, [rbx + off_elem_next]
        mov rbx, [r15]
        jmp .ciclo

    .insertar:
        mov rdi, size_elem
        call malloc

        mov qword [rax + off_elem_data], r13
        mov qword [rax + off_elem_next], rbx

        mov qword [r15], rax


    .fin:
        mov rax, r12
        add rsp, 8
        pop rbx
        pop r15
        pop r14
        pop r13
        pop r12
        pop rbp

        ret

listRemove:
    push rbp
    mov rbp, rsp
    push r12
    push r13
    push r14
    push r15
    push rbx
    sub rsp, 8
    mov r12, rdi
    mov r13, rsi
    mov r14, rdx

    lea r15, [r12 + off_list_first]
    mov rbx, [r15]
    cmp rbx, NULL
    mov r12, rcx
    je .fin
    .ciclo:
        mov rdi, [rbx]
        mov rsi, r13
        call r14
        cmp rax, 0
        je .eliminar

        cmp qword [rbx + off_elem_next], NULL
        je .fin

        mov rdi, [rbx]
        mov rsi, r13
        call r14
        cmp rax, 0
        je .eliminar

        lea r15, [rbx + off_elem_next]
        mov rbx, [r15]
        jmp .ciclo

    .eliminar:
        mov r8, [rbx + off_elem_next]
        mov [r15], r8

        mov rdi, [rbx]
        call r12

        mov rdi, rbx
        call free

        mov rbx, [r15]
        cmp rbx, NULL
        je .fin
        jmp .ciclo



    .fin:
        mov rax, r12
        add rsp, 8
        pop rbx
        pop r15
        pop r14
        pop r13
        pop r12
        pop rbp
        ret

listRemoveFirst:
    push rbp
    mov rbp, rsp
    push r12
    push r13
    push r14
    sub rsp, 8
    mov r12, rdi
    mov r14, rsi

    cmp qword [r12 + off_list_first], NULL
    je .fin

    mov r8, [rdi + off_list_first]
    mov r13, r8
    mov r8, [r8 + off_elem_next]
    mov qword [r12 + off_list_first], r8
    cmp r13, [r12 + off_list_last]
    jne .twoOrMoreElements

    mov qword [r12 + off_list_last], NULL

    .twoOrMoreElements
    mov rdi, [r13]
    call r14

    mov rdi, r13
    call free

    .fin:
        mov rax, r12
        add rsp, 8
        pop r14
        pop r13
        pop r12
        pop rbp
        ret

listRemoveLast:
    push rbp
    mov rbp, rsp
    push r12
    push r13
    push r14
    sub rsp, 8
    mov r12, rdi
    mov r14, rsi

    cmp qword [r12 + off_list_last], NULL
    je .fin

    mov r8, [rdi + off_list_last]
    mov r13, r8
    mov r8, [r8 + off_elem_prev]
    mov qword [r12 + off_list_last], r8
    cmp r13, [r12 + off_list_first]
    jne .twoOrMoreElements

    mov qword [r12 + off_list_first], NULL

    .twoOrMoreElements
    mov rdi, [r13]
    call r14

    mov rdi, r13
    call free

    .fin:
        mov rax, r12
        add rsp, 8
        pop r14
        pop r13
        pop r12
        pop rbp
        ret

listDelete:
    push rbp
    mov rbp, rsp
    push r12
    push r13
    push r14
    sub rsp, 8
    mov r12, rdi
    mov r14, rsi

    mov r13, [r12 + off_list_first]

    .ciclo:
        cmp r13, NULL
        je .fin

        mov rdi, [r13]
        call r14

        mov rdi, r13
        mov r13, [r13 + off_elem_next]
        call free
        jmp .ciclo

    .fin:
        mov rdi, r12
        call free
        add rsp, 8
        pop r14
        pop r13
        pop r12
        pop rbp
        ret

listPrint:
    push rbp
    mov rbp, rsp
    push r12
    push r13
    push r14
    push r15
    mov r12, rdi
    mov r13, rsi
    mov r15, rdx

    mov rdi, r13
    mov rsi, CORCHETE1
    call fprintf

    mov r14, [r12 + off_list_first]
    cmp qword r14, NULL
    je .fin

    .ciclo:
        mov rsi, r13 ;file*
        mov rdi, [r14 + off_elem_data]; struct*
        call r15

        mov r14, [r14 + off_elem_next]
        cmp qword r14, NULL
        je .fin

        mov rdi, r13
        mov rsi, COMA
        call fprintf
        jmp .ciclo


        .fin:
        mov rdi, r13
        mov rsi, CORCHETE2
        call fprintf
        pop r15
        pop r14
        pop r13
        pop r12
        pop rbp
        ret

n3treeNew:
    push rbp
    mov rbp, rsp
    mov rdi, size_tree
    call malloc

    mov qword [rax + off_tree_first], NULL

    pop rbp
    ret

n3treeAdd:
    push rbp
    mov rbp, rsp
    push r12
    push r13
    push r14
    push r15
    mov r12, rdi
    mov r13, rsi
    mov r14, rdx

    mov r8, [r12 + off_tree_first]
    mov r15, [r8]

    cmp r15, NULL
    jne .notNULL

    ; puntero al arbol vacio
    mov rdi, size_tree_elem
    call malloc

    mov qword [rax + off_tree_elem_data], r13
    mov qword [rax + off_tree_elem_left], NULL
    mov qword [rax + off_tree_elem_center], NULL
    mov qword [rax + off_tree_elem_right], NULL
    mov [r15], rax

    call listNew
    mov qword [r15 + off_tree_elem_center], rax

    .notNULL
    mov r8, [r15 + off_tree_elem_data]
    cmp r8, r13
    je .insert
    jg .leftTree
    mov rdi, [r15 + off_tree_elem_right]
    mov rsi, r13
    mov rdx, r14
    call n3treeAdd ;necesito popear todo antes??

    .leftTree
    mov rdi, [r15 + off_tree_elem_left]
    mov rsi, r13
    mov rdx, r14
    call n3treeAdd

    .insert
    mov rdi, [r15 + off_tree_elem_center]
    mov rsi, r13
    mov rdx, r14
    call listAdd

    pop r15
    pop r14
    pop r13
    pop r12
    pop rbp
    ret

n3treeRemoveEq:
    ret

n3treeDelete:
    ret

nTableNew:
    ret

nTableAdd:
    ret
    
nTableRemoveSlot:
    ret
    
nTableDeleteSlot:
    ret

nTableDelete:
    ret
