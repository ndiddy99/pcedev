;====================================================================
;
; PC Engine CD-ROM SYSTEM BIOS  version 3.00
;
; BIOS ENTRY and WORK equ
;
; 910304  Takaki Kobayashi  
;
;====================================================================
;
max_mapping equ $FFF5

;--------------------------------------------------------------------
; BIOS ENTRY
;
cd_boot     equ $E000
cd_reset    equ $E003
cd_base     equ $E006
cd_read     equ $E009
cd_seek     equ $E00C
cd_exec     equ $E00F
cd_play     equ $E012
cd_search   equ $E015
cd_pause    equ $E018
cd_stat     equ $E01B
cd_subq     equ $E01E
cd_dinfo    equ $E021
cd_contnts  equ $E024
cd_subrd    equ $E027
cd_pcmrd    equ $E02A
cd_fade     equ $E02D

ad_reset    equ $E030
ad_trans    equ $E033
ad_read     equ $E036
ad_write    equ $E039
ad_play     equ $E03C
ad_cplay    equ $E03F
ad_stop     equ $E042
ad_stat     equ $E045

bm_format   equ $E048
bm_free     equ $E04B
bm_read     equ $E04E
bm_write    equ $E051
bm_delete   equ $E054
bm_files    equ $E057

ex_getver   equ $E05A
ex_setvec   equ $E05D
ex_getfnt   equ $E060
ex_joysns   equ $E063
ex_joyrep   equ $E066
ex_scrsiz   equ $E069
ex_dotmod   equ $E06C
ex_scrmod   equ $E06F
ex_imode    equ $E072
ex_vmode    equ $E075
ex_hmode    equ $E078
ex_vsync    equ $E07B
ex_rcron    equ $E07E
ex_rcroff   equ $E081
ex_irqon    equ $E084
ex_irqoff   equ $E087
ex_bgon     equ $E08A
ex_bgoff    equ $E08D
ex_spron    equ $E090
ex_sproff   equ $E093
ex_dspon    equ $E096
ex_dspoff   equ $E099
ex_dmamod   equ $E09C
ex_sprdma   equ $E09F
ex_satclr   equ $E0A2
ex_sprput   equ $E0A5
ex_setrcr   equ $E0A8
ex_setred   equ $E0AB
ex_setwrt   equ $E0AE
ex_setdma   equ $E0B1
ex_binbcd   equ $E0B4
ex_bcdbin   equ $E0B7
ex_rnd      equ $E0BA
ex_colorcmd equ $E0E4

ma_mul8u    equ $E0BD
ma_mul8s    equ $E0C0
ma_mul16u   equ $E0C3
ma_div16s   equ $E0C6
ma_div16u   equ $E0C9
ma_sqrt     equ $E0CC
ma_sin      equ $E0CF
ma_cos      equ $E0D2
ma_atni     equ $E0D5

psg_bios    equ $E0D8
grp_bios    equ $E0DB

ex_memopen  equ $E0DE   ;ver 3.00 or later

psg_drive   equ $E0E1

;--------------------------------------------------------------------
; ZERO PAGE WORK
;
zpgtop      equ $20DC
;
zpg_grp_top equ $20DC
vi_bitpat   equ $20DC   ;1
vi_rvbitpat equ $20DD   ;1
vi_ft_front equ $20DE
vi_padrs    equ $20DE   ;2
vi_porg     equ $20E0   ;1
vi_ft_back  equ $20E1   ;3
vi_stack    equ $20E4   ;2
;
zpg_psg_top equ $20E6
time_sw     equ $20E6   ;1
main_sw     equ $20E7   ;1
si          equ $20E8
si_l        equ $20E8   ;1
si_h        equ $20E9   ;1
r0          equ $20EA
r0_l        equ $20EA   ;1
r0_h        equ $20EB   ;1
;
zpg_sys_top equ $20EC
zx0         equ $20EC
zl0         equ $20EC   ;1
zh0         equ $20ED   ;1
zx1         equ $20EE
zl1         equ $20EE   ;1
zh1         equ $20EF   ;1
zx2         equ $20F0
zl2         equ $20F0   ;1
zh2         equ $20F1   ;1
cdi_b       equ $20F2   ;1
crl_m       equ $20F3   ;1
crh_m       equ $20F4   ;1
irq_m       equ $20F5   ;1
str_b       equ $20F6   ;1
reg_box     equ $20F7   ;1
_ax         equ $20F8
_al         equ $20F8   ;1
_ah         equ $20F9   ;1
_bx         equ $20FA
_bl         equ $20FA   ;1
_bh         equ $20FB   ;1
_cx         equ $20FC
_cl         equ $20FC   ;1
_ch         equ $20FD   ;1
_dx         equ $20FE
_dl         equ $20FE   ;1
_dh         equ $20FF   ;1

