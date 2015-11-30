;
; MD201511
;

; Code by T.M.R/Cosine
; Music by T.L.F./Cosine


; Select an output filename
		!to "md201511.prg",cbm


; Yank in binary data
		* = $1000
		!binary "data/no_more.prg",,2

		* = $4000
		!binary "data/7px.chr"

		* = $4800
		!binary "data/sprites.spr"


; Constants: raster split positions
rstr1p		= $20
rstr2p		= $8b


; Label assignments
rn		= $50

cos_at_1	= $58
cos_speed_1	= $01		; constant
cos_offset_1	= $0b		; constant

cos_at_2	= $59
cos_speed_2	= $02		; constant

char_cnt	= $60
char_buffer	= $60

; Add a BASIC startline
		* = $0801
		!word entry-2
		!byte $00,$00,$9e
		!text "2066"
		!byte $00,$00,$00


; Entry point at $0812
		* = $0812
entry		sei

		lda #$01
		sta rn

		lda #<nmi
		sta $fffa
		lda #>nmi
		sta $fffb

		lda #<int
		sta $fffe
		lda #>int
		sta $ffff

		lda #$7f
		sta $dc0d
		sta $dd0d

		lda $dc0d
		lda $dd0d

		lda #rstr1p
		sta $d012

		lda #$1b
		sta $d011
		lda #$01
		sta $d019
		sta $d01a

		lda #$35
		sta $01

; Screen clear/colour set
		ldx #$00
		txa
nuke_screen	sta $4c00,x
		sta $4d00,x
		sta $4e00,x
		sta $4ee8,x
		sta $d800,x
		sta $d900,x
		sta $da00,x
		sta $dae8,x
		inx
		bne nuke_screen

; Generate the starfield
		ldx #$00
starfid_make	txa
		and #$1f
		ora #$40
		sta $4c00,x
		clc
		adc #$07
		and #$1f
		ora #$40
		sta $4c28,x
		clc
		adc #$13
		and #$1f
		ora #$40
		sta $4c50,x
		clc
		adc #$03
		and #$1f
		ora #$40
		sta $4c78,x

		clc
		adc #$16
		and #$1f
		ora #$40
		sta $4ca0,x
		clc
		adc #$0c
		and #$1f
		ora #$40
		sta $4cc8,x
		clc
		adc #$16
		and #$1f
		ora #$40
		sta $4cf0,x
		clc
		adc #$12
		and #$1f
		ora #$40
		sta $4d18,x

		clc
		adc #$09
		and #$1f
		ora #$40
		sta $4d40,x
		clc
		adc #$14
		and #$1f
		ora #$40
		sta $4d68,x
		clc
		adc #$07
		and #$1f
		ora #$40
		sta $4d90,x
		clc
		adc #$12
		and #$1f
		ora #$40
		sta $4db8,x

		clc
		adc #$13
		and #$1f
		ora #$40
		sta $4e08,x
		clc
		adc #$13
		and #$1f
		ora #$40
		sta $4e30,x
		clc
		adc #$12
		and #$1f
		ora #$40
		sta $4e58,x
		clc
		adc #$07
		and #$1f
		ora #$40
		sta $4e80,x

		clc
		adc #$14
		and #$1f
		ora #$40
		sta $4ea8,x
		clc
		adc #$09
		and #$1f
		ora #$40
		sta $4ed0,x
		clc
		adc #$12
		and #$1f
		ora #$40
		sta $4ef8,x
		clc
		adc #$16
		and #$1f
		ora #$40
		sta $4f20,x

		clc
		adc #$0c
		and #$1f
		ora #$40
		sta $4f48,x
		clc
		adc #$06
		and #$1f
		ora #$40
		sta $4f70,x
		clc
		adc #$13
		and #$1f
		ora #$40
		sta $4f98,x
		clc
		adc #$10
		and #$1f
		ora #$40
		sta $4fc0,x

		inx
		cpx #$28
		beq *+$05
		jmp starfid_make

		ldx #$01
		ldy #$00
