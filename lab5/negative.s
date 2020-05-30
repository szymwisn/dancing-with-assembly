.text

.globl negativeAssembly
.type negativeAssembly, @function
negativeAssembly:
    pushq %rbp
    movq %rsp, %rbp
    
    emms

    movq %rdx, %rax                     # imgBytes
    movq $8, %rcx
    movq $0, %rdx
    divq %rcx
    movq %rax, %rcx                     # imgBytes/8 in rcx

    movq %rdi, %rax                     # pixels pointer in rax
    movq %rsi, %rbx                     # result pointer in rbx

    movq $0, %rdi                       # reset counter

    loop: 
        movq (%rax, %rdi, 8), %mm0      # write pixel to mm0
        pcmpeqd %mm1, %mm1
        pxor %mm1, %mm0
        pandn %mm1, %mm1
        movq %mm0, (%rbx, %rdi, 8)      # copy new pixel to result
        
        inc %rdi
        cmp %rdi, %rcx
        jnz loop

    emms

    movq %rbp, %rsp
    popq %rbp
    ret
