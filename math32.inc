.include	"regs.inc"
.segment	"CODE"
i32add:		;c=a+b
@a=		r0
@b=		r4
@c=		r8
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
@a=		r0
@b=		r4
@c=		r8
		ldy #4		;perform 4 subs
		sec
:		inx
		lda @a,x
		sbc @b,x
		sta @c,x
		dey
		bne :-
		rts


i32muli8:	;c=a*b
@a=		r0
@b=		r4
@c=		r5
		lda #0		;initialize @c
		sta @c
		sta @c+1
		sta @c+2
		sta @c+3
@loop:		lsr @b		;perform multiply
		bcc @noadd
		ldx #0		;32-bit add
		ldy #4
		clc
:		lda @c,x
		adc @a,x
		sta @c,x
		inx
		dey
		bne :-
@noadd:		lda @b		;done if no bits in b
		beq @done
		asl @a		;left shift @a
		rol @a+1
		rol @a+2
		rol @a+3
		jmp @loop
@done:		rts


str2i32:
@str=		r13		;do not clash with i32muli8 or i32add
@mag=		r15		;same as i32muli8 result
@res=		r19		;result
@i=		r23		;string iterator
		lda #1		;initialize @mag, @res and @i
		sta @mag
		lda #0
		ldx #9
:		sta @mag,x	;x will never be 1
		dex
		bne :-
		ldy #$ff	;seek to end of string
:		iny
		lda (@str),y
		bne :-
		cpy #0		;zero length string?
		beq @done
		dey		;back off the nul
		sty @i
@loop:		lda (@str),y	;get digit
		sec
		sbc #'0'
		sta r4		;multiply @mag by digit
		ldx #3
:		lda @mag,x
		sta r0,x
		dex
		bpl :-
		jsr i32muli8	;r5=@mul*digit
		ldx #0
		ldy #4
		clc
:		lda @res,x	;@res+=r5
		adc r5,x
		sta @res,x
		inx
		dey
		bne :-
		dec @i		;next digit
		bmi @done	;done at end of string
		ldx #3		;r0=@mag
:		lda @mag,x
		sta r0,x
		dex
		bpl :-
		lda #10		;r4=10
		sta r4
		jsr i32muli8	;r5=@mag*10
		ldx #3		;@mag=r5
:		lda r5,x
		sta @mag,x
		dex
		bpl :-
		ldy @i
		jmp @loop	;next digit
@done:		rts