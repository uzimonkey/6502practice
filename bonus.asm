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

.define		BONUS_MIN	30

.union Params
.struct Bonus
	salary		.byte
	bonus		.byte
	adjusted	.byte
.endstruct
.endunion

.macro VARS _
;  name			bytes	default value
_ i,			1,	0
.endmacro

.macro SPRITES _
;  name			y		sprite	flags		x
.endmacro

.include "common.inc"

.segment	"CODE"
input:		.byte 10, 20, 30, 40
inputsize=	* - input

.segment	"ZEROPAGE"

.segment	"CODE"
adjust_salary:	lda params+Params::Bonus::bonus
		bne :+		;return original if no bonus
		lda params+Params::Bonus::salary
		sta params+Params::Bonus::adjusted
		rts

:		lda #3		;multiply salary by 3
		sta params+Params::Bonus::bonus
		lda #0
		sta params+Params::Bonus::adjusted
		ldx #8
@mult:		lsr params+Params::Bonus::bonus
		bcc :+
		lda params+Params::Bonus::adjusted
		clc
		adc params+Params::Bonus::salary
		sta params+Params::Bonus::adjusted
:		asl params+Params::Bonus::salary
		dex
		bne @mult
		rts

start:		lda #0
		sta i
:		ldy i
		lda input,y
		jsr putint
		lda #' '
		jsr putchar
		inc i
		lda i
		cmp #inputsize
		bne :-
		jsr putnewline


		lda #0
		sta i
:		ldy i
		lda input,y
		sta params+Params::Bonus::salary
		cmp #BONUS_MIN
		lda #0
		rol
		sta params+Params::Bonus::bonus
		jsr adjust_salary
		lda params+Params::Bonus::adjusted
		jsr putint
		lda #' '
		jsr putchar
		inc i
		lda i
		cmp #inputsize
		bne :-
		jsr putnewline

		rts

update:		rts

