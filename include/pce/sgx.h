#ifndef _SGX_H
#define _SGX_H

/*
 * SGX fastcall defines
 */


void __fastcall sgx_vreg( unsigned char reg<acc> );
void __fastcall sgx_vreg( unsigned char reg<__al>, unsigned int data<__cx> );

void __fastcall sgx_read_vram( unsigned int vram_offset<__ax> );

void __fastcall sgx_load_bat(unsigned int vaddr<__di>, int far *bat_data<__bl:__si>, unsigned char w<__cl>, unsigned char h<__ch>);

void __fastcall sgx_set_screen_size( unsigned char size<acc> );

void __fastcall sgx_load_vram(unsigned int vaddr <__di>, int far *data<__bl:__si>, int nb<__cx>);

void __fastcall sgx_set_tile_data(char *tile_ex<__di>);
void __fastcall sgx_set_tile_data(char far *tile<__bl:__si>, int nb_tile<__cx>, char far *ptable<__al:__dx>, char type<__ah>);


void __fastcall sgx_set_map_data(int *ptr<acc>);
void __fastcall sgx_set_map_data(char far *map<__bl:__si>, int w<__ax>, int h<acc>);
void __fastcall sgx_set_map_data(char far *map<__bl:__si>, int w<__ax>, int h<__dx>, char wrap<acc>);

void __fastcall sgx_load_map(char x<__al>, char y<__ah>, int mx<__di>, int my<__bx>, char w<__dl>, char h<__dh>);

void __fastcall sgx_scroll(int x<__ax>, int y<__bx>);

void __fastcall sgx_spr_set( char num<acc> );

void sgx_satb_update(void);
void __fastcall sgx_satb_update( unsigned char max<acc> );

void __fastcall sgx_spr_hide( char num<acc> );

void __fastcall sgx_spr_show( char num<acc> );

void __fastcall sgx_spr_ctrl(char mask<__al>, char value<acc>);

void __fastcall vpc_win_size(char window_num<__al>, int size<__bx>);

void __fastcall vpc_win_reg(char window_num<__al>, char var<__bl>);


/*
 * SGX defines
 */
#define SGX				0x01
#define VPC_WIN_A			0x00
#define VPC_WIN_B			0x01
#define	VPC_WIN_AB			0x02
#define	VPC_WIN_NONE			0x03
#define	VPC_NORM			0x00
#define	VPC_SPR				0x04
#define	VPC_INV_SPR			0x08
#define VDC1_ON				0x01
#define	VDC1_OFF			0x00
#define VDC2_ON				0x02
#define	VDC2_OFF			0x00
#define VDC_ON				0x03
#define	VDC_OFF				0x00

#endif /* _SGX_H */
