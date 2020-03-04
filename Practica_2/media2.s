.section .data

#ifndef TEST
#define TEST 15
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

	#else
		.error "Definit TEST entre 1..8"

	#endif
.endm

lista:		.irpc i,1234
			linea
		.endr
longlista:	.int   (.-lista)/4
resultado:	.quad   0
  formato: 	.ascii	"resultado \t = %18ld (sgn)\n"
		.ascii "\t\t = 0x%18lx (hex)\n"
		.ascii "\t\t = 0x %08x %08x\n"

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
	mov  %eax, resultado
	mov  %edx, resultado+4
	ret

suma:
	mov  $0, %eax	# Lresultado
	mov  $0, %rsi	# Contador
	mov  $0, %edx	# Hresultado
bucle:
	mov (%rbx,%rsi,4),%ebp # ebp = Llista[%rsi]
	test %ebp,%ebp
	jns positivo
	add %ebp,%eax
	adc $0xffffffff,%edx
	jmp continua

positivo:
	add  %ebp, %eax
	adc  $0,%edx		# %edx = 0 + %edx + CF

continua:
	inc   %rsi
	cmp   %rsi,%rcx
	jne    bucle			# jump if not equal a bucle	
	ret

imprim:				# requiere libC
	mov   $formato, %rdi	# registros del estándar de llamadacon argumentos
	mov   resultado,%rsi
	mov   resultado,%rdx
	mov   resultado+4,%rcx
	mov   resultado,%r8
	mov          $0,%eax	# varargin sin xmm
	call  printf		# == printf(formato, res, res, Hres, Lres);
	ret

acabar:				# requiere libC
	mov  resultado, %edi
	call _exit		# ==  exit(resultado)
	ret
