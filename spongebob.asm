;Change text into into spongebob mocking text
; hello world => hElLo wOrLd
.macro PARAMS
.struct Spongebob
	str	.word
	case	.byte
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
input:		.asciiz "The 6502 is a garbage CPU!"
inputlen=	*-input

.segment	"ZEROPAGE"
output:		.res inputlen

.segment	"CODE"
spongebob:
@str=		P::Spongebob::str
@case=		P::Spongebob::case

		ldy #0
		sty @case		;reset spongebob case
@loop:		lda (@str),y		;get next char
		beq @done
		tax			;save sign bit on stack
		and #$20		;case bit in zero flag
		php
		txa
		and #$df		;clear case bit
		cmp #'A'-1		;if < a, not a letter
		bcc @notletter
		cmp #'Z'+1		;if > z, not a letter
		bcs @notletter

		ora @case		;flip case and 
		sta (@str),y		;store result
		lda @case		;flip spongebob case
		eor #$20
		sta @case

		plp
		iny
		jmp @loop

@notletter:	plp			;resore sign bit
		beq :+
		ora #$20
:		iny
		jmp @loop

@done:		rts


start:		ldx #0
:		lda input,x
		sta output,x
		inx
		cmp #0
		bne :-

		lda #<output
		sta P::PutZString::zstring
		lda #>output
		sta P::PutZString::zstring+1
		jsr putzstring
		jsr putnewline

		lda #<output
		sta P::Spongebob::str
		lda #>output
		sta P::Spongebob::str+1
		jsr spongebob

		lda #<output
		sta P::PutZString::zstring
		lda #>output
		sta P::PutZString::zstring+1
		jsr putzstring

		rts

update:		rts
