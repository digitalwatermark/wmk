#-------------------------------------------------
#
# Project created by QtCreator 2016-05-13T14:08:43
#
#-------------------------------------------------

QT       += core gui

LIBS += -lWinmm
INCLUDEPATH += ./include

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

TARGET = WMAnalogWindowQt
TEMPLATE = app

SOURCES += main.cpp\
        mainwindow.cpp \
    source/Analysis_subband_filter.cpp \
    source/ASFfunction.cpp \
    source/Cal_Lsb.cpp \
    source/Cal_psd.cpp \
    source/Cal_scf.cpp \
    source/Cal_Smrsb.cpp \
    source/Cal_T_N_mask.cpp \
    source/dss_sync.cpp \
    source/extractor_acq.cpp \
    source/fft_96db_normalize.cpp \
    source/Finding_Ntonal_component.cpp \
    source/Finding_tonal_component.cpp \
    source/frame_perfix.cpp \
    source/hanning_win.cpp \
    source/Ifft_fft.cpp \
    source/linxcorr_fft.cpp \
    source/Minimum_masking_threshold.cpp \
    source/Music_Piecewise.cpp \
    source/noise_gen.cpp \
    source/noise_masking.cpp \
    source/noise_masking_sub.cpp \
    source/Phycho_layeone.cpp \
    source/PnGen.cpp \
    source/process_acquireddata.cpp \
    source/Scale_factors.cpp \
    source/Sig_Engergy.cpp \
    source/SMR.cpp \
    source/sni_mask.cpp \
    source/Synthesis_subband_filter.cpp \
    source/sys_int.cpp \
    source/table48.cpp \
    source/Tonal_Ntonal_decimate.cpp \
    source/wmk_extrac.cpp \
    source/wmk_gen.cpp \
    source/table441.cpp \
    source/WaveEnd_get.cpp \
    source/Wavehead_get.cpp \
    source/wavwrite.cpp \
    source/psy_top.cpp \
    source/data_convert.cpp \
    mythread.cpp \
    source/analog.cpp \
    source/AnalogIn.cpp \
    source/AnalogOutDataWrite.cpp

HEADERS  += mainwindow.h \
    #include/Analogdefine.h \
    #include/Analogfunction.h \
    include/ifft_fft.h \
    include/user.h \
    include/WMdefine.h \
    include/WMfunction.h \
    mythread.h \
    include/Analogdefine.h \
    include/Analogfunction.h

FORMS    += mainwindow.ui

RC_FILE = abslogo.rc

CONFIG += qwt
DEFINES += QT_DLL QWT_DLL
#LIBS += -L$$PWD/lib/ -l qwtd
LIBS += -L$$PWD/lib/ -l qwt
#INCLUDEPATH += E:/Qt/Qt5.6.0/5.6/mingw49_32/include/QWT
INCLUDEPATH += H:/qt/setup/5.6/mingw49_32/include/QWT
