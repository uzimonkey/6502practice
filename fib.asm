;Print the first 10 fibonacci numbers
.macro PARAMS
.endmacro

.macro VARS _
;  name			bytes	default value
_ _a,			1, 	0
_ _b,			1,	1
_ _cnt,			1,	0
.endmacro

.macro SPRITES _
;  name			y		sprite	flags		x
.endmacro

.include "common.inc"

.segment	"CODE"
start:		lda _a
		sta P::PutInt::int
		lda #0
		sta P::PutInt::int+1
		jsr putint
		jsr putnewline

:		lda _b
		sta P::PutInt::int
		lda #0
		sta P::PutInt::int+1
		jsr putint
		jsr putnewline

		ldx _cnt
		inx
		cpx #10
		beq :+
		stx _cnt

		lda _b
		tax			;save copy in x
		clc
		adc _a
		sta _b
		stx _a
		jmp :-

:		rts

update:		rts
