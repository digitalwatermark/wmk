/********************************************************************************
** Form generated from reading UI file 'mainwindow.ui'
**
** Created by: Qt User Interface Compiler version 5.6.0
**
** WARNING! All changes made in this file will be lost when recompiling UI file!
********************************************************************************/

#ifndef UI_MAINWINDOW_H
#define UI_MAINWINDOW_H

#include <QtCore/QVariant>
#include <QtWidgets/QAction>
#include <QtWidgets/QApplication>
#include <QtWidgets/QButtonGroup>
#include <QtWidgets/QCheckBox>
#include <QtWidgets/QComboBox>
#include <QtWidgets/QHBoxLayout>
#include <QtWidgets/QHeaderView>
#include <QtWidgets/QLabel>
#include <QtWidgets/QLineEdit>
#include <QtWidgets/QMainWindow>
#include <QtWidgets/QMenuBar>
#include <QtWidgets/QProgressBar>
#include <QtWidgets/QPushButton>
#include <QtWidgets/QRadioButton>
#include <QtWidgets/QSlider>
#include <QtWidgets/QStatusBar>
#include <QtWidgets/QTextEdit>
#include <QtWidgets/QToolBar>
#include <QtWidgets/QWidget>
#include "qwt_plot.h"

QT_BEGIN_NAMESPACE

class Ui_MainWindow
{
public:
    QWidget *centralWidget;
    QPushButton *StartButton;
    QPushButton *StopButton;
    QLineEdit *PnPowerEdit;
    QLabel *label;
    QSlider *GSlider;
    QLabel *GLabel;
    QLabel *label_SniG;
    QSlider *ASFminSlider;
    QLabel *ASFminLable;
    QLabel *label_3;
    QSlider *ASFmaxSlider;
    QLabel *ASFmaxLable;
    QLabel *label_4;
    QCheckBox *WMAddCheckBox;
    QwtPlot *PNaddMUSICqwtPlot;
    QComboBox *NAMEComboBox;
    QComboBox *NUMComboBox;
    QLabel *label_5;
    QLabel *label_6;
    QComboBox *SmpRateComboBox;
    QLabel *label_2;
    QRadioButton *File_radioButton;
    QPushButton *MusicFileButton;
    QLineEdit *Music_FilePathEdit;
    QWidget *layoutWidget;
    QHBoxLayout *horizontalLayout;
    QLabel *label_7;
    QProgressBar *progressBar_wavfile;
    QPushButton *PnFileButton;
    QLineEdit *Pn_FilePathEdit;
    QLineEdit *OnePnFrameEdit;
    QLabel *RunningLabel;
    QRadioButton *Analog_radioButton;
    QLabel *TimeLabel;
    QLabel *label_10;
    QTextEdit *INPUT_textEdit;
    QMenuBar *menuBar;
    QToolBar *mainToolBar;
    QStatusBar *statusBar;

