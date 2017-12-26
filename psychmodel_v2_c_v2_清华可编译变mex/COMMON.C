
/***********************************************************************
*
*  Global Include Files
*
***********************************************************************/

#include        "common.h"


/***********************************************************************
*
*  Global Variable Definitions
*
***********************************************************************/

char *mode_names[4] = { "stereo", "j-stereo", "dual-ch", "single-ch" };
char *layer_names[3] = { "I", "II", "III" };

double  s_freq[4] = {44.1, 48, 32, 0};

int     bitrate[3][15] = {
          {0,32,64,96,128,160,192,224,256,288,320,352,384,416,448},
          {0,32,48,56,64,80,96,112,128,160,192,224,256,320,384},
          {0,32,40,48,56,64,80,96,112,128,160,192,224,256,320}
        };

double FAR multiple[64] = {
2.00000000000000, 1.58740105196820, 1.25992104989487,
1.00000000000000, 0.79370052598410, 0.62996052494744, 0.50000000000000,
0.39685026299205, 0.31498026247372, 0.25000000000000, 0.19842513149602,
0.15749013123686, 0.12500000000000, 0.09921256574801, 0.07874506561843,
0.06250000000000, 0.04960628287401, 0.03937253280921, 0.03125000000000,
0.02480314143700, 0.01968626640461, 0.01562500000000, 0.01240157071850,
0.00984313320230, 0.00781250000000, 0.00620078535925, 0.00492156660115,
0.00390625000000, 0.00310039267963, 0.00246078330058, 0.00195312500000,
0.00155019633981, 0.00123039165029, 0.00097656250000, 0.00077509816991,
0.00061519582514, 0.00048828125000, 0.00038754908495, 0.00030759791257,
0.00024414062500, 0.00019377454248, 0.00015379895629, 0.00012207031250,
0.00009688727124, 0.00007689947814, 0.00006103515625, 0.00004844363562,
0.00003844973907, 0.00003051757813, 0.00002422181781, 0.00001922486954,
0.00001525878906, 0.00001211090890, 0.00000961243477, 0.00000762939453,
0.00000605545445, 0.00000480621738, 0.00000381469727, 0.00000302772723,
0.00000240310869, 0.00000190734863, 0.00000151386361, 0.00000120155435,
1E-20
};

/***********************************************************************
*
*  Global Function Definitions
*
***********************************************************************/

/* The system uses a variety of data files.  By opening them via this
   function, we can accommodate various locations. */

/*
FILE *OpenTableFile(name)
char *name;
{
char fulname[80];
FILE *f;

     fulname[0] = '\0';

#ifdef TABLES_PATH
       strcpy(fulname, TABLES_PATH);   // default relative path for tables
#endif // TABLES_PATH          // (includes terminal path seperator


    strcat(fulname, name);
    if( (f=fopen(fulname,"r"))==NULL ) {
        fprintf(stderr,"OpenTable: could not find %s\n", fulname);

#ifdef TABLES_PATH
            fprintf(stderr,"Check local directory './%s'\n",TABLES_PATH);
#endif // TABLES_PATH

    }
    return f;
}
*/

/***********************************************************************
/*
/* Read one of the data files ("alloc_*") specifying the bit allocation/
/* quatization parameters for each subband in layer II encoding
/*
/**********************************************************************/
/*
int read_bit_alloc(table, alloc)        // read in table, return # subbands
int table;
al_table *alloc;
{
        unsigned int a, b, c, d, i, j;
        FILE *fp;
        char name[16], t[80];
        int sblim;

        strcpy(name, "alloc_0");

        switch (table) {
                case 0 : name[6] = '0';         break;
                case 1 : name[6] = '1';         break;
                case 2 : name[6] = '2';         break;
                case 3 : name[6] = '3';         break;
                default : name[6] = '0';
        }

        if (!(fp = OpenTableFile(name))) {
                printf("Please check bit allocation table %s\n", name);
                exit(1);
        }

        printf("using bit allocation table %s\n", name);

        fgets(t, 80, fp);
        sscanf(t, "%d\n", &sblim);
				
        while (!feof(fp)) {
                fgets(t, 80, fp);
                sscanf(t, "%d %d %d %d %d %d\n", &i, &j, &a, &b, &c, &d);
                        (*alloc)[i][j].steps = a;
                        (*alloc)[i][j].bits  = b;
                        (*alloc)[i][j].group = c;
                        (*alloc)[i][j].quant = d;
        }
				
        fclose(fp);
        return sblim;
}
*/
/***********************************************************************
/*
/* Using the decoded info the appropriate possible quantization per
/* subband table is loaded
/*
/**********************************************************************/