starfld_col_mk	lda star_pulse+$08,y
		sta $d800,x
		lda star_pulse+$15,y
		sta $d828,x
		lda star_pulse+$0d,y
		sta $d850,x
		lda star_pulse+$1d,y
		sta $d878,x

		lda star_pulse+$26,y
		sta $d8a0,x
		lda star_pulse+$05,y
		sta $d8c8,x
		lda star_pulse+$10,y
		sta $d8f0,x
		lda star_pulse+$07,y
		sta $d918,x

		lda star_pulse+$13,y
		sta $d940,x
		lda star_pulse+$29,y
		sta $d968,x
		lda star_pulse+$05,y
		sta $d990,x
		lda star_pulse+$03,y
		sta $d9b8,x

		lda star_pulse+$15,y
		sta $da08,x
		lda star_pulse+$08,y
		sta $da30,x
		lda star_pulse+$15,y
		sta $da58,x

		lda star_pulse+$26,y
		sta $da80,x
		lda star_pulse+$28,y
		sta $daa8,x
		lda star_pulse+$1a,y
		sta $dad0,x
		lda star_pulse+$03,y
		sta $daf8,x

		lda star_pulse+$14,y
		sta $db20,x
		lda star_pulse+$11,y
		sta $db48,x
		lda star_pulse+$25,y
		sta $db70,x
		lda star_pulse+$00,y
		sta $db98,x

		lda star_pulse+$1c,y
		sta $dbc0,x

		tya
		clc
		adc #$01
		and #$1f
		tay
		inx
		cpx #$28
		beq *+$05
		jmp starfld_col_mk

; Plonk the scroller into place
		ldx #$00
set_centre_line	lda scroll_line,x
		sta $4de0,x
		lda scroll_col_line,x
		sta $d9e0,x
		inx
		cpx #$28
		bne set_centre_line

; Clear the scroller's buffer and reset it
		ldx #$00
		txa
clear_buffer	sta char_buffer,x
		inx
		cpx #$08
		bne clear_buffer

		jsr reset

		lda #$00
		sta cos_at_1
		sta cos_at_2

; Init the music
		lda #$00
		jsr $1000

		cli

; Infinite loop
		jmp *


; IRQ interrupt handler
int		pha
		txa
		pha
		tya
		pha

		lda $d019
		and #$01
		sta $d019
		bne ya
		jmp ea31

; An interrupt has triggered
ya		lda rn
		cmp #$02
		bne *+$05
		jmp rout2


; Raster split 1
rout1		lda #$02
		sta rn
		lda #rstr2p
		sta $d012

		lda #$00
		sta $d020
		sta $d021

		lda #$c6
		sta $dd00

		lda #$08
		sta $d016
		lda #$30
		sta $d018

		lda #$ff
		sta $d015

		ldx #$00
		ldy #$00
set_sprites_1	lda sprite_x_pos_1,x
		sta $d000,y
		lda sprite_y_pos_1,x
		sta $d001,y
		lda sprite_cols_1,x
		sta $d027,x
		lda sprite_dps,x
		sta $4ff8,x
		iny
		iny
		inx
		cpx #$08
		bne set_sprites_1

		lda sprite_x_msb_1
		sta $d010

; Play the music
		jsr $1003

		jmp ea31


		* = $2000

; Raster split 2
rout2		ldx #$05
		dex
		bne *-$01
		nop
		nop
		nop
		lda $d012
		cmp #rstr2p+$01
		beq *+$02
;		sta $d020

		ldx #$0a
		dex
		bne *-$01
		nop
		nop
		lda $d012
		cmp #rstr2p+$02
		beq *+$02
;		sta $d020

		ldx #$0a
		dex
		bne *-$01
		bit $ea
		lda $d012
		cmp #rstr2p+$03
		beq *+$02
;		sta $d020

		ldx #$0a
		dex
		bne *-$01
		nop
		nop
		lda $d012
		cmp #rstr2p+$04
		beq *+$02
;		sta $d020

		ldx #$0a
		dex
		bne *-$01
		nop
		nop
		lda $d012
		cmp #rstr2p+$05
		beq *+$02
;		sta $d020

		ldx #$0a
		dex
		bne *-$01
		bit $ea
		lda $d012
		cmp #rstr2p+$06
		beq *+$02
;		sta $d020


		ldx #$0f
		dex
		bne *-$01
		bit $ea
		nop
		nop
		nop
		nop

; Scroll splitter - scanline 1
sc_split_00_a	lda #$00
		sta $d016
sc_split_00_b	lda #$00
		sta $d016
sc_split_00_c	lda #$00
		sta $d016
sc_split_00_d	lda #$00
		sta $d016
