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

%define off_table_list 0
%define off_table_size 8

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
    sub rsp, 8
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
    push r15
    mov r12, rdi
    call strLen
    mov r13d, eax
    inc r13d
    xor rdi, rdi
    mov edi, r13d
    call malloc
    mov r14, rax
    mov r15, r14
    mov ecx, r13d

    .ciclo:
    mov r8b, [r12]
    mov [r14], r8b
    inc r12
    inc r14
    loop .ciclo

    mov rax, r15
    pop r15
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
    mov r8b, [r13]
    cmp byte [r12], r8b
    jg .mayor
    jl .menor
    cmp byte [r12], 0
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
    %define ptrA rbx
    %define ptrB r12
    %define lenA r13
    %define lenB r14
    %define lenC r15
    %define ptrC rax
    %define cont rcx

    ; Estoy desalineado
    push rbp
    mov rbp, rsp
    ; Me alineo
    push rbx
    push r12
    push r13
    push r14
    push r15
    ; Me desalineo
    sub rsp, 8
    ; Me alineo

    mov ptrA, rdi
    mov ptrB, rsi

    ; Calculo lenA
    call strLen
    mov lenA, rax

    ; Calculo lenB
    mov rdi, ptrB
    call strLen
    mov lenB, rax

    mov lenC, lenA
    add lenC, lenB
    mov rdi, lenC
    inc rdi
    call malloc

    mov cont, 0
    .cicloConcatA:
        mov byte dl, [ptrA + cont]
        cmp dl, 0
        je .finCicloConcatA
        mov byte dl, [ptrA + cont]
        mov byte [ptrC + cont], dl
        inc cont
        jmp .cicloConcatA
    .finCicloConcatA:
        mov cont, 0
    .cicloConcatB:
        mov byte dl, [ptrB + cont]
        cmp dl, 0
        je .terminarConcatenacion
        mov byte dl, [ptrB + cont]
        lea r11, [lenA + cont]
        mov [ptrC + r11], dl
        inc cont
        jmp .cicloConcatB
    .terminarConcatenacion:
        lea r11, [lenA + cont]
        mov byte [ptrC + r11], 0
    .limpiarMemoria:
        %define ptrC r13
        mov ptrC, rax
        cmp ptrA, ptrB
        je .borrarUno
    .borrarAmbos:
        mov rdi, ptrA
        call strDelete
        mov rdi, ptrB
        call strDelete
        jmp .retornar
    .borrarUno:
        mov rdi, ptrA
        call strDelete
        jmp .retornar
    .retornar:
        mov rax, ptrC
        add rsp, 8
        pop r15
        pop r14
        pop r13
        pop r12
        pop rbx
        pop rbp
        ret  