;--------------------------------------------------------------------
; RAM WORK
;
ramtop      equ $2200
;
usrvec      equ $2200
irq2_jmp    equ $2200   ;2
irq_jmp     equ $2202   ;2
tim_jmp     equ $2204   ;2
nmi_jmp     equ $2206   ;2
sync_jmp    equ $2208   ;2
rcr_jmp     equ $220A   ;2
bgx1        equ $220C   ;2
bgx2        equ $220E   ;2
bgy1        equ $2210   ;2
bgy2        equ $2212   ;2
sat_adr     equ $2214   ;2
sprptr      equ $2216   ;1
spryl       equ $2217   ;1
spryh       equ $2218   ;1
sprxl       equ $2219   ;1
sprxh       equ $221A   ;1
sprnl       equ $221B   ;1
sprnh       equ $221C   ;1
spral       equ $221D   ;1
sprah       equ $221E   ;1
color_cmd   equ $221F   ;1
bgc_ptr     equ $2220   ;2
bgc_len     equ $2222   ;1
sprc_ptr    equ $2223   ;2
sprc_len    equ $2225   ;1
joykeyflg   equ $2226   ;1
joyena      equ $2227   ;1
joy         equ $2228   ;5
joytrg      equ $222D   ;5
joyold      equ $2232   ;5
irq_cnt     equ $2241   ;1
mwr_m       equ $2242   ;1
dcr_m       equ $2243   ;1
notrdyflg   equ $2247   ;1
rndseed     equ $2249   ;1
rndl        equ $2249   ;1
rndh        equ $224A   ;1
rndm        equ $224B   ;1
tnomin      equ $226A   ;1
tnomax      equ $226B   ;1
outmin      equ $226C   ;1
outsec      equ $226D   ;1
outfrm      equ $226E   ;1
vdtin_flg   equ $2272   ;1
recbase0_h  equ $2274   ;1
recbase0_m  equ $2275   ;1
recbase0_l  equ $2276   ;1
recbase1_h  equ $2277   ;1
recbase1_m  equ $2278   ;1
recbase1_l  equ $2279   ;1
scsists     equ $227B   ;1
suberrc     equ $227C   ;1
subcode     equ $227E   ;1

ramend      equ $22D0

psg_work_top    equ $22D0
graph_work_top  equ $2616
key_work_top    equ $2646
user_work_top   equ $267C

;--------------------------------------------------------------------
; PSG_BIOS FUNCTION NUMBER
;
PSG_ON      equ 0
PSG_OFF     equ 1
PSG_INIT    equ 2
PSG_BANK    equ 3
PSG_TRACK   equ 4
PSG_WAVE    equ 5
PSG_ENV     equ 6
PSG_FM      equ 7
PSG_PE      equ 8
PSG_PC      equ 9
PSG_TEMPO   equ 10
PSG_PLAY    equ 11
PSG_MSTAT   equ 12
PSG_SSTAT   equ 13
PSG_MSTOP   equ 14
PSG_SSTOP   equ 15
PSG_ASTOP   equ 16
PSG_MVOFF   equ 17
PSG_CONT    equ 18
PSG_FDOUT   equ 19
PSG_DCNT    equ 20

;--------------------------------------------------------------------
; GRP_BIOS FUNCTION NUMBER
;
VI_GINIT    equ 0
VI_CASHCLR  equ 1
VI_STRTADR  equ 2
VI_GETADRS  equ 3
VI_CLS      equ 4
VI_PSET     equ 5
VI_POINT    equ 6
VI_LINE     equ 7
VI_BOX      equ 8
VI_BOXF     equ 9
VI_FLOOD    equ 10
VI_PAINT    equ 11
VI_GWINDOW  equ 12
VI_GFONT    equ 13
VI_PUTFONT  equ 14
VI_SYMBOL   equ 15
;--------------------------------------------------------------------