sc_split_00_e	lda #$00
		sta $d016
sc_split_00_f	lda #$00
		sta $d016
sc_split_00_g	lda #$00
		sta $d016

		bit $ea
		nop
		nop
		nop
		lda #$09
		sta $d021
		nop
		nop
		nop

; Scroll splitter - scanline 2
sc_split_01_a	lda #$00
		sta $d016
sc_split_01_b	lda #$00
		sta $d016
sc_split_01_c	lda #$00
		sta $d016
sc_split_01_d	lda #$00
		sta $d016
sc_split_01_e	lda #$00
		sta $d016
sc_split_01_f	lda #$00
		sta $d016
sc_split_01_g	lda #$00
		sta $d016

		bit $ea
		nop
		nop
		nop
		lda #$02
		sta $d021
		nop
		nop
		nop

; Scroll splitter - scanline 3
sc_split_02_a	lda #$00
		sta $d016
sc_split_02_b	lda #$00
		sta $d016
sc_split_02_c	lda #$00
		sta $d016
sc_split_02_d	lda #$00
		sta $d016
sc_split_02_e	lda #$00
		sta $d016
sc_split_02_f	lda #$00
		sta $d016
sc_split_02_g	lda #$00
		sta $d016

		bit $ea
		nop
		nop
		nop
		lda #$08
		sta $d021
		nop
		nop
		nop

; Scroll splitter - scanline 4
sc_split_03_a	lda #$00
		sta $d016
sc_split_03_b	lda #$00
		sta $d016
sc_split_03_c	lda #$00
		sta $d016
sc_split_03_d	lda #$00
		sta $d016
sc_split_03_e	lda #$00
		sta $d016
sc_split_03_f	lda #$00
		sta $d016
sc_split_03_g	lda #$00
		sta $d016

		bit $ea
		nop
		nop
		nop
		lda #$0b
		sta $d021
		nop
		nop
		nop

; Scroll splitter - scanline 5
sc_split_04_a	lda #$00
		sta $d016
sc_split_04_b	lda #$00
		sta $d016
sc_split_04_c	lda #$00
		sta $d016
sc_split_04_d	lda #$00
		sta $d016
sc_split_04_e	lda #$00
		sta $d016
sc_split_04_f	lda #$00
		sta $d016
sc_split_04_g	lda #$00
		sta $d016

		bit $ea
		nop
		nop
		nop
		lda #$06
		sta $d021
		nop
		nop
		nop

; Scroll splitter - scanline 6
sc_split_05_a	lda #$00
		sta $d016
sc_split_05_b	lda #$00
		sta $d016
sc_split_05_c	lda #$00
		sta $d016
sc_split_05_d	lda #$00
		sta $d016
sc_split_05_e	lda #$00
		sta $d016
sc_split_05_f	lda #$00
		sta $d016
sc_split_05_g	lda #$00
		sta $d016

		bit $ea
		nop
		nop
		nop
		lda #$00
		sta $d021
		nop
		nop
		nop

; Scroll splitter - scanline 7
sc_split_06_a	lda #$00
		sta $d016
sc_split_06_b	lda #$00
		sta $d016
sc_split_06_c	lda #$00
		sta $d016
sc_split_06_d	lda #$00
		sta $d016
sc_split_06_e	lda #$00
		sta $d016
sc_split_06_f	lda #$00
		sta $d016
sc_split_06_g	lda #$00
		sta $d016

		lda #$08
		sta $d016

; Reposition the sprites
		ldx #$00
		ldy #$00
set_sprites_2	lda sprite_x_pos_2,x
		sta $d000,y
		lda sprite_y_pos_2,x
		sta $d001,y
		lda sprite_cols_2,x
		sta $d027,x
		lda sprite_dps,x
		sta $4ff8,x
		iny
		iny
		inx
		cpx #$08
		bne set_sprites_2

		lda sprite_x_msb_2
		sta $d010

