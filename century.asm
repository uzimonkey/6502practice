.macro PARAMS
.struct Century
	year	.word
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
input:		.word 1705, 1900, 1901, 1899, 2000, 765, 1066
inputsize=	*-input

century:	
@year=		P::Century::year

		ldx #0
:		lda @year
		sec
		sbc #100
		sta @year
		lda @year+1
		sbc #0
		sta @year+1
		bmi :+
		inx
		jmp :-
:		inx
		txa
		rts

start:		ldx #0
:		txa
		pha

		lda input,x
		sta P::PutInt::int
		lda input+1,x
		sta P::PutInt::int+1
		jsr putint
		lda #' '
		jsr putchar

		pla
		pha
		tax

		lda input,x
		sta P::Century::year
		lda input+1,x
		sta P::Century::year+1
		jsr century

		sta P::PutInt::int
		lda #0
		sta P::PutInt::int+1
		jsr putint
		jsr putnewline

		pla
		tax
		inx
		inx
		cmp #inputsize
		bne :-

		rts

update:		rts
