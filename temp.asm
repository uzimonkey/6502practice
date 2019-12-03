;vim: ts=8,sw=8
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
message:	.byte "Hello, world! ",$01,$00

start:		lda #<message
		sta params+P::PutZString::zstring
		lda #>message
		sta params+P::PutZString::zstring+1
		jsr putzstring
		
		rts

update:		rts

