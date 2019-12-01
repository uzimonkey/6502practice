;vim: ts=8,sw=8
.include "common.inc"

.union Params
.endunion

.macro VARS _
;  name			bytes	default value
.endmacro

.macro SPRITES _
;  name			y		sprite	flags		x
.endmacro

.segment	"STARTUP"

.segment	"ZEROPAGE"
VARS ZPAGE_DEFINITIONS
params:		.tag Params

.segment	"CODE"
zpagedefaults:
VARS ZPAGE_DEFAULTS
zpagedefaultslen = * - zpagedefaults

spritedata:	
SPRITES SPRITEDATA
spritedatalen = * - spritedata



.segment	"CODE"
start:
		rts

update:		rts
