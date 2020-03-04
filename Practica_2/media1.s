.section .data

#ifndef TEST
#define TEST 9
#endif

.macro linea

	#if TEST==1
		.int 1,1,1,1

	#elif TEST==2
		.int 0x0fffffff,0x0fffffff,0x0fffffff,0x0fffffff

	#elif TEST==3
		.int 0x10000000,0x10000000,0x10000000,0x10000000

	#elif TEST==4
		.int 0xffffffff,0xffffffff,0xffffffff,0xffffffff

	#elif TEST==5
		.int -1,-1,-1,-1

	#elif TEST==6
		.int 200000000,200000000,200000000,200000000

	#elif TEST==7
		.int 300000000,300000000,300000000,300000000

	#elif TEST==8
		.int 5000000000,5000000000,5000000000,5000000000

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
	mov  $0, %eax	#Lresultado
	mov  $0, %rsi	#Contador
	mov  $0, %edx	#Hresultado

bucle:
	add  (%rbx,%rsi,4), %eax	# %eax = 4 * %rsi + %rbx + %eax
	adc   $0, %edx			# %edx = 0 + %edx + CF
	inc   %rsi			# i++
	cmp   %rsi,%rcx			# Si %rsi == al tamaño de la lista
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
