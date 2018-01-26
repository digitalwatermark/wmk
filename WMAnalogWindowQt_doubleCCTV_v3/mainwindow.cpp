#include "mainwindow.h"
#include "ui_mainwindow.h"
#include "user.h"
#include "mythread.h"

extern    HWAVEIN      m_hWaveIn;
extern    bool		   IsRecord;
extern    _SigInoiseStruct inoise;
extern    _SigInoiseStruct bufferx;
extern    _table    *Param;
extern    _State    State_Switch;
extern    double    SigBufL[FRAMEL+Npad_Prefix+Npad_Prefix];
extern    double    SigBufR[FRAMEL+Npad_Prefix+Npad_Prefix];
extern    double    onoise[FRAMEL+Npad_Prefix+Npad_Prefix];
extern    char      *pnopenname;
extern    char      *pnopenname_array[PN_NUM];
          char      *fileopenname;
extern    float     nmr_gain;
extern    int     one_pn_frame;
extern    double    SniG;
extern    int       ASFmin;
extern    int       ASFmax;
extern    bool      WMAdd;
extern    bool      EmbedOrDetect;
extern    bool      AnalogOrRead;
extern    bool      ThreadState;
extern    int       SmpRate;
extern    FILE      *WaveRdFp;
extern    FILE      *music_with_wm;
extern    int       loopcount;//当前循环次数
extern    bool      ifisrunning;

QwtPlotCurve * pnplot = new QwtPlotCurve("水印");
QwtPlotCurve * musicplot = new QwtPlotCurve("音频");
extern double plotx[FRAMEL];
extern double pny[FRAMEL];
extern double musicy[FRAMEL];

MyThread *mythread = new MyThread;
int TimerID;

MainWindow::MainWindow(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::MainWindow)
{
    ui->setupUi(this);

    setWindowTitle("数字水印嵌入软件");
    //createAction();//创建菜单栏动作
    //createMenu();//创建菜单栏
    //createContentMenu();//右键快捷菜单

    ui->SmpRateComboBox->addItem("48");
    ui->SmpRateComboBox->addItem("44.1");

    ui->NUMComboBox->addItem("CCTV-1");
    ui->NUMComboBox->addItem("CCTV-2");
    ui->NUMComboBox->addItem("CCTV-3");
    ui->NUMComboBox->addItem("CCTV-4");
    ui->NUMComboBox->addItem("CCTV-5");
    ui->NUMComboBox->addItem("CCTV-6");

    ui->NAMEComboBox->addItem("CCTV");

    ui->GSlider->setRange(1,800);
    ui->GSlider->setTickInterval(800);
    ui->GSlider->setOrientation(Qt::Vertical);
    ui->GSlider->setValue(800);
    SniG = 0.8;
    ui->ASFminSlider->setRange(0,31);
    ui->ASFminSlider->setTickInterval(32);
    ui->ASFminSlider->setOrientation(Qt::Vertical);
    ui->ASFminSlider->setValue(5);
    ASFmin = 5;
    ui->ASFmaxSlider->setRange(0,31);
    ui->ASFmaxSlider->setTickInterval(32);
    ui->ASFmaxSlider->setOrientation(Qt::Vertical);
    ui->ASFmaxSlider->setValue(10);
    ASFmin = 10;

    ui->PNaddMUSICqwtPlot->setPalette(Qt::white);//设置画布
    ui->PNaddMUSICqwtPlot->setTitle("数据流实时图像");
    ui->PNaddMUSICqwtPlot->setAxisTitle( QwtPlot::yLeft, "Music" );
    ui->PNaddMUSICqwtPlot->setAxisTitle( QwtPlot::xBottom, "Time" );
    ui->PNaddMUSICqwtPlot->setAxisScale(QwtPlot::yLeft,-0.8,0.8);
    ui->PNaddMUSICqwtPlot->setAxisScale(QwtPlot::xBottom,0,FRAMEL);
    QwtPlotGrid *grid = new QwtPlotGrid;//设置网格线
    grid->enableX( true );
    grid->enableY( true );
    grid->setMajorPen( Qt::black, 0, Qt::DotLine );
    grid->attach( ui->PNaddMUSICqwtPlot );

    ui->progressBar_wavfile->setValue(0);

}

MainWindow::~MainWindow()
{
    delete ui;
}

