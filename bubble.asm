;vim: ts=8,sw=8
.macro PARAMS
.struct Bubble
	in	.word
	len	.byte
.endstruct
.endmacro

.macro VARS _
;  name			bytes	default value
.endmacro

.macro SPRITES _
.endmacro

.include "common.inc"

.segment	"CODE"
input:		.byte 10, 9, 15, 7, 10, 12, 11, 0, 99
inputsize=	*-input

.segment	"ZEROPAGE"
output:		.res inputsize

.segment	"CODE"
bubblesort:	
@in=		P::Bubble::in
@len=		P::Bubble::len

		dec @len		;make @len idx of last elem, not length

@outer:		ldy #0
@inner:		lda (@in),y
		iny			;compare with next number
		cmp (@in),y
		bcc :+			;if next >= curr, don't swap

		tax			;save number
		lda (@in),y		;get next number
		dey
		sta (@in),y		;save next in current
		iny
		txa
		sta (@in),y		;save number in next

:		cpy @len		;y == @len?
		bne @inner

		dec @len
		bne @outer
		
		rts

start:		ldx #0			;print list
:		lda input,x
		sta output,x		;copy to output while printing
		sta P::PutInt::int
		lda #0
		sta P::PutInt::int+1

		txa
		pha
		jsr putint
		lda #' '
		jsr putchar
		pla
		tax

		inx
		cpx #inputsize
		bne :-
		jsr putnewline

		lda #<output
		sta P::Bubble::in
		lda #>output
		sta P::Bubble::in+1
		lda #inputsize
		sta P::Bubble::len
		jsr bubblesort

		ldx #0			;print list
:		lda output,x
		sta P::PutInt::int
		lda #0
		sta P::PutInt::int+1

		txa
		pha
		jsr putint
		lda #' '
		jsr putchar
		pla
		tax

		inx
		cpx #inputsize
		bne :-

		rts

update:		rts

