;vim: ts=8,sw=8
.include	"nes.inc"
.define		INESPRGROMS		2
.define		INESCHRROMS		1
.define		INESCTRL1		0
.define		INESCTRL2		0
.include	"ines.inc"

.define		OAM_MIRROR		$0200

.segment	"STARTUP"

.segment	"OAM"

.segment	"ZEROPAGE"
joy1:		.res 1
joy2:		.res 1
cursor:		.res 2
zstring:	.res 2

.segment	"CODE"
reset:		sei
		cld

		ldx #$ff		;set up stack
		txs

		inx			;x=0
		stx PPUCTRL1
		stx PPUCTRL2
		stx APUCTRL

		VSYNC
		VSYNC

		ldx #0			;initialize OAM mirror
:		lda spritedata,x
		sta OAM_MIRROR,x
		inx
		cpx #spritedatalen
		bne :-
		lda #$ff		;set unused sprites to ff
:		sta OAM_MIRROR,x
		inx
		bne :-

		ldx #zpagedefaultslen	;initialize zpage
:		lda zpagedefaults,x
		sta $0000,x
		dex
		bpl :-

		lda #$00
		sta joy1
		sta joy2
		lda #$20		;second line
		sta cursor
		sta cursor+1

		VSYNC

		lda #>PPUVRAM_PALETTE	;initialize palette
		sta PPUVRAMADDR2
		lda #<PPUVRAM_PALETTE
		sta PPUVRAMADDR2

		ldx #0
:		lda palette,x
		sta PPUVRAMIO
		inx
		cpx #palettelen
		bne :-

		lda #PPUCTRL1_NMI	;enable interrupts and drawing
		sta PPUCTRL1
		lda #(PPUCTRL2_SPRVIS|PPUCTRL2_BACKVIS)
		sta PPUCTRL2

		ldx #0			;scroll to top left
		stx PPUVRAMADDR1
		stx PPUVRAMADDR1

		jsr start

		cli
		HANG

nmi:		;copy OAM_MIRROR to OAM
		lda #>OAM_MIRROR
		sta PPUSPRITEDMA
		nop

		;read joystick
		ldx #0
		jsr read_joy

		jsr update

		rti

irq:		rti


;params: x=joy to read
read_joy:	ldy #1			;strobe controller
		sty APUJOY1
		dey
		sty APUJOY1
		ldy #8			;read 8 bits
:		lda APUJOY1,x		;read a bit
		ror a
		ror joy1,x
		dey
		bne :-
		rts

;params: a=char, mangles x
putchar:	ldx #0			;disable rendering
		stx PPUCTRL2

		ldx cursor+1		;put char
		stx PPUVRAMADDR2
		ldx cursor
		stx PPUVRAMADDR2
		sta PPUVRAMIO

		txa
		clc			;increment cursor
		adc #1
		sta cursor
		lda cursor+1
		adc #0
		sta cursor+1

		ldx #0			;reset scrolling
		stx PPUVRAMADDR1
		stx PPUVRAMADDR1

		ldx #$1e		;enable rendering
		stx PPUCTRL2

		rts

;params: a=int
putint:		tax

		cpx #100
		bcc @tens

		ldy #0			;count hundreds
:		sec
		sbc #100
		bcc :+
		iny
		jmp :-
:		clc
		adc #100

		pha			;put hundreds
		txa
		pha
		tya
		clc
		adc #'0'
		jsr putchar
		pla
		tax
		pla

@tens:		cpx #10
		bcc @ones
		ldy #0			;count tens
:		sec
		sbc #10
		bcc :+
		iny
		jmp :-
:		clc
		adc #10

		pha			;put tens
		txa
		pha
		tya
		clc
		adc #'0'
		jsr putchar
		pla
		tax
		pla

@ones:		clc			;put ones
		adc #'0'
		jsr putchar

		rts

;params: a=int
puthex:		tay

		lda #'$'
		jsr putchar

		tya
		lsr
		lsr
		lsr
		lsr
		and #$0f
		jsr @print

		tya
		and #$0f
		jsr @print

		rts

@print:		cmp #10
		bcs :+
		clc
		adc #'0'
		jmp :++
:		clc
		adc #('A'-10)
:		jsr putchar
		rts

;params: zstring
putzstring:	ldy #0
:		lda (zstring),y
		beq :+
		jsr putchar
		iny
		jmp :-
:		rts

putnewline:	lda cursor
		and #$e0
		clc
		adc #$20
		sta cursor
		lda cursor+1
		adc #0
		sta cursor+1
		rts



palette:
.incbin		"font.dat", $0, $20
palettelen	= * - palette

.segment	"VECTORS"
.addr		nmi
.addr		reset
.addr		irq

.segment	"TILES"
.incbin		"font.chr"
