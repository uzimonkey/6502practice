;vim: ts=8,sw=8
.union Params
.endunion

.macro VARS _
;  name			bytes	default value
.endmacro

.macro SPRITES _
;  name			y		sprite	flags		x
.endmacro

.include "common.inc"

.segment	"ZEROPAGE"
output:		.res inputsize

.segment	"CODE"
input:		.asciiz "Hello, world!"
inputsize=	* - input

start:		lda #<input
		sta zstring
		lda #>input
		sta zstring+1
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
		sta zstring
		lda #>output
		sta zstring+1
		jsr putzstring

		jsr putnewline
		lda #1
		jsr putchar

		rts

update:		rts
