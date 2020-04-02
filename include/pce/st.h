struct st_header {
	unsigned char *patterns;
	unsigned char **wave_table;
	unsigned char **vol_table;
	unsigned char *chan_map;
};

extern unsigned char st_song_bank;
extern unsigned char **st_pattern_table;

extern unsigned char *st_chan_env[];
extern unsigned char st_chan_env_pos[];
extern unsigned char st_chan_len[];

extern unsigned char st_row_idx;
extern unsigned char st_pattern_idx;
extern unsigned char *st_chan_map;
extern unsigned char **st_wave_table;
extern unsigned char **st_vol_table;

void st_init(void);
void st_reset(void);
void st_set_song(unsigned char song_bank, struct st_header *song_addr);

void st_set_env(unsigned char chan, unsigned char *env);
void st_set_vol(unsigned char chan, unsigned char left, unsigned char right);
void st_load_wave(unsigned char chan, unsigned char *wave);
void st_effect_wave(unsigned char chan, unsigned int freq, unsigned char len);
void st_effect_noise(unsigned char chan, unsigned char freq, unsigned char len);