strDelete:
    push rbp
    mov rbp, rsp
    call free
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
    mov rdx, rbx
    cmp byte [rdx], 0
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
 
    mov qword [rax + off_list_first], 0
    mov qword [rax + off_list_last], 0

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

    xor r8, r8
    mov r8, [r12 + off_list_first]
    cmp r8, 0                     ;comparo si el primero es null
    je .firstNull

    xor r8, r8
    mov [rax + off_elem_data], r13 ;el puntero al valor apunta al indicado
    mov r8, [r12 + off_list_first]       ;r8 es el primer elem de la lista antes de agregar el nuevo
    mov [rax + off_elem_next], r8        ;el elemento que agregue apunta al r14 (antes primero)
    mov [r8 + off_elem_prev], rax        ;el segundo elemento apunta al primero
    mov qword[rax + off_elem_prev], 0      ;el primer elemnto apunta a NULL en el puntero al previo
    mov [r12 + off_list_first], rax      ;el puntero al primer elemento apunta al nuevo element
    jmp .fin

    .firstNull:
    xor r8, r8
    mov [rax + off_elem_data], r13 ;el puntero al valor apunta al indicado
    mov r8, [r12 + off_list_first]       ;r8 es el primer elem de la lista antes de agregar el nuevo
    mov [rax + off_elem_next], r8        ;el elemento que agregue apunta al r14 (antes primero)
    mov [r12 + off_list_last], rax        ;el puntero al ultimo apunta al ultimo elemento
    mov qword[rax + off_elem_prev], 0      ;el primer elemnto apunta a NULL en el puntero al previo
    mov [r12 + off_list_first], rax      ;el puntero al primer elemento apunta al nuevo elemento

    .fin:
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
    cmp r8, 0                     ;comparo si el ultimo es null
    jne .lastNotNull

    xor r8, r8
    mov r8, [r12 + off_list_last]        ;r8 es el ultimo elem de la lista antes de agregar el nuevo
    mov [rax + off_elem_prev], r8        ;el elemento que agregue apunta al anterior (antes primero)
    mov [r12 + off_list_first], rax       ;el puntero al primero apunta al ultimo elemento
    mov qword[rax + off_elem_next], 0      ;el ultimo elemnto apunta a NULL en el puntero al r14
    mov [r12 + off_list_last], rax       ;el puntero al ultimo elemento apunta al nuevo elemento
    jmp .fin

    .lastNotNull:
    mov r8, [r12 + off_list_last]        ;r8 es el ultimo elem de la lista antes de agregar el nuevo
    mov [rax + off_elem_prev], r8        ;el elemento que agregue apunta al anterior (antes primero)
    mov [r8 + off_elem_next], rax        ;el ultimo elemento apunta al nuevo ultimo
    mov qword[rax + off_elem_next], 0      ;el ultimo elemnto apunta a NULL en el puntero al r14
    mov [r12 + off_list_last], rax       ;el puntero al ultimo elemento apunta al nuevo elemento

    .fin:
    mov rax, r12
    pop r13
    pop r12
    pop rbp
    ret

