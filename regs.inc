.ifndef REGS_INC_INCLUDED
REGS_INC_INCLUDED=1

;Some virtual registers in the zero page
;These are shared by everyone, functions are all
;assumed to mangle these, just like A, X and Y.
.define		NUM_REGS	24
.segment	"ZEROPAGE"
.repeat		NUM_REGS, i
.ident(.concat("r", .string(i))): .res 1
.endrepeat

.endif