.text

.globl negativeAssembly
.type negativeAssembly, @function
negativeAssembly:
    pushq %rbp
    movq %rsp, %rbp
    
    movq %rdi, %rax                     # input pointer
    movq %rsi, %rbx                     # output pointer
    movq %rdx, %rcx                     # imgBytes

    movq $0, %rdi                       # reset counter
    emms

    loop: 
        movq (%rax, %rdi, 8), %mm0      # write pixel to mm0
        pcmpeqd %mm1, %mm1
        pxor %mm1, %mm0
        pandn %mm1, %mm1
        movq %mm0, (%rbx, %rdi, 8)      # move new pixel to output
        inc %rdi

        dec %rcx
        cmp $0, %rcx
        jnz loop

    movq %rbp, %rsp
    popq %rbp
    ret