    void setupUi(QMainWindow *MainWindow)
    {
        if (MainWindow->objectName().isEmpty())
            MainWindow->setObjectName(QStringLiteral("MainWindow"));
        MainWindow->resize(1045, 518);
        centralWidget = new QWidget(MainWindow);
        centralWidget->setObjectName(QStringLiteral("centralWidget"));
        StartButton = new QPushButton(centralWidget);
        StartButton->setObjectName(QStringLiteral("StartButton"));
        StartButton->setGeometry(QRect(561, 400, 72, 23));
        StopButton = new QPushButton(centralWidget);
        StopButton->setObjectName(QStringLiteral("StopButton"));
        StopButton->setGeometry(QRect(720, 400, 72, 23));
        PnPowerEdit = new QLineEdit(centralWidget);
        PnPowerEdit->setObjectName(QStringLiteral("PnPowerEdit"));
        PnPowerEdit->setGeometry(QRect(920, 130, 61, 20));
        label = new QLabel(centralWidget);
        label->setObjectName(QStringLiteral("label"));
        label->setGeometry(QRect(860, 130, 48, 16));
        GSlider = new QSlider(centralWidget);
        GSlider->setObjectName(QStringLiteral("GSlider"));
        GSlider->setGeometry(QRect(31, 119, 19, 181));
        GSlider->setOrientation(Qt::Vertical);
        GLabel = new QLabel(centralWidget);
        GLabel->setObjectName(QStringLiteral("GLabel"));
        GLabel->setGeometry(QRect(31, 101, 61, 16));
        label_SniG = new QLabel(centralWidget);
        label_SniG->setObjectName(QStringLiteral("label_SniG"));
        label_SniG->setGeometry(QRect(31, 310, 24, 16));
        ASFminSlider = new QSlider(centralWidget);
        ASFminSlider->setObjectName(QStringLiteral("ASFminSlider"));
        ASFminSlider->setGeometry(QRect(160, 119, 19, 181));
        ASFminSlider->setOrientation(Qt::Vertical);
        ASFminLable = new QLabel(centralWidget);
        ASFminLable->setObjectName(QStringLiteral("ASFminLable"));
        ASFminLable->setGeometry(QRect(160, 101, 31, 16));
        label_3 = new QLabel(centralWidget);
        label_3->setObjectName(QStringLiteral("label_3"));
        label_3->setGeometry(QRect(150, 310, 41, 16));
        ASFmaxSlider = new QSlider(centralWidget);
        ASFmaxSlider->setObjectName(QStringLiteral("ASFmaxSlider"));
        ASFmaxSlider->setGeometry(QRect(240, 119, 19, 181));
        ASFmaxSlider->setOrientation(Qt::Vertical);
        ASFmaxLable = new QLabel(centralWidget);
        ASFmaxLable->setObjectName(QStringLiteral("ASFmaxLable"));
        ASFmaxLable->setGeometry(QRect(240, 101, 31, 16));
        label_4 = new QLabel(centralWidget);
        label_4->setObjectName(QStringLiteral("label_4"));
        label_4->setGeometry(QRect(230, 310, 41, 16));
        WMAddCheckBox = new QCheckBox(centralWidget);
        WMAddCheckBox->setObjectName(QStringLiteral("WMAddCheckBox"));
        WMAddCheckBox->setGeometry(QRect(860, 70, 91, 21));
        PNaddMUSICqwtPlot = new QwtPlot(centralWidget);
        PNaddMUSICqwtPlot->setObjectName(QStringLiteral("PNaddMUSICqwtPlot"));
        PNaddMUSICqwtPlot->setGeometry(QRect(330, 100, 491, 241));
        NAMEComboBox = new QComboBox(PNaddMUSICqwtPlot);
        NAMEComboBox->setObjectName(QStringLiteral("NAMEComboBox"));
        NAMEComboBox->setGeometry(QRect(10, 210, 69, 20));
        NUMComboBox = new QComboBox(PNaddMUSICqwtPlot);
        NUMComboBox->setObjectName(QStringLiteral("NUMComboBox"));
        NUMComboBox->setGeometry(QRect(90, 210, 69, 22));
        label_5 = new QLabel(centralWidget);
        label_5->setObjectName(QStringLiteral("label_5"));
        label_5->setGeometry(QRect(70, 290, 54, 12));
        label_6 = new QLabel(centralWidget);
        label_6->setObjectName(QStringLiteral("label_6"));
        label_6->setGeometry(QRect(70, 200, 54, 12));
        SmpRateComboBox = new QComboBox(centralWidget);
        SmpRateComboBox->setObjectName(QStringLiteral("SmpRateComboBox"));
        SmpRateComboBox->setGeometry(QRect(920, 160, 61, 20));
        label_2 = new QLabel(centralWidget);
        label_2->setObjectName(QStringLiteral("label_2"));
        label_2->setGeometry(QRect(861, 160, 36, 16));
        File_radioButton = new QRadioButton(centralWidget);
        File_radioButton->setObjectName(QStringLiteral("File_radioButton"));
        File_radioButton->setGeometry(QRect(860, 50, 89, 16));
        MusicFileButton = new QPushButton(centralWidget);
        MusicFileButton->setObjectName(QStringLiteral("MusicFileButton"));
        MusicFileButton->setGeometry(QRect(30, 40, 75, 23));
        Music_FilePathEdit = new QLineEdit(centralWidget);
        Music_FilePathEdit->setObjectName(QStringLiteral("Music_FilePathEdit"));
        Music_FilePathEdit->setGeometry(QRect(111, 40, 651, 20));
        layoutWidget = new QWidget(centralWidget);
        layoutWidget->setObjectName(QStringLiteral("layoutWidget"));
        layoutWidget->setGeometry(QRect(31, 391, 179, 22));
        horizontalLayout = new QHBoxLayout(layoutWidget);
        horizontalLayout->setSpacing(6);
        horizontalLayout->setContentsMargins(11, 11, 11, 11);
        horizontalLayout->setObjectName(QStringLiteral("horizontalLayout"));
        horizontalLayout->setContentsMargins(0, 0, 0, 0);
        label_7 = new QLabel(layoutWidget);
        label_7->setObjectName(QStringLiteral("label_7"));

        horizontalLayout->addWidget(label_7);

        progressBar_wavfile = new QProgressBar(layoutWidget);
        progressBar_wavfile->setObjectName(QStringLiteral("progressBar_wavfile"));
        progressBar_wavfile->setValue(24);

        horizontalLayout->addWidget(progressBar_wavfile);

        PnFileButton = new QPushButton(centralWidget);
        PnFileButton->setObjectName(QStringLiteral("PnFileButton"));
        PnFileButton->setGeometry(QRect(40, 40, 51, 16));
        Pn_FilePathEdit = new QLineEdit(centralWidget);
        Pn_FilePathEdit->setObjectName(QStringLiteral("Pn_FilePathEdit"));
        Pn_FilePathEdit->setGeometry(QRect(260, 40, 21, 20));
        OnePnFrameEdit = new QLineEdit(centralWidget);
        OnePnFrameEdit->setObjectName(QStringLiteral("OnePnFrameEdit"));
        OnePnFrameEdit->setGeometry(QRect(919, 220, 61, 20));
        RunningLabel = new QLabel(centralWidget);
        RunningLabel->setObjectName(QStringLiteral("RunningLabel"));
        RunningLabel->setGeometry(QRect(30, 420, 311, 16));
        Analog_radioButton = new QRadioButton(centralWidget);
        Analog_radioButton->setObjectName(QStringLiteral("Analog_radioButton"));
        Analog_radioButton->setGeometry(QRect(860, 30, 89, 16));
        TimeLabel = new QLabel(centralWidget);
        TimeLabel->setObjectName(QStringLiteral("TimeLabel"));
        TimeLabel->setGeometry(QRect(860, 100, 151, 16));
        label_10 = new QLabel(centralWidget);
        label_10->setObjectName(QStringLiteral("label_10"));
        label_10->setGeometry(QRect(850, 220, 61, 20));
        INPUT_textEdit = new QTextEdit(centralWidget);
        INPUT_textEdit->setObjectName(QStringLiteral("INPUT_textEdit"));
        INPUT_textEdit->setGeometry(QRect(850, 260, 141, 31));
        MainWindow->setCentralWidget(centralWidget);
        OnePnFrameEdit->raise();
        Pn_FilePathEdit->raise();
        PnFileButton->raise();
        layoutWidget->raise();
        StartButton->raise();
        StopButton->raise();
        PnPowerEdit->raise();
        label->raise();
        GSlider->raise();
        GLabel->raise();
        label_SniG->raise();
        ASFminSlider->raise();
        ASFminLable->raise();
        label_3->raise();
        ASFmaxSlider->raise();
        ASFmaxLable->raise();
        label_4->raise();
        WMAddCheckBox->raise();
        PNaddMUSICqwtPlot->raise();
        label_5->raise();
        label_6->raise();
        SmpRateComboBox->raise();
        label_2->raise();
        File_radioButton->raise();
        MusicFileButton->raise();
        Music_FilePathEdit->raise();
        RunningLabel->raise();
        Analog_radioButton->raise();
        TimeLabel->raise();
        label_10->raise();
        INPUT_textEdit->raise();
        menuBar = new QMenuBar(MainWindow);
        menuBar->setObjectName(QStringLiteral("menuBar"));
        menuBar->setGeometry(QRect(0, 0, 1045, 23));
        MainWindow->setMenuBar(menuBar);
        mainToolBar = new QToolBar(MainWindow);
        mainToolBar->setObjectName(QStringLiteral("mainToolBar"));
        MainWindow->addToolBar(Qt::TopToolBarArea, mainToolBar);
        statusBar = new QStatusBar(MainWindow);
        statusBar->setObjectName(QStringLiteral("statusBar"));
        MainWindow->setStatusBar(statusBar);

        retranslateUi(MainWindow);

        QMetaObject::connectSlotsByName(MainWindow);
    } // setupUi

