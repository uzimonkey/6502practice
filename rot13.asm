;vim: ts=8,sw=8
.macro PARAMS
.endmacro

.macro VARS _
;  name			bytes	default value
.endmacro

.macro SPRITES _
;  name			y		sprite	flags		x
.endmacro

.include "common.inc"

.segment	"CODE"
input:		.byte "Hello, NES! ",$01,$02,$00
inputsize=	* - input

.segment	"ZEROPAGE"
output:		.res inputsize

.segment	"CODE"
start:		lda #<input
		sta params+P::PutZString::zstring
		lda #>input
		sta params+P::PutZString::zstring+1
		jsr putzstring
		jsr putnewline

		ldx #0
@loop:		lda input,x		;save the case bit on the stack
		tay
		rol
		rol
		rol
		php

		tya			;use caseless letter
		and #$DF

		cmp #'Z'+1
		bcs @output		;A > 'Z'
		cmp #'A'
		bcc @output		;A < 'A'

		clc			;do shift
		adc #13
		cmp #'Z'+1
		bcc @output
		sbc #26

@output:	plp			;restore status, has case bit
		bcc :+
		ora #$20		;restore case bit
:		sta output,x
		cmp #0
		beq :+
		inx
		jmp @loop

:		lda #<output
		sta params+P::PutZString::zstring
		lda #>output
		sta params+P::PutZString::zstring+1
		jsr putzstring

		jsr putnewline
		rts

update:		rts