; Update the d016 split positions
		lda cos_at_1
		clc
		adc #cos_speed_1
		and #$3f
		sta cos_at_1
		tay
		tax
		lda d016_cosinus,x
		sta sc_split_00_a+$01
		inx
		inx
		lda d016_cosinus,x
		sta sc_split_01_a+$01
		inx
		inx
		lda d016_cosinus,x
		sta sc_split_02_a+$01
		inx
		inx
		lda d016_cosinus,x
		sta sc_split_03_a+$01
		inx
		inx
		lda d016_cosinus,x
		sta sc_split_04_a+$01
		inx
		inx
		lda d016_cosinus,x
		sta sc_split_05_a+$01
		inx
		inx
		lda d016_cosinus,x
		sta sc_split_06_a+$01

		tya
		clc
		adc #cos_offset_1
		tay
		tax
		lda d016_cosinus,x
		sta sc_split_00_b+$01
		inx
		inx
		lda d016_cosinus,x
		sta sc_split_01_b+$01
		inx
		inx
		lda d016_cosinus,x
		sta sc_split_02_b+$01
		inx
		inx
		lda d016_cosinus,x
		sta sc_split_03_b+$01
		inx
		inx
		lda d016_cosinus,x
		sta sc_split_04_b+$01
		inx
		inx
		lda d016_cosinus,x
		sta sc_split_05_b+$01
		inx
		inx
		lda d016_cosinus,x
		sta sc_split_06_b+$01

		tya
		clc
		adc #cos_offset_1
		tay
		tax
		lda d016_cosinus,x
		sta sc_split_00_c+$01
		inx
		inx
		lda d016_cosinus,x
		sta sc_split_01_c+$01
		inx
		inx
		lda d016_cosinus,x
		sta sc_split_02_c+$01
		inx
		inx
		lda d016_cosinus,x
		sta sc_split_03_c+$01
		inx
		inx
		lda d016_cosinus,x
		sta sc_split_04_c+$01
		inx
		inx
		lda d016_cosinus,x
		sta sc_split_05_c+$01
		inx
		inx
		lda d016_cosinus,x
		sta sc_split_06_c+$01

		tya
		clc
		adc #cos_offset_1
		tay
		tax
		lda d016_cosinus,x
		sta sc_split_00_d+$01
		inx
		inx
		lda d016_cosinus,x
		sta sc_split_01_d+$01
		inx
		inx
		lda d016_cosinus,x
		sta sc_split_02_d+$01
		inx
		inx
		lda d016_cosinus,x
		sta sc_split_03_d+$01
		inx
		inx
		lda d016_cosinus,x
		sta sc_split_04_d+$01
		inx
		inx
		lda d016_cosinus,x
		sta sc_split_05_d+$01
		inx
		inx
		lda d016_cosinus,x
		sta sc_split_06_d+$01

		tya
		clc
		adc #cos_offset_1
		tay
		tax
		lda d016_cosinus,x
		sta sc_split_00_e+$01
		inx
		inx
		lda d016_cosinus,x
		sta sc_split_01_e+$01
		inx
		inx
		lda d016_cosinus,x
		sta sc_split_02_e+$01
		inx
		inx
		lda d016_cosinus,x
		sta sc_split_03_e+$01
		inx
		inx
		lda d016_cosinus,x
		sta sc_split_04_e+$01
		inx
		inx
		lda d016_cosinus,x
		sta sc_split_05_e+$01
		inx
		inx
		lda d016_cosinus,x
		sta sc_split_06_e+$01

		tya
		clc
		adc #cos_offset_1
		tay
		tax
		lda d016_cosinus,x
		sta sc_split_00_f+$01
		inx
		inx
		lda d016_cosinus,x
		sta sc_split_01_f+$01
		inx
		inx
		lda d016_cosinus,x
		sta sc_split_02_f+$01
		inx
		inx
		lda d016_cosinus,x
		sta sc_split_03_f+$01
		inx
		inx
		lda d016_cosinus,x
		sta sc_split_04_f+$01
		inx
		inx
		lda d016_cosinus,x
		sta sc_split_05_f+$01
		inx
		inx
		lda d016_cosinus,x
		sta sc_split_06_f+$01

		tya
		clc
		adc #cos_offset_1
		tay
		tax
		lda d016_cosinus,x
		ora #$08
		sta sc_split_00_g+$01
		inx
		inx
		lda d016_cosinus,x
		ora #$08
		sta sc_split_01_g+$01
		inx
		inx
		lda d016_cosinus,x
		ora #$08
		sta sc_split_02_g+$01
		inx
		inx
		lda d016_cosinus,x
		ora #$08
		sta sc_split_03_g+$01
		inx
		inx
		lda d016_cosinus,x
		ora #$08
		sta sc_split_04_g+$01
		inx
		inx
		lda d016_cosinus,x
		ora #$08
		sta sc_split_05_g+$01
		inx
		inx
		lda d016_cosinus,x
		ora #$08
		sta sc_split_06_g+$01

