#ifndef MYTHREAD_H
#define MYTHREAD_H

#include <QThread>
class MyThread : public QThread
{
    Q_OBJECT
    public:
        MyThread();
        ~MyThread();
    protected:
        void run();
    signals:
        //void changeText(QString str);
};

#endif // MYTHREAD_H
