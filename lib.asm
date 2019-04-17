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
    push rbp
    mov rbp, rsp
    push r12
    push r13
    push r14
    push r15
    push rbx
    sub rsp, 8
    mov rbx, rdi
    mov r12, rsi
    cmp byte [rbx], 0
    jne .primeroNoVacio ;el caso en el que el primer *char es vacio por alguna razon no pasaba, pero cuando era el segudno *char vacio si pasa, entonces aca los doy vuelta.
    mov r12, rdi
    mov rbx, rsi
    mov rdi, rbx

    .primeroNoVacio:
    call strLen
    mov r13d, eax
    mov r14d, r13d
    mov rdi, r12
    call strLen
    add r13d, eax
    inc r13d
    mov edi, r13d
    call malloc
    xor r8, r8
    mov r8d, r14d
    mov r14, rax
    mov r15, r14
    mov ecx, r8d

    .ciclo1:
    mov r9b, [rbx]
    mov [r14], r9b
    inc rbx
    inc r14
    loop .ciclo1

    sub r13d, r8d
    mov ecx, r13d

    .ciclo2:
    mov r9b, [r12]
    mov [r14], r9b
    inc r12
    inc r14
    loop .ciclo2
    sub ebx, r8d
    mov rdi, rbx
    call strDelete
    sub r12d, r13d
    mov rdi, r12
    call strDelete
    mov rax, r15
    add rsp, 8
    pop rbx
    pop r15
    pop r14
    pop r13
    pop r12
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
    jne .firstNotNull

    xor r8, r8
    mov r8, [r12 + off_list_first]       ;r8 es el primer elem de la lista antes de agregar el nuevo
    mov [rax + off_elem_next], r8        ;el elemento que agregue apunta al siguiente (antes primero)
    mov [r12 + off_list_last], rax        ;el puntero al ultimo apunta al ultimo elemento
    mov qword[rax + off_elem_prev], NULL      ;el primer elemnto apunta a NULL en el puntero al previo
    mov [r12 + off_list_first], rax      ;el puntero al primer elemento apunta al nuevo elemento
    jmp .fin

    .firstNotNull:
    mov r8, [r12 + off_list_first]       ;r8 es el primer elem de la lista antes de agregar el nuevo
    mov [rax + off_elem_next], r8        ;el elemento que agregue apunta al siguiente (antes primero)
    mov [r8 + off_elem_prev], rax        ;el segundo elemento apunta al primero
    mov qword[rax + off_elem_prev], NULL      ;el primer elemnto apunta a NULL en el puntero al previo
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
    cmp r8, NULL                     ;comparo si el ultimo es null
    jne .lastNotNull

    xor r8, r8
    mov r8, [r12 + off_list_last]        ;r8 es el ultimo elem de la lista antes de agregar el nuevo
    mov [rax + off_elem_prev], r8        ;el elemento que agregue apunta al anterior (antes primero)
    mov [r12 + off_list_first], rax       ;el puntero al primero apunta al ultimo elemento
    mov qword[rax + off_elem_next], NULL      ;el ultimo elemnto apunta a NULL en el puntero al siguiente
    mov [r12 + off_list_last], rax       ;el puntero al ultimo elemento apunta al nuevo elemento
    jmp .fin

    .lastNotNull:
    mov r8, [r12 + off_list_last]        ;r8 es el ultimo elem de la lista antes de agregar el nuevo
    mov [rax + off_elem_prev], r8        ;el elemento que agregue apunta al anterior (antes primero)
    mov [r8 + off_elem_next], rax        ;el ultimo elemento apunta al nuevo ultimo
    mov qword[rax + off_elem_next], NULL      ;el ultimo elemnto apunta a NULL en el puntero al siguiente
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
    mov r12, rdi
    mov r13, rsi
    mov r14, rdx
    mov rbx, rcx
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
        call rbx
        mov rdi, r15
        call free
        mov [r12 + off_list_first], r9
        cmp r9, 0
        je .unicoElem
        mov qword [r9 + off_elem_prev], NULL
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
        cmp qword [r15 + off_elem_next], NULL
        je .eliminarUltimo
        xor r8, r8
        xor r9, r9
        mov r9, [r15 + off_elem_prev]
        mov r8, [r15 + off_elem_next]
        mov [r9 + off_elem_next], r8
        mov [r8 + off_elem_prev], r9
        mov rdi, [r15 + off_elem_data]
        call rbx
        mov rdi, r15
        mov r15, [r15 + off_elem_next]
        call free
        cmp r15, 0
        je .fin
        jmp .ciclo

    .eliminarUltimo:
        xor r8, r8
        mov r8, [r15 + off_elem_prev]
        mov qword [r8 + off_elem_next], NULL
        mov rdi, [r15 + off_elem_data]
        call rbx
        mov rdi, r15
        call free
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
    sub rsp, 8
    mov r12, rdi
    mov r14, rsi

    mov r13, [r12 + off_list_first]
    cmp r13, 0
    je .fin

    mov r8, [r13 + off_elem_next]
    mov [r12 + off_list_first], r8
    cmp r8, 0
    jne .twoOrMoreElem
    mov [r12 + off_list_last], r8

    .twoOrMoreElem:
    mov rdi, [r13 + off_elem_data]
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

    mov r13, [r12 + off_list_last]
    cmp r13, 0
    je .fin

    mov r8, [r13 + off_elem_prev]
    mov [r12 + off_list_last], r8
    cmp r8, 0
    jne .twoOrMoreElem
    mov [r12 + off_list_first], r8

    .twoOrMoreElem:
    mov rdi, [r13 + off_elem_data]
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

