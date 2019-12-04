;Reverse the array!
.macro PARAMS
.struct Reverse
	ary	.word
	len	.byte
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
input:		.byte 1, 2, 3, 4, 5, 6
inputlen=	*-input

.segment	"ZEROPAGE"
output:		.res inputlen

.segment	"CODE"
;reverse an array using the stack
reverse:
@ary=		P::Reverse::ary
@len=		P::Reverse::len

		ldy #0
:		lda (@ary),y
		pha
		iny
		cpy @len
		bne :-

		ldy #0
:		pla
		sta (@ary),y
		iny
		cpy @len
		bne :-

		rts

start:		ldx #0
:		lda input,x
		sta output,x
		inx
		cmp #inputlen
		bne :-

		ldx #0
:		lda output,x
		sta P::PutInt::int
		lda #0
		sta P::PutInt::int+1
		txa
		pha
		jsr putint
		pla
		tax
		inx
		cpx #inputlen
		bne :-
		jsr putnewline

		lda #<output
		sta P::Reverse::ary
		lda #0
		sta P::Reverse::ary+1
		lda #inputlen
		sta P::Reverse::len
		jsr reverse

		ldx #0
:		lda output,x
		sta P::PutInt::int
		lda #0
		sta P::PutInt::int+1
		txa
		pha
		jsr putint
		pla
		tax
		inx
		cpx #inputlen
		bne :-

		rts

update:		rts