void MainWindow::on_StartButton_clicked()//按钮run
{   

    if(AnalogOrRead)
    {
        TimerID = this->startTimer(170);
        if(IsRecord == true)
        {}
        else
        {
            pnopenname = pnopenname_array[1];
            PnGen(inoise);

            IsRecord=true;

            AnalogInit();//声卡驱动参数初始化
            waveInStart(m_hWaveIn);//开始录音
        }
    }
    else if(!AnalogOrRead)
    {
        if(WaveRdFp==NULL || music_with_wm==NULL)
            MessageBox(NULL,TEXT("You must select the wav file!"),TEXT("Warning"),MB_OK);
        else
        {
            if(!ThreadState)
            {
                TimerID = this->startTimer(50);
                ThreadState = true;
                mythread->start();
            }
            else
            {}
        }
        ui->RunningLabel->setText("It's running,please wait the success message!");
    }
    else
    {
        MessageBox(NULL,TEXT("You must select an input method!"),TEXT("Warning"),MB_OK);
    }
        ifisrunning = true;
        ui->progressBar_wavfile->setValue(0);


}

void MainWindow::on_StopButton_clicked()//按钮stop
{

    if(AnalogOrRead)
    {
        if(IsRecord == false)
        {}
        else
        {
            IsRecord=false;
            Sleep(3000);

            waveInStop(m_hWaveIn);
            waveInReset(m_hWaveIn);
            waveInClose(m_hWaveIn);
            this->killTimer(TimerID);
        }
    }
    else if(!AnalogOrRead)
    {
        if(ifisrunning)
        {
            mythread->terminate();
            ThreadState = false;
            fclose(music_with_wm);
            fclose(WaveRdFp);
            this->killTimer(TimerID);
            ui->Music_FilePathEdit->clear();
        }
        else
        {}
    }
    else
    {}
        ifisrunning = false;
}

void MainWindow::on_PnFileButton_clicked()//按钮选择Pn序列文件
{
    /*QString  file_path;
    string   FilePath;

    file_path = QFileDialog::getOpenFileName(this);
    ui->Pn_FilePathEdit->setText(file_path);

    FilePath = file_path.toStdString();
    pnopenname = new char[FilePath.length()+1];
    strcpy(pnopenname,FilePath.c_str());

    PnGen(inoise);*/
}

void MainWindow::on_MusicFileButton_clicked()//输入音频文件
{
    if(!ifisrunning)
    {
        QString  file_pathm;
        string   FilePathm;

        file_pathm = QFileDialog::getOpenFileName(this);
        if(file_pathm!=NULL)
        {
            ui->Music_FilePathEdit->setText(file_pathm);

            FilePathm = file_pathm.toStdString();
            fileopenname = new char[FilePathm.length()+1];
            strcpy(fileopenname,FilePathm.c_str());

            wavhead_get(Param);
            ui->progressBar_wavfile->setRange(0,Param->looptime);//文件处理进度条范围
        }
    }
    else
        MessageBox(NULL,TEXT("It's running now!Please wait!"),TEXT("Warning"),MB_OK);
}

void MainWindow::on_PnPowerEdit_editingFinished()//编辑框输入水印功率
{
    QString power;

    power = ui->PnPowerEdit->text();
    nmr_gain = power.toFloat();
}

void MainWindow::on_GSlider_sliderMoved(int position)//G值滑动条
{
    SniG = double(position)/1000;
    QString sg = QString::number(SniG);
    ui->GLabel->setText(sg);
}

void MainWindow::on_ASFminSlider_sliderMoved(int position)//子带最小值滑动条
{
    ASFmin = position;
    QString asfmin = QString::number(ASFmin+1);
    ui->ASFminLable->setText(asfmin);
}

void MainWindow::on_ASFmaxSlider_sliderMoved(int position)//子带最大值滑动条
{
    ASFmax = position;
    QString asfmax = QString::number(ASFmax+1);
    ui->ASFmaxLable->setText(asfmax);
}

void MainWindow::on_WMAddCheckBox_clicked(bool checked)//是否添加水印复选框
{
    WMAdd = checked;
}

void MainWindow::timerEvent( QTimerEvent * )//曲线图实时刷新
{
    musicplot->setSamples(plotx, musicy, FRAMEL);
    musicplot->setPen(Qt::blue);
    musicplot->attach(ui->PNaddMUSICqwtPlot);
    pnplot->setSamples(plotx, pny, FRAMEL);
    pnplot->setPen(Qt::red);
    pnplot->attach(ui->PNaddMUSICqwtPlot);
    ui->PNaddMUSICqwtPlot->replot();
    ui->PNaddMUSICqwtPlot->insertLegend(new QwtLegend(),QwtPlot::RightLegend);

    if(!AnalogOrRead)
        ui->progressBar_wavfile->setValue(loopcount+3);//进度条指示
    if(!ifisrunning)
        ui->RunningLabel->setText(" ");

    if(ThreadState = false)//若执行完毕，则关闭线程
    {
        mythread->terminate();
        this->killTimer(TimerID);
    }
}