; Move the scroller (called twice for two pixels per frame)
		jsr scroller
		jsr scroller

; Wait for the bottom border
		lda #$fc
		cmp $d012
		bcc *-$03

; Clear the starfield
		lda #$00
!set star_cnt=$00
!do {
		ldx star_x_pos+star_cnt
		sta $4200,x

		!set star_cnt=star_cnt+$01
} until star_cnt=$06

; Update the starfield
!set star_cnt=$00
!do {
		lda star_x_fine+star_cnt
		clc
		adc star_x_speed+star_cnt
		cmp #$10
		bcc *+$0f
		tax
		lda star_x_pos+star_cnt
		sec
		sbc #$08
		sta star_x_pos+star_cnt
		txa
		and #$0f
		sta star_x_fine+star_cnt

		!set star_cnt=star_cnt+$01
} until star_cnt=$06

; Plot the starfield
!set star_cnt=$00
!do {
		ldx star_x_pos+star_cnt
		lda star_x_fine+star_cnt
		lsr
		tay
		lda $4200,x
		ora star_decode,y
		sta $4200,x

		!set star_cnt=star_cnt+$01
} until star_cnt=$06

; Update the sprite positions - upper sprites
		lda #$00
		sta sprite_x_msb_1

		lda cos_at_2
		clc
		adc #cos_speed_2
		sta cos_at_2
		tax
		lda sprite_cosinus,x
		sta sprite_x_pos_1+$00
		sta sprite_x_pos_1+$03
		sta sprite_x_pos_1+$05
		clc
		adc #$18
		sta sprite_x_pos_1+$01
		sta sprite_x_pos_1+$06
		cmp #$40
		bcs spr_msb_skip_1
		ldy #$42
		sty sprite_x_msb_1
spr_msb_skip_1	clc
		adc #$18
		sta sprite_x_pos_1+$02
		sta sprite_x_pos_1+$04
		sta sprite_x_pos_1+$07
		cmp #$40
		bcs spr_msb_skip_2
		lda sprite_x_msb_1
		ora #$94
		sta sprite_x_msb_1
spr_msb_skip_2

; Update the sprite positions - lower sprites
		lda #$00
		sta sprite_x_msb_2

		lda cos_at_2
		clc
		adc #$3c
		tax
		lda sprite_cosinus,x
		sta sprite_x_pos_2+$00
		sta sprite_x_pos_2+$03
		sta sprite_x_pos_2+$05
		clc
		adc #$18
		sta sprite_x_pos_2+$01
		sta sprite_x_pos_2+$06
		cmp #$40
		bcs spr_msb_skip_3
		ldy #$42
		sty sprite_x_msb_2
spr_msb_skip_3	clc
		adc #$18
		sta sprite_x_pos_2+$02
		sta sprite_x_pos_2+$04
		sta sprite_x_pos_2+$07
		cmp #$40
		bcs spr_msb_skip_4
		lda sprite_x_msb_2
		ora #$94
		sta sprite_x_msb_2
spr_msb_skip_4

		lda #$01
		sta rn
		lda #rstr1p
		sta $d012

ea31		pla
		tay
		pla
		tax
		pla
nmi		rti

; ROL scroller
scroller	ldx #$01
mover		asl char_buffer,x
		rol $4140,x
		rol $4138,x
		rol $4130,x
		rol $4128,x
		rol $4120,x
		rol $4118,x

		rol $4110,x
		rol $4108,x
		rol $4100,x
		rol $40f8,x
		rol $40f0,x
		rol $40e8,x

		rol $40e0,x
		rol $40d8,x
		rol $40d0,x
		rol $40c8,x
		rol $40c0,x
		rol $40b8,x

		rol $40b0,x
		rol $40a8,x
		rol $40a0,x
		rol $4098,x
		rol $4090,x
		rol $4088,x

		rol $4080,x
		rol $4078,x
		rol $4070,x
		rol $4068,x
		rol $4060,x
		rol $4058,x

		rol $4050,x
		rol $4048,x
		rol $4040,x
		rol $4038,x
		rol $4030,x
		rol $4028,x

		rol $4020,x
		rol $4018,x
		rol $4010,x
		rol $4008,x
		inx
		cpx #$08
		beq *+$05
		jmp mover

		ldx char_cnt
		inx
		cpx #$08
		bne cc_xb

