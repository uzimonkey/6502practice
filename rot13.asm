;vim: ts=8,sw=8
.macro PARAMS
.endmacro

.macro VARS _
;  name			bytes	default value
.endmacro

.macro SPRITES _
;  name			y		sprite	flags		x
.endmacro

.include "common.inc"

.segment	"CODE"
input:		.asciiz "Hello, world!"
inputsize=	* - input

.segment	"ZEROPAGE"
output:		.res inputsize

.segment	"CODE"
start:		lda #<input
		sta params+P::PutZString::zstring
		lda #>input
		sta params+P::PutZString::zstring+1
		jsr putzstring
		jsr putnewline

		ldx #0
@loop:		lda input,x		;get char
		tay

		cmp #'A'		;check if capital
		bcc @output
		cmp #'Z'
		bcs @lower

		adc #13
		cmp #'Z'
		bcc @output
		sbc #26
		jmp @output

@lower:		cmp #'a'
		bcc @output
		cmp #'z'
		bcs @output
		adc #13
		cmp #'z'
		bcc @output
		sbc #26

@output:	sta output,x
		beq :+
		inx
		jmp @loop

:		lda #<output
		sta params+P::PutZString::zstring
		lda #>output
		sta params+P::PutZString::zstring+1
		jsr putzstring

		jsr putnewline
		lda #1
		jsr putchar

		rts

update:		rts