listAdd:
    push rbp
    mov rbp, rsp
    push rbx 
    push r12
    push r13
    push r14
    push r15
    sub rsp, 8
    mov rbx, rdi
    mov r12, rsi 
    mov r15, rdx    
    mov r13, [rbx + off_list_first] 
    cmp r13, 0 
    je .set_as_first
    mov rdi, r12 
    mov rsi, [r13 + off_elem_data]
    call r15 
    cmp eax, 1 ;a < b?
    je .set_as_first 
    mov r14, [r13 + off_elem_next]    

    .ciclo:
    cmp r14, 0 
    je .set_as_last
    mov rdi, r12
    mov rsi, [r14 + off_elem_data]
    call r15
    cmp eax, 1
    je .a_is_less
    mov r13, [r13 + off_elem_next]
    mov r14, [r13 + off_elem_next]
    jmp .ciclo 

    .a_is_less: 
    mov rdi, size_elem
    call malloc
    mov [rax + off_elem_data], r12 
    mov QWORD [rax + off_elem_next], 0
    mov r12, rax 
    mov [r13 + off_elem_next], r12 
    mov [r12 + off_elem_next], r14 
    mov [r12 + off_elem_prev], r13
    mov [r14 + off_elem_prev], r12
    jmp .fin

    .set_as_first:
    mov rdi, rbx 
    mov rsi, r12 
    call listAddFirst
    jmp .fin

    .set_as_last:
    mov rdi, rbx
    mov rsi, r12
    call listAddLast
    jmp .fin

    .fin:
    mov rax, rbx 
    add rsp, 8
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbx
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
    mov r12, rdi                ;lista
    mov r13, rsi                ;data
    mov r14, rdx                ;cmp
    mov rbx, rcx                ;delete
    mov r15, [r12 + off_list_first]
    cmp r15, 0
    je .fin

    .primerElem:
    mov rdi, [r15 + off_elem_data]
    mov rsi, r13
    call r14
    cmp rax, 0
    je .eliminarPrimero
    mov r9, r15                                     ;r9 es el elemento anterior al que veo
    mov r15, [r15 + off_elem_next]
    cmp r15, 0
    je .fin
    jmp .ciclo

    .eliminarPrimero:
    mov r9, [r15 + off_elem_next]
    mov rdi, [r15 + off_elem_data]
    add rsp, 8
    push r9
    cmp rbx, 0
    je .fd0prim
    call rbx

    .fd0prim:
    mov rdi, r15
    call free
    pop r9
    sub rsp, 8
    mov [r12 + off_list_first], r9
    cmp r9, 0
    je .unicoElem
    mov qword [r9 + off_elem_prev], 0
    mov r15, r9
    jmp .primerElem

    .ciclo:
    mov rdi, [r15 + off_elem_data]
    mov rsi, r13
    call r14
    cmp rax, 0
    je .eliminar
    mov r15, [r15 + off_elem_next]
    cmp r15, 0
    je .fin
    jmp .ciclo

    .eliminar:
    cmp qword [r15 + off_elem_next], 0
    je .eliminarUltimo
    xor r8, r8
    xor r9, r9
    mov r9, [r15 + off_elem_prev]
    mov r8, [r15 + off_elem_next]
    mov [r9 + off_elem_next], r8
    mov [r8 + off_elem_prev], r9
    mov rdi, [r15 + off_elem_data]
    cmp rbx, 0
    je .fd0mid
    call rbx

    .fd0mid:
    mov rdi, r15
    mov r15, [r15 + off_elem_next]
    call free
    cmp r15, 0
    je .fin
    jmp .ciclo

    .eliminarUltimo:
    xor r8, r8
    mov r8, [r15 + off_elem_prev]
    mov qword [r8 + off_elem_next], 0
    mov rdi, [r15 + off_elem_data]
    cmp rbx, 0
    je .fd0ult
    call rbx

    .fd0ult:
    mov rdi, r15
    call free
    mov [r12 + off_list_last], r8
    jmp .fin

    .unicoElem:
    mov [r12 + off_list_last], r9

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
    push r15
    mov r12, rdi
    mov r14, rsi

    mov r13, [r12 + off_list_first]
    cmp r13, 0
    je .fin

    mov r15, [r13 + off_elem_next]
    mov [r12 + off_list_first], r15
    cmp r15, 0
    je .1Elem
    mov qword [r15 + off_elem_prev], 0
    mov rdi, [r13 + off_elem_data]
    cmp r14, 0
    je .fd0
    call r14

    .fd0:
    mov rdi, r13
    call free
    jmp .fin

    .1Elem:
    mov rdi, [r13 + off_elem_data]
    call r14
    mov rdi, r13
    call free
    mov qword [r12 + off_list_last], 0

    .fin:
        mov rax, r12
        pop r15
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
    push r15
    mov r12, rdi
    mov r14, rsi

    mov r13, [r12 + off_list_last]
    cmp r13, 0
    je .fin

    mov r15, [r13 + off_elem_prev]
    mov [r12 + off_list_last], r15
    cmp r15, 0
    je .1Elem
    mov qword [r15 + off_elem_next], 0
    mov rdi, [r13 + off_elem_data]
    cmp r14, 0
    je .fd0
    call r14

    .fd0:
    mov rdi, r13
    call free
    jmp .fin

    .1Elem:
    mov rdi, [r13 + off_elem_data]
    call r14
    mov rdi, r13
    call free
    mov qword [r12 + off_list_first], 0

    .fin:
        mov rax, r12
        pop r15
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
        cmp r13, 0
        je .fin
        cmp r14, 0
        je .fd0
        mov rdi, [r13 + off_elem_data]
        call r14
        
        .fd0:
        mov rdi, r13
        mov r13, [r13 + off_elem_next]
        mov [r12 + off_list_first], r13
        call free
        jmp .ciclo

    .fin:
        mov qword [r12 + off_list_last], 0
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
    cmp qword r14, 0
    je .fin

    .ciclo:
        mov rsi, r13 ;file*
        mov rdi, [r14 + off_elem_data]; struct*
        call r15

        mov r14, [r14 + off_elem_next]
        cmp qword r14, 0
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

    mov qword [rax + off_tree_first], 0

    pop rbp
    ret

