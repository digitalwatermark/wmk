
#include "user.h"

	

void ifft_fft(Complex *data,int len)
{
  int M,j,k,i;
    int GroupNum;
    int CellNum;
    int reallen;
    int pos1,pos2;
	Complex mul;
		clock_t start, end;

	double scal = (double)1/len;
   
	Complex *w =(Complex*) malloc(len*sizeof(Complex)/2);  

	double *inI =(double*) malloc(len*sizeof(double)); 
	double *inQ =(double*) malloc(len*sizeof(double));  

	

    
	for(i=0;i<len;i++) { inI[i]=data[i].real; inQ[i]=data[i].image; }

	
	
	M = Reform(&inI,len);                    /*let the data length is pow of 2*/
    reallen = pow(2.0,M);
   
	
    CalcWfft(w,reallen/2);
	  

	Displace(inI,reallen,M);
	Displace(inQ,reallen,M);
    
for(i=0;i<len;i++)  {data[i].real = inI[i];data[i].image=inQ[i];}
    
    

    GroupNum =reallen/2;
    CellNum =1;
	//	start = clock();  
    	
    for(i=0;i<14;i++)	//M级
    {       
       
	
		for(j=0;j<GroupNum;j++)		//每级有N/2个碟形
        {
            for(k=0;k<CellNum;k++)	//每个碟形的运算
            {
                pos1 = j*CellNum*2+k ;
                pos2 = pos1 + CellNum;

                mul = ComMul(data[pos2],w[k*GroupNum]);		//每个碟形的乘法运算
                
                data[pos2] = ComSub(data[pos1] ,mul);			//每个碟形的减法运算
                data[pos1] = ComAdd(data[pos1] ,mul);			//每个碟形的加法运算
            }

		
        }
  
		
		GroupNum = GroupNum/2;
        CellNum = CellNum*2;   
  
    }

//		end = clock();
	
	   //     printf("The time was: %f\n", (double)(end-start)/1000 ); //此处为检测结束的时间点win下为31ms
	
	free(w);
	free(inQ);
	free(inI);


}

void CalcWfft(Complex *w, int n)
{
    int i;

    for(i=0;i<n;i++)
    {
        w[i].real =1*cosf(float(pi*i/n));
        w[i].image =-1*sinf(float(pi*i/n));
    }


}

Complex ComMul(Complex p1,Complex p2)
{
    Complex res;
    res.real = p1.real*p2.real - p1.image*p2.image;
    res.image = p1.real*p2.image + p1.image*p2.real;
    
    return res;
}

void conj( Complex *res,int len,int n)
{
	int	i=0;
	
	while(i<len) {
		
		res[i].real = (res[i].real)/n;  
		res[i].image =((-1)*res[i].image)/n;
		i++;
	}
}


Complex ComAdd(Complex p1,Complex p2)
{
    Complex res;
    res.real = p1.real + p2.real;
    res.image = p1.image + p2.image;
    
    return res;
}

Complex ComSub(Complex p1,Complex p2)
{
    Complex res;
    res.real = p1.real - p2.real;
    res.image = p1.image - p2.image;
    
    return res;
}
        

int BitRevers(int src,int size)
{
    int temp=src;
    int dst=0;
    int i=0;
    for(i=size-1;i>=0;i--)
    {
        dst=((temp&0x1)<<i)|dst;
        temp=temp>>1;
    }
    return dst;
}

void Displace(double *in,int size,int m)
{
    int i;
    int new_i;
    float t;
    for(i=1;i<size;i++)
    {
        new_i=BitRevers(i,m);
        if(new_i>i)
        {
            t=in[i];
            in[i]=in[new_i];
            in[new_i]=t;
        }
     }

}


int Reform(double **in,int len)
{
    int i=0;
    int w=1;
    
    while(w*2<=len) {w=w*2;i++;}

    if(w<len)
    {
        
        *in = (double*)realloc(*in,w*2*sizeof(double));
        for(i=len;i<w*2;i++)
            in[i]=0;
        return i+1;
    }
    return i;
}

