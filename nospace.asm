.macro PARAMS
.struct NoSpace
	str	.word
	_rd	.byte
	_wr	.byte
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
input:		.asciiz "Remove spaces from this string"
inputlen=	*-input

.segment	"ZEROPAGE"
output:		.res inputlen

.segment	"CODE"
nospace:
@str=		P::NoSpace::str
@rd=		P::NoSpace::_rd
@wr=		P::NoSpace::_wr

		lda #0			;start both cursors at beginning
		sta @rd
		sta @wr

:		ldy @rd
		lda (@str),y
		iny
		sty @rd
		cmp #' '
		beq :+
		ldy @wr
		sta (@str),y
		iny
		sty @wr
:		cmp #0
		bne :--

		rts


start:		ldx #0
:		lda input,x
		sta output,x
		inx
		cmp #inputlen
		bne :-

		lda #<output
		sta P::PutZString::zstring
		lda #>output
		sta P::PutZString::zstring+1
		jsr putzstring
		jsr putnewline

		lda #<output
		sta P::NoSpace::str
		lda #>output
		sta P::NoSpace::str+1
		jsr nospace

		lda #<output
		sta P::PutZString::zstring
		lda #>output
		sta P::PutZString::zstring+1
		jsr putzstring
		
		rts

update:		rts