mread		lda scroll_text
		bne okay
		jsr reset
		jmp mread

okay		sta def_copy+$01
		lda #$00
		asl def_copy+$01
		rol
		asl def_copy+$01
		rol
		asl def_copy+$01
		rol
		clc
		adc #$44
		sta def_copy+$02

		ldx #$01
def_copy	lda $4800,x
		sta char_buffer,x
		inx
		cpx #$08
		bne def_copy

		inc mread+$01
		bne *+$05
		inc mread+$02

		ldx #$00
cc_xb		stx char_cnt

		rts

; Reset the scrolling message to it's start
reset		lda #<scroll_text
		sta mread+$01
		lda #>scroll_text
		sta mread+$02
		rts

; Screen data
scroll_line	!byte $01,$02,$03,$04,$05
		!byte $3a,$3b,$3c,$3d,$3e,$3f
		!byte $0c,$0d,$0e,$0f,$10,$11
		!byte $3a,$3b,$3c,$3d,$3e,$3f
		!byte $18,$19,$1a,$1b,$1c,$1d
		!byte $3a,$3b,$3c,$3d,$3e,$3f
		!byte $24,$25,$26,$27,$28

scroll_col_line	!byte $0c,$0c,$0c,$0c,$0c
		!byte $0a,$0a,$0a,$0a,$0a,$0a
		!byte $0c,$0c,$0c,$0c,$0c,$0c
		!byte $05,$05,$05,$05,$05,$05
		!byte $0c,$0c,$0c,$0c,$0c,$0c
		!byte $0e,$0e,$0e,$0e,$0e,$0e
		!byte $0c,$0c,$0c,$0c,$0c

; Cosine table for the $d016 waves
d016_cosinus	!byte $07,$07,$07,$07,$07,$07,$07,$07
		!byte $06,$06,$06,$05,$05,$05,$04,$04
		!byte $03,$03,$03,$02,$02,$02,$01,$01
		!byte $01,$00,$00,$00,$00,$00,$00,$00
		!byte $00,$00,$00,$00,$00,$00,$00,$01
		!byte $01,$01,$01,$02,$02,$03,$03,$03
		!byte $04,$04,$05,$05,$05,$06,$06,$06
		!byte $07,$07,$07,$07,$07,$07,$07,$07

		!byte $07,$07,$07,$07,$07,$07,$07,$07
		!byte $06,$06,$06,$05,$05,$05,$04,$04
		!byte $03,$03,$03,$02,$02,$02,$01,$01
		!byte $01,$00,$00,$00,$00,$00,$00,$00
		!byte $00,$00,$00,$00,$00,$00,$00,$01
		!byte $01,$01,$01,$02,$02,$03,$03,$03
		!byte $04,$04,$05,$05,$05,$06,$06,$06
		!byte $07,$07,$07,$07,$07,$07,$07,$07

		!byte $07,$07,$07,$07,$07,$07,$07,$07
		!byte $06,$06,$06,$05,$05,$05,$04,$04
		!byte $03,$03,$03,$02,$02,$02,$01,$01
		!byte $01,$00,$00,$00,$00,$00,$00,$00
		!byte $00,$00,$00,$00,$00,$00,$00,$01
		!byte $01,$01,$01,$02,$02,$03,$03,$03
		!byte $04,$04,$05,$05,$05,$06,$06,$06
		!byte $07,$07,$07,$07,$07,$07,$07,$07

		!byte $07,$07,$07,$07,$07,$07,$07,$07
		!byte $06,$06,$06,$05,$05,$05,$04,$04
		!byte $03,$03,$03,$02,$02,$02,$01,$01
		!byte $01,$00,$00,$00,$00,$00,$00,$00
		!byte $00,$00,$00,$00,$00,$00,$00,$01
		!byte $01,$01,$01,$02,$02,$03,$03,$03
		!byte $04,$04,$05,$05,$05,$06,$06,$06
		!byte $07,$07,$07,$07,$07,$07,$07,$07

