;vim: ts=8,sw=8
;https://www.codewars.com/kata/56bc28ad5bdaeb48760009b0
;
;It's pretty straightforward. Your goal is to create a function that removes
;the first and last characters of a string. You're given one parameter, the
;original string. You don't have to worry with strings with less than two
;characters.
.macro PARAMS
.struct Chomp
	str	.word
.endstruct
.endmacro

.macro VARS _
;  name			bytes	default value
.endmacro

.macro SPRITES _
;  name			y		sprite	flags		x
.endmacro

.include "common.inc"

.segment	"CODE"
input:		.asciiz "zRemove the z's!z"
inputlen=	*-input

.segment	"ZEROPAGE"
output:		.res inputlen

.segment	"CODE"
chomp:
@str=		P::Chomp::str

		ldy #0
:		iny		
		lda (@str),y
		dey
		sta (@str),y
		iny
		cmp #0
		bne :-

		dey
		dey
		sta (@str),y
		rts



start:		ldx #0
:		lda input,x
		sta output,x
		beq :+
		inx
		jmp :-

:		lda #<output
		sta P::PutZString::zstring
		lda #>output
		sta P::PutZString::zstring+1
		jsr putzstring
		jsr putnewline

		lda #<output
		sta P::Chomp::str
		lda #>output
		sta P::Chomp::str+1
		jsr chomp

		lda #<output
		sta P::PutZString::zstring
		lda #>output
		sta P::PutZString::zstring+1
		jsr putzstring

		rts

update:		rts
