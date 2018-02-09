#include "mainwindow.h"
#include "ui_mainwindow.h"
#include "user.h"
#include "mythread.h"

extern    char      *pnopenname_array[PN_NUM];

void pn_in()
{
    int i=0;
    string temp;

    string s1 = "/pn/pn";
    string s3 = ".txt";
    QString file_path = QCoreApplication::applicationDirPath();
    string FilePath = file_path.toStdString();

    for(i=0; i<PN_NUM; i++)
    {
        QString s = QString::number(i+2, 10);
        string s2 = s.toStdString();

        temp = FilePath+s1+s2+s3;
        pnopenname_array[i] = new char[temp.length()+1];
        strcpy(pnopenname_array[i],temp.c_str());
    }
}
