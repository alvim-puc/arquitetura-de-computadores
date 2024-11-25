.data
array:      .word 10, 20, 30, 40, 50   # Array de exemplo
array_size: .word 5                    # Tamanho do array
sum:        .word 0                    # Soma inicializada em 0
product:    .word 1                    # Produto inicializado em 1
result:     .word 0                    # Resultado da verificação
soma_text:      .asciiz "Sum: "        # Texto para soma
produto_text:   .asciiz "Product: "    # Texto para produto
resultado_text: .asciiz "Result: "     # Texto para resultado
newline:        .asciiz "\n"           # Quebra de linha

.text
.globl main
main:
    # Inicializações
    la $t0, array           # Carrega o endereço do array em $t0
    lw $t1, array_size      # Carrega o tamanho do array em $t1
    la $t2, sum             # Carrega o endereço da soma em $t2
    la $t3, product         # Carrega o endereço do produto em $t3

    li $t4, 0               # Inicializa o índice
    li $s0, 0               # Soma (agora em $s0)
    li $s1, 1               # Produto (agora em $s1)

soma_prod_loop:
    beq $t4, $t1, end_loop  # Se índice >= tamanho, sair do loop

    # Chama a função para calcular a soma
    jal calc_sum            # Salta para a função calc_sum

    # Chama a função para calcular o produto
    jal calc_product        # Salta para a função calc_product

    # Atualiza o índice e avança para o próximo elemento
    addi $t4, $t4, 1        # Incrementa o índice
    addi $t0, $t0, 4        # Avança para o próximo elemento
    j soma_prod_loop        # Recomeça o loop

# Função para calcular a soma
calc_sum:
    lw $t5, 0($t0)          # Carrega o próximo elemento do array
    add $s0, $s0, $t5       # Soma ao acumulador
    jr $ra                  # Retorna ao ponto de chamada

# Função para calcular o produto
calc_product:
    lw $t5, 0($t0)          # Carrega o próximo elemento do array
    mul $s1, $s1, $t5       # Multiplica ao acumulador
    jr $ra                  # Retorna ao ponto de chamada

end_loop:
    # Salva os resultados de soma e produto na memória
    sw $s0, 0($t2)          # Salva a soma acumulada
    sw $s1, 0($t3)          # Salva o produto acumulado

    # Verificação condicional
    li $t8, 100             # Valor limite
    lw $t9, 0($t2)          # Carrega a soma
    blt $t9, $t8, less_than # Se soma < limite, salve 0
    li $t7, 1               # Caso contrário, salve 1
    j save_result           # Pular para salvar o resultado

less_than:
    li $t7, 0               # Se soma < limite, define 0

save_result:
    sw $t7, result          # Salva o resultado na memória

    # Exibição de resultados
    # Exibir soma
    li $v0, 4               # Código para imprimir string
    la $a0, soma_text       # Carrega "Sum: "
    syscall

    li $v0, 1               # Código para imprimir inteiro
    lw $a0, sum             # Soma acumulada
    syscall

    li $v0, 4               # Linha em branco
    la $a0, newline
    syscall

    # Exibir produto
    li $v0, 4               # Código para imprimir string
    la $a0, produto_text    # Carrega "Product: "
    syscall

    li $v0, 1               # Código para imprimir inteiro
    lw $a0, product         # Produto acumulado
    syscall

    li $v0, 4               # Linha em branco
    la $a0, newline
    syscall

    # Exibir resultado
    li $v0, 4               # Código para imprimir string
    la $a0, resultado_text  # Carrega "Result: "
    syscall

    li $v0, 1               # Código para imprimir inteiro
    lw $a0, result          # Resultado final
    syscall

    # Fim do programa
    li $v0, 10              # Finaliza a execução
    syscall