n3treeAdd:  ;en esta funcion y en todas las que siguen de arboles, no funcina bien no? 
            ;porque llamo recursion pero el unico tree_first es el de el inicio de arbol, no el de todos los arboles hijos
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
    ;aca ya me tengo que ir a .fin??

    .notNULL:
    mov r8, [r15 + off_tree_elem_data]
    cmp r8, r13
    je .insert
    jg .leftTree
    mov rdi, [r15 + off_tree_elem_right]
    mov rsi, r13
    mov rdx, r14
    call n3treeAdd
    jmp .fin

    .leftTree:
    mov rdi, [r15 + off_tree_elem_left]
    mov rsi, r13
    mov rdx, r14
    call n3treeAdd
    jmp .fin

    .insert:
    mov rdi, [r15 + off_tree_elem_center]
    mov rsi, r13
    mov rdx, r14
    call listAdd

    .fin:
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbp
    ret

n3treeRemoveEq:
    push rbp
    mov rbp, rsp
    push r12
    push r13
    push r14
    sub rsp, 8
    mov r12, rdi
    mov r13, rsi

    mov r8, [r12 + off_tree_first]
    mov r14, [r8]

    cmp r15, NULL
    je .fin

    mov rdi, [r14 + off_tree_elem_data]
    call r13 ;o tengo que ir dato a dato eliminandolo?

    mov rdi, [r14 + off_tree_elem_right]
    mov rsi, r13
    call n3treeRemoveEq
    mov rdi, [r14 + off_tree_elem_left]
    mov rsi, r13
    call n3treeRemoveEq

    .fin:
    add rsp, 8
    pop r14
    pop r13
    pop r12
    pop rbp
    ret

n3treeDelete:
    ret

nTableNew:
    push rbp
    mov rbp, rsp
    push r12
    push r13
    mov r12, rdi
    xor r13, r13

    .multiplicacion:
    cmp r12, 0
    je .malloc
    add r13, 8
    dec r12
    jmp .multiplicacion

    .malloc:
    mov r12, rdi ;recupero el tamaño de la lista
    mov rdi, r13
    call malloc
    xor r8, r8
    mov r8, r12 ;uso r8 como iterador
    mov r12, rax
    mov r13, rax ;este lo voy a usar para devolver la tabla

    .ciclo:
    cmp r8, 0
    je .fin
    mov qword rdi, [r12]
    call listNew
    inc r12
    dec r8
    jmp .ciclo

    .fin:
    mov rax, r13
    pop r13
    pop r12
    pop rbp
    ret

nTableAdd:
    ret
    
nTableRemoveSlot:
    ret
    
nTableDeleteSlot:
    ret

nTableDelete:
    ret
