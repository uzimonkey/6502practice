.macro PARAMS
.struct Str2Int
	int	.word
	str	.word
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

str2int:
@int=		P::Str2Int::int
@str=		P::Str2Int::str

		lda #0			;initialize
		sta @int
		sta @int+1

		ldy #0			;scan to end of string
:		lda (@str),y
		beq :+
		iny
		jmp :-
:		dey

		ldx #0			;first magnitude
@loop:		tya			;save y
		pha

		lda (@str),y		;get number in this column
		sec
		sbc #'0'
		tay

:		lda @int		;add the magnitude
		clc
		adc @mags,x
		sta @int
		lda @int+1
		adc @mags+1,x
		sta @int+1
		dey
		bne :-

		pla			;restore y
		tay
		beq :+			;don't go past the beginning of string
		dey			;next digit
		inx			;next magnitude
		inx
		cpx @nummags
		bne @loop
:		rts

@mags:		.word 1, 10, 100, 1000, 10000
@nummags=	*-@mags

start:		lda #<@input
		clc
		adc i
		sta P::PutZString::zstring
		lda #>@input
		adc #0
		sta P::PutZString::zstring+1
		jsr putzstring
		lda #' '
		jsr putchar

		lda #<@input
		clc
		adc i
		sta P::Str2Int::str
		lda #>@input
		adc #0
		sta P::Str2Int::str+1
		jsr str2int
		jsr putint
		jsr putnewline

		ldx i
:		lda @input,x
		beq :+
		inx
		jmp :-
:		inx
		stx i
		lda @input,x
		bne start
		
		rts
@input:		.byte "1",0,"15",0,"582",0,"1337",0,"9876",0,"31337",0,0

update:		rts