int pick_table(fr_ps)   /* choose table, load if necess, return # sb's */
frame_params *fr_ps;
{
        int table, lay, ws, bsp, br_per_ch;
				double sfrq;
        int sblim = fr_ps->sblimit;     /* return current value if no load */

        lay = fr_ps->header->lay - 1;
        bsp = fr_ps->header->bitrate_index;
        br_per_ch = bitrate[lay][bsp] / fr_ps->stereo;
        ws = fr_ps->header->sampling_frequency;
        sfrq = s_freq[ws];
        /* decision rules refer to per-channel bitrates (kbits/sec/chan) */
 // not read all info in tables ALLOC_0~3, only read in sblimit ---Peng Zhang
				if ((sfrq == 48 && br_per_ch >= 56) ||
					(br_per_ch >= 56 && br_per_ch <= 80)) {table = 0; sblim = 27;}
        else if (sfrq != 48 && br_per_ch >= 96) {table = 1; sblim = 30;}
        else if (sfrq != 32 && br_per_ch <= 48) {table = 2; sblim = 8;}
        else {table = 3; sblim = 12;}
				/*
        if (fr_ps->tab_num != table) {
           if (fr_ps->tab_num >= 0)
              mem_free((void **)&(fr_ps->alloc));
           fr_ps->alloc = (al_table FAR *) mem_alloc(sizeof(al_table),
                                                         "alloc");
           sblim = read_bit_alloc(fr_ps->tab_num = table, fr_ps->alloc);
        }
				*/
        return sblim;
}



void WriteHdr(fr_ps, s)
frame_params *fr_ps;
FILE *s;
{
layer *info = fr_ps->header;

   fprintf(s, "HDR:  s=FFF, l=%X, br=%X, sf=%X\n",
           info->lay, info->bitrate_index, info->sampling_frequency);
   fprintf(s, "layer=%s, tot bitrate=%d, sfrq=%.1f, ",
           layer_names[info->lay-1], bitrate[info->lay-1][info->bitrate_index],
           s_freq[info->sampling_frequency]);
   fprintf(s, "sblim=%d, ch=%d\n",
           fr_ps->sblimit, fr_ps->stereo);
   fflush(s);
}

/*
void WriteSamples(ch, sample, bit_alloc, fr_ps, s)
int ch;
unsigned int FAR sample[SBLIMIT];
unsigned int bit_alloc[SBLIMIT];
frame_params *fr_ps;
FILE *s;
{
int i;
int stereo = fr_ps->stereo;
int sblimit = fr_ps->sblimit;

        fprintf(s, "SMPL ");
        for (i=0;i<sblimit;i++)
                if ( bit_alloc[i] != 0)
                    fprintf(s, "%d:", sample[i]);
        if(ch==(stereo-1) )     fprintf(s, "\n");
        else                    fprintf(s, "\t");
}
*/

int BitrateIndex(layr, bRate)   /* convert bitrate in kbps to index */
int     layr;           /* 1 or 2 */
int     bRate;          /* legal rates from 32 to 448 */
{
int     index = 0;
int     found = 0;

    while(!found && index<15)   {
        if(bitrate[layr-1][index] == bRate)
            found = 1;
        else
            ++index;
    }
    if(found)
        return(index);
    else {
        fprintf(stderr, "BitrateIndex: %d (layer %d) is not a legal bitrate\n",
                bRate, layr);
        return(-1);     /* Error! */
    }
}

int SmpFrqIndex(sRate)  /* convert samp frq in Hz to index */
long sRate;             /* legal rates 32000, 44100, 48000 */
{
    if(sRate == 44100L)
        return(0);
    else if(sRate == 48000L)
        return(1);
    else if(sRate == 32000L)
        return(2);
    else {
        fprintf(stderr, "SmpFrqIndex: %ld is not a legal sample rate\n", sRate);
        return(-1);      /* Error! */
    }
}

/*******************************************************************************
*
*  Allocate number of bytes of memory equal to "block".
*
*******************************************************************************/

void  FAR *mem_alloc(block, item)
unsigned long   block;
char            *item;
{
    void    *ptr;

    ptr = (void FAR *) malloc(block);

    if (ptr != NULL)	memset(ptr, 0, block);
    else{
        printf("Unable to allocate %s\n", item);
        exit(0);
    }
    return(ptr);
}


/****************************************************************************
*
*  Free memory pointed to by "*ptr_addr".
*
*****************************************************************************/

void    mem_free(ptr_addr)
void    **ptr_addr;
{
    if (*ptr_addr != NULL){
        free(*ptr_addr);
        *ptr_addr = NULL;
    }

}
