# Laboratorio: Estructura de Computadores
# Actividad: Optimizaci�n de Pipeline en Procesadores MIPS
# Objetivo: Calcular Y[i] = A * X[i] + B e identificar riesgos de datos.

.data
    vector_x: .word 1, 2, 3, 4, 5, 6, 7, 8
    vector_y: .space 32
    const_a:  .word 3
    const_b:  .word 5
    tamano:   .word 8

.text
.globl main

main:
    # --- Inicialización ---
    la $s0, vector_x      # Dirección base de X
    la $s1, vector_y      # Dirección base de Y
    lw $t0, const_a       # Cargar constante A
    lw $t1, const_b       # Cargar constante B
    lw $t2, tamano        # Cargar el tamaño del vector
    li $t3, 0             # �?ndice i = 0

loop:
    # --- Condición de salida ---
    beq $t3, $t2, fin     # Si i == tamano, salir del bucle
    
    # --- Cálculo de dirección de memoria ---
    sll $t4, $t3, 2       # Desplazamiento: t4 = i * 4
    addu $t5, $s0, $t4    # t5 = dirección de X[i]
    
    # --- Carga de dato ---
    lw $t6, 0($t5)        # Leer X[i]
    # NOTA: En un pipeline, la siguiente instrucción 'mul' depende de este 'lw'.
    
    # --- Operación aritmética ---
    mul $t7, $t6, $t0     # t7 = X[i] * A  (Riesgo de datos: Load-Use)
    addu $t8, $t7, $t1    # t8 = t7 + B    (Riesgo de datos: Dependencia mul-addu)
    
    # --- Almacenamiento de resultado ---
    addu $t9, $s1, $t4    # t9 = dirección de Y[i]
    sw $t8, 0($t9)        # Guardar resultado en Y[i]
    
    # --- Incremento y salto ---
    addi $t3, $t3, 1      # i = i + 1
    j loop

fin:
    # --- Finalización del programa ---
    li $v0, 10            # Syscall para terminar ejecución
    syscall
