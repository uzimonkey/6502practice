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
input:		.byte 5, 10, 55, 88, 128, 0

start:		lda #$ff
		sta i

@loop: 		ldx i
		inx
		stx i
		lda input,x
		beq @done

		tay
		lda #0			;end marker
		pha
		tya

:		tay
		and #$07
		clc
		adc #'0'
		pha
		tya
		lsr
		lsr
		lsr
		bne :-

:		pla
		beq :+
		jsr putchar
		jmp :-
:		jsr putnewline
		jmp @loop

@done:		rts

update:		rts