n3treeAdd:
    push rbp ;ALINEADA
    mov rbp, rsp
    push r12 ; DESALINEADA
    push r13 ; ALINEADA
    push r14 ; DESALINEADA
    push r15
    push rbx
    sub rsp, 8

    mov r15, rdi
    mov r12, [rdi + off_tree_first] ; ptro al n3tree
    mov r13, rsi ; dato 
    xor r14, r14 ; r14
    mov rbx, rdx
    .ciclo:
        cmp r12, 0 ; si apunta a NULL creamos un nuevo nodo
        je .agregar
                        ; si no comparamos hasta encontrar su ubicacion
        mov rdi, r13 ; data 
        mov rsi, [r12 + off_tree_elem_data] ; n3_data
        call rbx ; llamo a fc 
        cmp eax, 0 ; si data > n3_data esto da -1 
        je .iguales
        jg .menor

        ;mayor
        lea r14, [r12 + off_tree_elem_right]
        jmp .avanzar

        .menor:
            lea r14, [r12 + off_tree_elem_left]

        .avanzar:
            mov r12, [r14]
            mov r15, r14
            jmp .ciclo

        .agregar: 
            mov rdi, size_tree_elem
            call malloc
            

            mov [r15], rax ; asigno la direccion del nuevo elem del n3tree
            mov [rax + off_tree_elem_data], r13
            mov qword [rax + off_tree_elem_left], 0
    
            mov qword [rax + off_tree_elem_right], 0
            mov r12 , rax ;modifica antes mov r8 , rax
            call listNew
            mov qword [r12 + off_tree_elem_center], rax
            jmp .fin

        .iguales:
            mov r14, [r12 + off_tree_elem_center]
            ;mov r12, [r14]
            mov rdi, r14    
            mov rsi, r13
            call listAddFirst
            ;mov rax, [r14]
            jmp .fin

    .fin:
    add rsp , 8
    pop rbx
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbp
    ret

n3treeRemoveEqAux:
    push rbp
    mov rbp, rsp
    push r12
    push r13
    mov r12, rdi
    mov r13, rsi
    cmp r12, 0
    je .fin

    ;recorro como si fuera el print
    mov rdi, [r12 + off_tree_elem_left]
    mov rsi, r13
    call n3treeRemoveEqAux

    mov rdi, [r12 + off_tree_elem_center]
    mov rsi, r13
    call listDelete
    call listNew
    mov [r12 + off_tree_elem_center], rax

    mov rdi, [r12 + off_tree_elem_right]
    mov rsi, r13
    call n3treeRemoveEqAux

    .fin:
    pop r13
    pop r12
    pop rbp
    ret

n3treeRemoveEq:    
    push rbp
    mov rbp, rsp
    push r12
    push r13
    mov r12, rdi
    mov r13, [r12 + off_tree_first]
    cmp r12, 0
    je .fin
    mov rdi, r13
    call n3treeRemoveEqAux

    .fin:
    pop r13
    pop r12
    pop rbp
    ret

n3treeDeleteAux:
    push rbp
    mov rbp, rsp
    push r12
    push r13
    push r14
    sub rsp, 8
    mov r12, rdi
    mov r13, rsi
    cmp r12, 0
    je .fin

    ;recorro como si fuera el print
    mov rdi, [r12 + off_tree_elem_left]
    mov rsi, r13
    call n3treeDeleteAux

    cmp r13, 0
    je .fd0
    mov rdi, [r12 + off_tree_elem_data]
    call r13

    .fd0:
    mov rdi, [r12 + off_tree_elem_center]
    mov rsi, r13
    call listDelete
    mov r14, [r12 + off_tree_elem_right]
    mov rdi, r12
    call free

    mov rdi, r14
    mov rsi, r13
    call n3treeDeleteAux

    .fin:
    add rsp, 8
    pop r14
    pop r13
    pop r12
    pop rbp
    ret

n3treeDelete:
    push rbp
    mov rbp, rsp
    push r12
    push r13
    mov r12, rdi
    mov r13, [r12 + off_tree_first]
    cmp r12, 0
    je .fin
    mov rdi, r13
    call n3treeDeleteAux

    .fin:
    mov rdi, r12
    call free
    pop r13
    pop r12
    pop rbp
    ret

