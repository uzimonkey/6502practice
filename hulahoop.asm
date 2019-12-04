;vim: ts=8,sw=8
;https://www.codewars.com/kata/55cb632c1a5d7b3ad0000145
;
;Alex just got a new hula hoop, he loves it but feels discouraged because his
;little brother is better than him
;
;Write a program where Alex can input (n) how many times the hoop goes round and
;it will return him an encouraging message :)
;
;-If Alex gets 10 or more hoops, return the string "Great, now move on to
;tricks".
;
;-If he doesn't get 10 hoops, return the string "Keep at it until you get it".
.macro PARAMS
.endmacro

.macro VARS _
.endmacro

.macro SPRITES _
.endmacro

.include "common.inc"

.define		HOOPS		11

.segment	"CODE"
moveon:		.asciiz "Great, now move on to tricks"
keepat:		.asciiz "Keep at it until you get it"

start:		lda #HOOPS
		cmp #10
		bcc :+

		lda #<moveon
		sta P::PutZString::zstring
		lda #>moveon
		sta P::PutZString::zstring+1
		jmp :++

:		lda #<keepat
		sta P::PutZString::zstring
		lda #>keepat
		sta P::PutZString::zstring+1

:		jsr putzstring
		rts

update:		rts

