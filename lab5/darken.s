MASK = 0x0A0A0A0A0A0A0A0A

.text

.globl darkenAssembly
.type darkenAssembly, @function
darkenAssembly:
    pushq %rbp
    movq %rsp, %rbp
    
    emms

    movq $MASK, %rax
    movq %rax, %mm1

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
        psubusb %mm1,%mm0               # substract mask from pixel
        movq %mm0, (%rbx, %rdi, 8)      # copy new pixel to result
        
        inc %rdi
        cmp %rdi, %rcx
        jnz loop

    emms

    movq %rbp, %rsp
    popq %rbp
    ret
