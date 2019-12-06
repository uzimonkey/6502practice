.segment	"CODE"

i32add:		;c=a+b
.struct _i32add
	_a	.dword
	_b	.dword
	_c	.dword
.endstruct
@a=		$0100+_i32add::_a+2
@b=		$0100+_i32add::_b+2
@c=		$0100+_i32add::_c+2
		tsx		;get stack frame
		ldy #4		;perform 4 adds
		clc
:		inx
		lda @a,x
		adc @b,x
		sta @c,x
		dey
		bne :-
		rts

i32sub:		;c=a-b
.struct _i32sub
	_a	.dword
	_b	.dword
	_c	.dword
.endstruct
@a=		$0100+_i32sub::_a+2
@b=		$0100+_i32sub::_b+2
@c=		$0100+_i32sub::_c+2
		tsx		;get stack frame
		ldy #4		;perform 4 subs
		sec
:		inx
		lda @a,x
		sbc @b,x
		sta @c,x
		dey
		bne :-
		rts