; Sprite cosinus
sprite_cosinus	!byte $ff,$ff,$ff,$ff,$ff,$ff,$fe,$fe
		!byte $fd,$fd,$fc,$fc,$fb,$fa,$f9,$f9
		!byte $f8,$f7,$f5,$f4,$f3,$f2,$f1,$ef
		!byte $ee,$ec,$eb,$e9,$e8,$e6,$e5,$e3
		!byte $e1,$df,$dd,$db,$d9,$d7,$d5,$d3
		!byte $d1,$cf,$cd,$cb,$c8,$c6,$c4,$c2
		!byte $bf,$bd,$ba,$b8,$b6,$b3,$b1,$ae
		!byte $ac,$a9,$a7,$a4,$a2,$9f,$9c,$9a

		!byte $97,$95,$92,$90,$8d,$8b,$88,$86
		!byte $83,$81,$7e,$7c,$79,$77,$74,$72
		!byte $6f,$6d,$6b,$69,$66,$64,$62,$60
		!byte $5e,$5b,$59,$57,$55,$53,$51,$50
		!byte $4e,$4c,$4a,$49,$47,$45,$44,$42
		!byte $41,$3f,$3e,$3d,$3c,$3a,$39,$38
		!byte $37,$36,$35,$35,$34,$33,$33,$32
		!byte $31,$31,$31,$30,$30,$30,$30,$30

		!byte $30,$30,$30,$30,$30,$30,$31,$31
		!byte $32,$32,$33,$33,$34,$35,$36,$37
		!byte $38,$39,$3a,$3b,$3c,$3d,$3f,$40
		!byte $41,$43,$44,$46,$47,$49,$4b,$4c
		!byte $4e,$50,$52,$54,$56,$58,$5a,$5c
		!byte $5e,$60,$62,$65,$67,$69,$6b,$6e
		!byte $70,$73,$75,$77,$7a,$7c,$7f,$81
		!byte $84,$86,$89,$8b,$8e,$90,$93,$95

		!byte $98,$9b,$9d,$a0,$a2,$a5,$a7,$aa
		!byte $ac,$af,$b1,$b4,$b6,$b9,$bb,$bd
		!byte $c0,$c2,$c5,$c7,$c9,$cb,$cd,$d0
		!byte $d2,$d4,$d6,$d8,$da,$dc,$de,$e0
		!byte $e1,$e3,$e5,$e7,$e8,$ea,$eb,$ed
		!byte $ee,$f0,$f1,$f2,$f4,$f5,$f6,$f7
		!byte $f8,$f9,$fa,$fa,$fb,$fc,$fd,$fd
		!byte $fe,$fe,$fe,$ff,$ff,$ff,$ff,$ff

; Sprite positions
sprite_x_pos_1	!byte $00,$00,$00,$00,$00,$00,$00,$00
sprite_x_msb_1	!byte $00
sprite_y_pos_1	!byte $43,$43,$43,$58,$58,$6d,$6d,$6d

sprite_x_pos_2	!byte $00,$00,$00,$00,$00,$00,$00,$00
sprite_x_msb_2	!byte $00
sprite_y_pos_2	!byte $ab,$ab,$ab,$c0,$c0,$d5,$d5,$d5

sprite_cols_1	!byte $0a,$0a,$0a,$05,$05,$0e,$0e,$0e
sprite_cols_2	!byte $0e,$05,$0a,$0e,$0a,$0e,$05,$0a
sprite_dps	!byte $20,$21,$22,$23,$24,$25,$26,$27

