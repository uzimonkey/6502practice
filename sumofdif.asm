;vim: ts=8,sw=8
;https://www.codewars.com/kata/5b73fe9fb3d9776fbf00009e
;Your task is to sum the differences between consecutive pairs in the array in
;descending order.
;
;For example: sumOfDifferences([2, 1, 10]) Returns 9
;
;Descending order: [10, 2, 1]
;
;Sum: (10 - 2) + (2 - 1) = 8 + 1 = 9
.macro PARAMS
.struct Bubble
	in	.word
	len	.byte
.endstruct
.struct SumOfDiff
	in	.word
	len	.byte
	result	.word
	_tmp	.byte
.endstruct
.endmacro

.macro VARS _
;  name			bytes	default value
.endmacro

.macro SPRITES _
.endmacro

.include "common.inc"

.segment	"CODE"
input:		.byte 2,1,10
inputsize=	*-input

.segment	"ZEROPAGE"
output:		.res inputsize

.segment	"CODE"
sumofdiff:
@in=		P::SumOfDiff::in
@len=		P::SumOfDiff::len
@result=	P::SumOfDiff::result
@_tmp=		P::SumOfDiff::_tmp

		lda #0
		sta @result
		sta @result+1

		ldy @len
		dey
:		lda (@in),y		;get number
		dey
		sec
		sbc (@in),y		;subtract
		sta @_tmp
		lda @result
		clc
		adc @_tmp
		sta @result
		lda @result+1
		adc #0
		sta @result+1
		cpy #0
		bne :-

		rts


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

		lda #<output		;bubble sort
		sta P::Bubble::in
		lda #>output
		sta P::Bubble::in+1
		lda #inputsize
		sta P::Bubble::len
		jsr bubblesort

		lda #<output		;sum of diff
		sta P::SumOfDiff::in
		lda #>output
		sta P::SumOfDiff::in+1
		lda #inputsize
		sta P::SumOfDiff::len
		jsr sumofdiff

		lda P::SumOfDiff::result
		ldx P::SumOfDiff::result+1
		sta P::PutInt::int
		stx P::PutInt::int+1

		jsr putint

		rts

update:		rts


