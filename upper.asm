;Convert a string to upper-case using a lookup table
;The lookup table is 1 byte per 8 characters, for a total of 16 bytes
;A generic function can be used to index this lookup table, so other tables
;for things liks islower, isprint, isspace, etc can be used.
.macro PARAMS
.endmacro

.macro VARS _
;  name			bytes	default value
_ tab, 			2, 	0
_ tabchar,		1,	0
_ current_table,	1,	0
.endmacro

.macro SPRITES _
;  name			y		sprite	flags		x
.endmacro

.include "common.inc"

.segment	"CODE"
;                                                               !"#$%&'  ()*+,-./  01234567  89:;<=>?  @ABCDEFG  HIJKLMNO  PQRSTUVW  XYZ[\]^_  `abcdefg  hijklmno  pqrstuvw  xyz{|}~
isalnum_tab:	.byte %00000000,%00000000,%00000000,%00000000,%00000000,%00000000,%11111111,%11000000,%01111111,%11111111,%11111111,%11100000,%01111111,%11111111,%11111111,%11100000
isalpha_tab:	.byte %00000000,%00000000,%00000000,%00000000,%00000000,%00000000,%00000000,%00000000,%01111111,%11111111,%11111111,%11100000,%01111111,%11111111,%11111111,%11100000
isdigit_tab:	.byte %00000000,%00000000,%00000000,%00000000,%00000000,%00000000,%01111111,%11000000,%00000000,%00000000,%00000000,%00000000,%00000000,%00000000,%00000000,%00000000
isupper_tab:	.byte %00000000,%00000000,%00000000,%00000000,%00000000,%00000000,%00000000,%00000000,%01111111,%11111111,%11111111,%11100000,%00000000,%00000000,%00000000,%00000000
islower_tab:	.byte %00000000,%00000000,%00000000,%00000000,%00000000,%00000000,%00000000,%00000000,%00000000,%00000000,%00000000,%00000000,%01111111,%11111111,%11111111,%11100000
isgraph_tab:	.byte %00000000,%00000000,%00000000,%00000000,%01111111,%11111111,%11111111,%11111111,%01111111,%11111111,%11111111,%11111111,%11111111,%11111111,%11111111,%11111111
isprint_tab:	.byte %00000000,%00000000,%00000000,%00000000,%11111111,%11111111,%11111111,%11111111,%01111111,%11111111,%11111111,%11111111,%11111111,%11111111,%11111111,%11111111
isspace_tab:    .byte %00000000,%01111111,%11111111,%11111111,%10000000,%00000000,%00000000,%00000000,%00000000,%00000000,%00000000,%00000000,%00000000,%00000000,%00000000,%00000000

tablook:	lda tabchar		;get upper 5 bits of tabchar shifted down
		tax			;stash in x temporarily
		lsr
		lsr
		lsr
		tay			;store upper 5 bits in y for indexing

		txa			;unstash tabchar from x
		and #$03		;get lower 3 bits of tabchar
		tax			;put in x for counter

		lda (tab),y		;get table byte
		inx
:		rol			;put bit in carry
		dex
		bne :-			;go X times
		lda #0
		rol			;put bit in a
		rts


.segment	"CODE"
input:		.asciiz "This Is A String With Uppercase"
inputlen=	*-input
tables:		.word isupper_tab, islower_tab, isgraph_tab, isspace_tab, $0000

.segment	"ZEROPAGE"
output:		.res inputlen


.segment	"CODE"
start:		lda #<input		;print original string
		sta P::PutZString::zstring
		lda #>input
		sta P::PutZString::zstring+1
		jsr putzstring
		jsr putnewline

		lda #0			;start at table 0
		sta current_table

@tabloop:	ldx current_table	;select table
		lda tables,x
		sta tab
		lda tables+1,x
		sta tab+1
		txa			;increment table pointer
		clc
		adc #2
		sta current_table

		ldx #$ff		;transform string
@loop:		inx
		lda input,x
		sta tabchar

		txa			;preserve x
		pha

		jsr tablook
		tay			;put result in y

		pla			;restore x
		tax

		lda input,x		;get string char again
		dey			;result to zero flag
		bne :+
		lda #1
:		sta output,x
		cmp #0
		bne @loop

		lda #<output		;output result
		sta P::PutZString::zstring
		lda #>output
		sta P::PutZString::zstring+1
		jsr putzstring
		jsr putnewline

		ldx current_table
		lda tables,x		;end of table list marker?
		clc
		adc tables+1,x
		bne @tabloop

		rts

update:		rts
