#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#define FRAMEL 8192
#define Npad_Prefix 512

#include <QMainWindow>
#include <Qdebug>
#include <QFileInfo>
#include <QFileDialog>
#include <QFile>
#include <qtextstream.h>
#include <QTextCodec>
#include <QMessageBox>
#include <QByteArray>
#include <QApplication>
#include <QIcon>
#include <QWidget>
#include <QPen>
#include <QtGui>
#include <QLineF>
#include <QPoint>
#include <QAction>
#include <QMenu>
#include <QMenuBar>

#include <string>
using namespace std;

#include <Qwidget>
#include <QLabel>
#include <QSlider>
#include <QCheckBox>

#include <qwt_plot.h>
#include <qwt_plot_layout.h>
#include <qwt_plot_canvas.h>
#include <qwt_plot_renderer.h>
#include <qwt_plot_grid.h>
#include <qwt_plot_histogram.h>
#include <qwt_plot_curve.h>
#include <qwt_plot_zoomer.h>
#include <qwt_plot_panner.h>
#include <qwt_plot_magnifier.h>
#include <qwt_legend.h>
#include <qwt_legend_label.h>
#include <qwt_column_symbol.h>
#include <qwt_series_data.h>
#include <qpen.h>
#include <qwt_symbol.h>
#include <qwt_picker_machine.h>
//#include <qelapsedtimer.h>
#include <QThread>

namespace Ui {
class MainWindow;
}

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    explicit MainWindow(QWidget *parent = 0);
    ~MainWindow();

private slots:

    void on_StartButton_clicked();

    void on_StopButton_clicked();

    void on_PnFileButton_clicked();

    void on_PnPowerEdit_editingFinished();

    void on_GSlider_sliderMoved(int position);

    void on_ASFminSlider_sliderMoved(int position);

    void on_ASFmaxSlider_sliderMoved(int position);

    void on_WMAddCheckBox_clicked(bool checked);

    void EmbedSlot();
    void DetectSlot();

    void on_SmpRateComboBox_activated(int index);

    void on_File_radioButton_clicked(bool checked);

    void on_MusicFileButton_clicked();

    void on_NAMEComboBox_currentIndexChanged(int index);

    void on_NUMComboBox_currentIndexChanged(int index);

    void on_OnePnFrameEdit_editingFinished();

    void on_Analog_radioButton_clicked(bool checked);

public slots:

    void timerEvent( QTimerEvent * );

private:
    Ui::MainWindow *ui;

    //void createAction();        //创建动作
    //void createMenu();          //创建菜单
    //void createContentMenu();   //创建右键快捷菜单
    QAction *EmbedAction;    //动作
    QAction *DetectAction;   //动作
    QMenu *menu;                //菜单
};

#endif // MAINWINDOW_H

void pn_in();