    void retranslateUi(QMainWindow *MainWindow)
    {
        MainWindow->setWindowTitle(QApplication::translate("MainWindow", "MainWindow", 0));
        StartButton->setText(QApplication::translate("MainWindow", "Run", 0));
        StopButton->setText(QApplication::translate("MainWindow", "Stop", 0));
        label->setText(QApplication::translate("MainWindow", "\346\260\264\345\215\260\345\212\237\347\216\207", 0));
        GLabel->setText(QApplication::translate("MainWindow", "0.1", 0));
        label_SniG->setText(QApplication::translate("MainWindow", "SniG", 0));
        ASFminLable->setText(QApplication::translate("MainWindow", "5", 0));
        label_3->setText(QApplication::translate("MainWindow", "Asfmin", 0));
        ASFmaxLable->setText(QApplication::translate("MainWindow", "10", 0));
        label_4->setText(QApplication::translate("MainWindow", "Asfmax", 0));
        WMAddCheckBox->setText(QApplication::translate("MainWindow", "  \346\267\273\345\212\240\346\260\264\345\215\260", 0));
        label_5->setText(QApplication::translate("MainWindow", "\347\264\247\346\200\245\346\216\250\351\200\201", 0));
        label_6->setText(QApplication::translate("MainWindow", "\346\240\207\345\207\206\347\212\266\346\200\201", 0));
        label_2->setText(QApplication::translate("MainWindow", "\351\207\207\346\240\267\347\216\207", 0));
        File_radioButton->setText(QApplication::translate("MainWindow", "  \346\226\207\344\273\266", 0));
        MusicFileButton->setText(QApplication::translate("MainWindow", "\351\237\263\351\242\221\346\226\207\344\273\266", 0));
        label_7->setText(QApplication::translate("MainWindow", "\346\226\207\344\273\266\345\244\204\347\220\206\350\277\233\345\272\246\357\274\232", 0));
        PnFileButton->setText(QApplication::translate("MainWindow", "\346\260\264\345\215\260\346\226\207\344\273\266", 0));
        RunningLabel->setText(QString());
        Analog_radioButton->setText(QApplication::translate("MainWindow", "  \345\243\260\345\215\241", 0));
        TimeLabel->setText(QString());
        label_10->setText(QApplication::translate("MainWindow", "\345\215\225\346\260\264\345\215\260\345\270\247\346\225\260", 0));
    } // retranslateUi

};

namespace Ui {
    class MainWindow: public Ui_MainWindow {};
} // namespace Ui

QT_END_NAMESPACE

#endif // UI_MAINWINDOW_H
