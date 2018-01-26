

#define pi  3.14159265359


typedef struct{
    double real;
    double image;
}Complex;


Complex ComMul(Complex ,Complex );
Complex ComAdd(Complex ,Complex );
Complex ComSub(Complex ,Complex );



void conj( Complex *,int ,int );
int Reform(double **,int );
int BitRevers(int ,int );
void Displace(double *,int,int );
void CalcWfft(Complex *,int);