nTableNew:
    push rbp
    mov rbp, rsp
    push r12
    push r13 
    push r14
    sub rsp, 8 
    xor r12, r12
    mov r12d, edi

    mov rdi, 16
    call malloc
    mov r14, rax
    mov dword [r14 + off_table_size], r12d

    shl r12d, 3
    mov rdi, r12
    call malloc
    mov [r14 + off_table_list], rax

    mov r13, rax
    sub r12d, 8
    add r12, r13

    .ciclo:
    cmp r13d, r12d
    jg .fin 
    call listNew
    mov [r13], rax
    lea r13d, [r13d + 8]
    jmp .ciclo

    .fin:
    mov rax, r14
    add rsp, 8
    pop r14
    pop r13
    pop r12
    pop rbp
    ret

nTableAdd:
    push rbp
    mov rbp, rsp
    push r12
    push r13
    push r14
    push r15
    mov r12, [rdi]
    xor r13, r13
    mov r13, rsi
    mov r14, rdx
    mov r15, rcx
    xor r8, r8
    mov r8d, [rdi + off_table_size]

    .modulo:
    cmp r13, r8
    jl .agregar
    jg .resta
    mov r13, 0
    jmp .agregar

    .resta:
    sub r13, r8
    jmp .modulo

    .agregar:
    mov r12, [r12 + r13*8]
    mov rdi, r12
    mov rsi, r14
    mov rdx, r15
    call listAdd

    pop r15
    pop r14
    pop r13
    pop r12
    pop rbp
    ret
    
nTableRemoveSlot:
    push rbp
    mov rbp, rsp
    push r12
    push r13
    push r14
    push r15
    push rbx
    sub rsp, 8
    mov r12, [rdi]
    xor r13, r13
    mov r13, rsi
    mov r14, rdx
    mov r15, rcx
    mov rbx, r8
    xor r9, r9
    mov r9d, [rdi + off_table_size]

     .modulo:
    cmp r13, r9
    jl .remove
    jg .resta
    mov r13, 0
    jmp .remove

    .resta:
    sub r13, r9
    jmp .modulo

    .remove:
    mov r12, [r12 + r13*8]
    mov rdi, r12
    ;mov rsi, r15
    mov rsi, r14
    mov rdx, r15
    mov rcx, rbx
    call listRemove

    add rsp, 8
    pop rbx
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbp
    ret
    ret

nTableDeleteSlot:
    push rbp
    mov rbp, rsp
    push r12
    push r13
    push r14
    push r15
    mov r12, [rdi]
    xor r13, r13
    mov r13, rsi
    mov r14, rdx
    xor r8, r8
    mov r8d, [rdi + off_table_size]

    .modulo:
    cmp r13, r8
    jl .delete
    jg .resta
    mov r13, 0
    jmp .delete

    .resta:
    sub r13, r8
    jmp .modulo

    .delete:
    lea r12, [r12 + r13*8]
    mov rdi, [r12]
    mov rsi, r14
    call listDelete
    call listNew
    mov [r12], rax

    pop r15
    pop r14
    pop r13
    pop r12
    pop rbp
    ret

nTableDelete:
    push rbp
    mov rbp, rsp
    push r12
    push r13
    push r14
    push r15
    push rbx
    sub rsp, 8
    mov r12, [rdi]
    mov r13, rsi
    mov rbx, rdi
    xor r14, r14
    xor r15, r15
    mov r14d, [rdi + off_table_size]
    
    .ciclo:
    cmp r14, 0
    je .fin
    mov r12, [rbx]
    lea r12, [r12 + r15]
    mov rdi, [r12]
    mov rsi, r13
    call listDelete
    dec r14
    add r15, 8
    jmp .ciclo

    .fin:
    mov rdi, [rbx]
    call free
    mov rdi, rbx
    call free
    add rsp, 8
    pop rbx
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbp
    ret