/*void MainWindow::createAction()//创建行为，对应菜单栏
{
   EmbedAction = new QAction(tr("嵌入水印"), this);
   //EmbedAction->setShortcut(tr("Ctrl + O"));
   EmbedAction->setStatusTip(tr("选择水印嵌入软件功能"));
   connect(EmbedAction, SIGNAL(triggered()), this, SLOT(EmbedSlot()));

   DetectAction = new QAction(tr("水印检出"), this);
   //DetectAction->setShortcut(tr("Ctrl + Q"));
   DetectAction->setStatusTip(tr("选择水印检出软件功能"));
   connect(DetectAction, SIGNAL(triggered()), this, SLOT(DetectSlot()));
}

void MainWindow::createMenu()//创建菜单栏选项
{
   menu = this->menuBar()->addMenu(tr("功能选择"));
   menu->addAction(EmbedAction);
   menu->addAction(DetectAction);
}*/

/*void MainWindow::createContentMenu()//右键快捷菜单
{
   this->addAction(EmbedAction);
   this->addAction(DetectAction);
   this->setContextMenuPolicy(Qt::ActionsContextMenu);
}*/

void MainWindow::EmbedSlot()//嵌入水印函数
{
    EmbedOrDetect = true;
    ui->WMAddCheckBox->setVisible(true);
    ui->PNaddMUSICqwtPlot->setVisible(true);
    ui->GSlider->setVisible(true);
    ui->ASFminSlider->setVisible(true);
    ui->ASFmaxSlider->setVisible(true);
    ui->GLabel->setVisible(true);
    ui->label_SniG->setVisible(true);
    ui->label_6->setVisible(true);
    ui->label_5->setVisible(true);
    ui->ASFminLable->setVisible(true);
    ui->label_3->setVisible(true);
    ui->ASFmaxLable->setVisible(true);
    ui->label_4->setVisible(true);
}

void MainWindow::DetectSlot()//监测水印函数
{
    EmbedOrDetect = false;
    ui->WMAddCheckBox->setVisible(false);
    ui->PNaddMUSICqwtPlot->setVisible(false);
    ui->GSlider->setVisible(false);
    ui->ASFminSlider->setVisible(false);
    ui->ASFmaxSlider->setVisible(false);
    ui->GLabel->setVisible(false);
    ui->label_SniG->setVisible(false);
    ui->label_6->setVisible(false);
    ui->label_5->setVisible(false);
    ui->ASFminLable->setVisible(false);
    ui->label_3->setVisible(false);
    ui->ASFmaxLable->setVisible(false);
    ui->label_4->setVisible(false);
}

void MainWindow::on_SmpRateComboBox_activated(int index)//采样率选择下拉菜单
{
    SmpRate = index;
  //  QString PNfilePath = "hhhhhhhh";
   // QMessageBox::warning(0,"PATH",PNfilePath,QMessageBox::Yes);
    if(SmpRate == 0)
    {
        table_init48(MODSEL,Param);
    }
    else if(SmpRate == 1)
    {
        table_init441(MODSEL,Param);
    }
}

void MainWindow::on_File_radioButton_clicked(bool checked)//文件读写
{
    AnalogOrRead = !checked;
}

void MainWindow::on_NAMEComboBox_currentIndexChanged(int index)//选择台标
{
    index = index+2;

    string s1 = "/pn/pn";

    QString s = QString::number(index, 10);
    string s2 = s.toStdString();
    string s3 = ".txt";

    QString file_path = QCoreApplication::applicationDirPath();
    string FilePath = file_path.toStdString();

    FilePath = FilePath+s1+s2+s3;
    pnopenname_array[0] = new char[FilePath.length()+1];
    strcpy(pnopenname_array[0],FilePath.c_str());
}

void MainWindow::on_NUMComboBox_currentIndexChanged(int index)//选择台号
{
    index = index+2;

    string s1 = "/pn/pn";

    QString s = QString::number(index, 10);
    string s2 = s.toStdString();
    string s3 = ".txt";

    QString file_path = QCoreApplication::applicationDirPath();
    string FilePath = file_path.toStdString();

    FilePath = FilePath+s1+s2+s3;
    pnopenname_array[1] = new char[FilePath.length()+1];
    strcpy(pnopenname_array[1],FilePath.c_str());

    //PnGen(inoise);*/
}

void MainWindow::on_OnePnFrameEdit_editingFinished()//选择每个pn嵌入的帧数
{
    QString frame;

    frame = ui->OnePnFrameEdit->text();
    one_pn_frame = frame.toInt();
}
