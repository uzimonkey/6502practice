;vim: ts=8,sw=8
;https://www.codewars.com/kata/56f6ad906b88de513f000d96
;
;It's bonus time in the big city! The fatcats are rubbing their paws in
;anticipation... but who is going to make the most money?
;
;Build a function that takes in two arguments (salary, bonus). Salary will be an
;integer, and bonus a boolean.
;
;If bonus is true, the salary should be multiplied by 3. If bonus is false, the
;fatcat did not make enough money and must receive only his stated salary.

.define		BONUS_MIN	1000
.define		BONUS_MULT	4

.macro PARAMS
.struct Bonus
	salary		.word
	adjusted	.word
	_mult		.byte
.endstruct
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
input:		.word 500, 999, 1000, 1001, 4000
;input:		.word 4000
inputsize=	* - input

.segment	"ZEROPAGE"

.segment	"CODE"
adjust_salary:	
@salary=	params+P::Bonus::salary
@adjusted=	params+P::Bonus::adjusted
@_mult=		params+P::Bonus::_mult

		;no bonus if salary < BONUS_MIN
		lda @salary+1
		cmp #>BONUS_MIN
		beq :+
		bcs @bonus
		bcc @nobonus
:		lda @salary
		cmp #<BONUS_MIN
		bcc @nobonus

@bonus:		lda #BONUS_MULT	;multiply salary by BONUS_MULT
		sta @_mult
		lda #0
		sta @adjusted
		sta @adjusted+1

		ldx #8
@loop:		lda @_mult
		beq @done
		lsr a
		sta @_mult
		bcc :+
		lda @adjusted
		clc
		adc @salary
		sta @adjusted
		lda @adjusted+1
		adc @salary+1
		sta @adjusted+1
:		asl @salary
		rol @salary+1
		dex
		bne @loop
@done:		rts

@nobonus:	lda @salary
		ldx @salary+1
		sta @adjusted
		stx @adjusted+1
		rts

start:		ldy i

		lda input,y
		sta params+P::PutInt::int
		lda input+1,y
		sta params+P::PutInt::int+1
		jsr putint

		lda #' '
		jsr putchar

		inc i
		inc i
		lda i
		cmp #inputsize
		bne start
		jsr putnewline

		lda #0
		sta i
:		ldy i
		lda input,y
		sta params+P::Bonus::salary
		lda input+1,y
		sta params+P::Bonus::salary+1
		jsr adjust_salary

		ldx params+P::Bonus::adjusted
		lda params+P::Bonus::adjusted+1
		stx params+P::PutInt::int
		sta params+P::PutInt::int+1
		jsr putint

		lda #' '
		jsr putchar

		inc i
		inc i
		lda i
		cmp #inputsize
		bne :-
		jsr putnewline

		rts

update:		rts

