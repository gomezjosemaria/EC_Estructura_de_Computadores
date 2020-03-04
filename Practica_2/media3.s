.section .data

#ifndef TEST
#define TEST 20
#endif

.macro linea

	#if TEST==1
		.int -1,-1,-1,-1

	#elif TEST==2
		.int 0x04000000,0x04000000,0x04000000,0x04000000

	#elif TEST==3
		.int 0x08000000,0x08000000,0x08000000,0x08000000

	#elif TEST==4
		.int 0x10000000,0x10000000,0x10000000,0x10000000

	#elif TEST==5
		.int 0x7fffffff,0x7fffffff,0x7fffffff,0x7fffffff

	#elif TEST==6
		.int 0x80000000,0x80000000,0x80000000,0x80000000

	#elif TEST==7
		.int 0xf0000000,0xf0000000,0xf0000000,0xf0000000

	#elif TEST==8
		.int 0xf8000000,0xf8000000,0xf8000000,0xf8000000

	#elif TEST==9
		.int 0xf7ffffff,0xf7ffffff,0xf7ffffff,0xf7ffffff

	#elif TEST==10
		.int 100000000,100000000,100000000,100000000

	#elif TEST==11
		.int 200000000,200000000,200000000,200000000

	#elif TEST==12
		.int 300000000,300000000,300000000,300000000

	#elif TEST==13
		.int 2000000000,2000000000,2000000000,2000000000

	#elif TEST==14
		.int 3000000000,3000000000,3000000000,3000000000

	#elif TEST==15
		.int -100000000,-100000000,-100000000,-100000000

	#elif TEST==16
		.int -200000000,-200000000,-200000000,-200000000

	#elif TEST==17
		.int -300000000,-300000000,-300000000,-300000000

	#elif TEST==18
		.int -2000000000,-2000000000,-2000000000,-2000000000

	#elif TEST==19
		.int -3000000000,-3000000000,-3000000000,-3000000000

	#else
		.error "Definit TEST entre 1..19"

	#endif
.endm

lista:		.irpc i,1234
			linea
		.endr
longlista:	.int   (.-lista)/4
media:		.int 0
resto:		.int 0
formato: 	.ascii "media \t = %11d \t resto \t = %11d\n"
		.asciz "\t\t = 0x %08x \t\t = 0x %08x \n"

.section .text
.global _start

main: .global  main

	call trabajar	# subrutina de usuario
	call imprim	# printf()  de libC
	call acabar	# exit()    de libC
	ret

trabajar:
	mov     $lista, %rbx
	mov  longlista, %ecx
	call suma		# == suma(&lista, longlista);
	mov  %eax, media
	mov  %edx, resto
	ret

suma:
	mov  $0, %eax	# Lmedia
	mov  $0, %rsi	# Contador del bucle
	mov  $0, %edx	# Hmedia

bucle:
	mov (%rbx,%rsi,4),%ebp	# %ebp = Llista[%rsi]
	test %ebp,%ebp		# SF = signo de %ebp
	jns positivo		# Comprobar si es positivo
	add %ebp,%eax		
	adc $0xffffffff,%edx	# %edx = 0xffffffff + %edx + CF
	jmp continua		

positivo:
	add  %ebp, %eax
	adc  $0,%edx		# %edx = 0 + %edx + CF

continua:
	inc   %rsi		# i++
	cmp   %rsi,%rcx		# Si %rsi == al tamaño de la lista
	jne    bucle		# jump if not equal a bucle
	idiv  %esi		# %edx:%eax/%esi --> Resultado=%eax Resto=%edx
	ret

imprim:				# requiere libC
	mov   $formato, %rdi	# %rdi primer argumento
	mov   media,%rsi	# %rsi segundo argumento
	mov   resto,%rdx	# %rdx tercer argumento
	mov   media,%rcx	# %rcx cuarto argumento
	mov   resto,%r8		# %r8 quinto argumento
	mov   $0,%eax		# varargin sin xmm
	call  printf		# == printf(formato, media, resto, HexMedia, HexResto);
	ret

acabar:				# requiere libC
	mov  media, %edi
	call _exit		# ==  exit(media)
	ret
