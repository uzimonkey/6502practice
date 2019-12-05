;Find the third angle of a triangle given the first two.
;I'll try passing parameters on the stack this time
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
thirdangle:
@first=		$0100+3
@second=	$0100+4

		tsx			;set ups stack frame
		lda #180
		sec
		sbc @first,x
		sbc @second,x
		rts

start:		lda #60
		pha
		pha
		jsr thirdangle
		tsx
		inx
		inx
		txs

		sta P::PutInt::int
		lda #0
		sta P::PutInt::int+1
		jsr putint

		rts

update:		rts
