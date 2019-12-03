;vim: ts=8,sw=8
.macro PARAMS
.endmacro

.macro VARS _
;  name			bytes	default value
_ i,			1,	0
.endmacro

.macro SPRITES _
;  name			y		sprite	flags		x
.endmacro

.include "common.inc"

.segment	"CODE"
input:		.word 1234,5678,10345
inputsize=	* - input

start:		ldx i
		lda input,x
		sta params+P::PutInt::int
		lda input+1,x
		sta params+P::PutInt::int+1
		jsr putint
		ldx i
		inx
		inx
		stx i
		cpx #inputsize
		beq :+
		lda #','
		jsr putchar
		jmp start
		
:		rts

update:		rts