; Guess what this is!!
scroll_text	!scr "here we go again with another monthly demo from a dusty "
		!scr "corner of the cosine warehouse... and yes, this time it "
		!scr "was seriously rushed with a prototype being plucked from "
		!scr "a work directory and hammered until it turned into a release "
		!scr "over the course of the last day in november because i "
		!scr "forgot, okay?!    i'm getting old, that's my excuse and i'm "
		!scr "sticking to it..."
		!scr "      "

		!scr "in fact i was already sort of planning the december release "
		!scr "and, because october was so late, forgot about this one "
		!scr "entirely so whoops and all that."
		!scr "      "

		!scr "so coding was by me (t.m.r) with thanks to odie for the original "
		!scr "idea and t.l.f. (who never actually left cosine as such...!) "
		!scr "for the musical accompaniment which is called 'no more' and "
		!scr "was chosen because doctor who - fans should get the reference "
		!scr "and know why november is an important month for the show..."
		!scr "      "

		!scr "so obviously md201511 isn't much to write home about;  twenty "
		!scr "four character lines of what would otherwise be empty screen "
		!scr "are populated with a zybex-style starfield (it may have "
		!scr "originated somewhere else, but that's where i saw it first) "
		!scr "simply because i've never done one before and usually lean "
		!scr "towards the method used in delta instead. the main effect on "
		!scr "this character line is multiple writes to d016 across each "
		!scr "of the seven scanlines in use which is, again, absolutely "
		!scr "nothing special;  the code was originally built a practical "
		!scr "example after odie asked me what happened at the points where "
		!scr "the splits overlapped.  i did try having a scroller right "
		!scr "across the line, but the joins looked terrible..."
		!scr "      "

		!scr "that said, there is at least something odd going on here... "
		!scr "try counting the number of columns."
		!scr "      "

		!scr "and now the remainder of this text will be made up of "
		!scr "cosine's alpha-sorted and multi format greetings, with "
		!scr "said list looking something like this:"
		!scr "      "

		!scr "abyss connection  - "
		!scr "arkanix labs  - "
		!scr "artstate  - "
		!scr "ate bit  - "
		!scr "booze design  - "
		!scr "camelot  - "
		!scr "chorus  - "
		!scr "chrome  - "
		!scr "c.n.c.d.  - "
		!scr "c.p.u.  - "
		!scr "crescent  - "
		!scr "crest  - "
		!scr "covert bitops  - "
		!scr "defence force  - "
		!scr "dekadence  - "
		!scr "desire  - "
		!scr "d.a.c.  - "
		!scr "dmagic  - "
		!scr "dual crew  - "
		!scr "exclusive on  - "
		!scr "fairlight  - "
		!scr "fire  - "
		!scr "focus  - "
		!scr "funkscientist productions  - "
		!scr "genesis project  - "
		!scr "gheymaid inc.  - "
		!scr "hitmen  - "
		!scr "hokuto force  - "
		!scr "level64  - "
		!scr "m and m  - "
		!scr "maniacs of noise  - "
		!scr "meanteam  - "
		!scr "metalvotze  - "
		!scr "noname  - "
		!scr "nostalgia  - "
		!scr "nuance  - "
		!scr "offence  - "
		!scr "onslaught  - "
		!scr "orb  - "
		!scr "oxyron  - "
		!scr "padua  - "
		!scr "plush  - "
		!scr "psytronik  - "
		!scr "reptilia  - "
		!scr "resource  - "
		!scr "rgcd  - "
		!scr "secure  - "
		!scr "shape  - "
		!scr "side b  - "
		!scr "slash  - "
		!scr "slipstream  - "
		!scr "success and trc  - "
		!scr "style  - "
		!scr "suicyco industries  - "
		!scr "taquart  - "
		!scr "tempest  - "
		!scr "tek  - "
		!scr "triad  - "
		!scr "trsi  - "
		!scr "viruz  - "
		!scr "vision  - "
		!scr "wow  - "
		!scr "wrath  - "
		!scr "xenon  - "
		!scr "all the nice people i forgot, even if they never write to "
		!scr "remind me!"
		!scr "      "

		!scr "finally, a quick and traditional plug for the cosine website "
		!scr "at http://cosine.org.uk/ and i think we're done, so this was "
		!scr "t.m.r filling memory on the 30th of November 2015... .. .  .   ."
		!scr "      "

		!byte $00

; Star co-ordinates
star_x_pos	!byte $00,$82,$64,$b6,$e7,$a5
star_x_fine	!byte $00,$01,$00,$06,$0f,$0b
star_x_speed	!byte $01,$04,$02,$03,$02,$00

; Pixels for the starfield
star_decode	!byte $01,$02,$04,$08,$10,$20,$40,$80

; Colour table for the starfield
star_pulse	!byte $09,$09,$02,$02,$08,$08,$0c,$0c
		!byte $0a,$0a,$0f,$0f,$07,$07,$01,$01
		!byte $01,$01,$0d,$0d,$03,$03,$05,$05
		!byte $0e,$0e,$04,$04,$0b,$0b,$06,$06

		!byte $09,$09,$02,$02,$08,$08,$0c,$0c
		!byte $0a,$0a,$0f,$0f,$07,$07,$01,$01
		!byte $01,$01,$0d,$0d,$03,$03,$05,$05
		!byte $0e,$0e,$04,$04,$0b,$0b,$06,$06