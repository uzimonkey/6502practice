;vim: ts=8,sw=8
.include "common.inc"

.union Params
.endunion

.macro VARS _
;  name			bytes	default value
.endmacro

.macro SPRITES _
;  name			y		sprite	flags		x
.endmacro

.segment	"STARTUP"

.segment	"CODE"
input:		.asciiz "Hello, world!"
inputsize=	* - input

.segment	"ZEROPAGE"
VARS ZPAGE_DEFINITIONS
params:		.tag Params
output:		.res inputsize

.segment	"CODE"
zpagedefaults:
VARS ZPAGE_DEFAULTS
zpagedefaultslen = * - zpagedefaults

spritedata:	
SPRITES SPRITEDATA
spritedatalen = * - spritedata

.segment	"CODE"
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
