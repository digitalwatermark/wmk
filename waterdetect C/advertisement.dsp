# Microsoft Developer Studio Project File - Name="advertisement" - Package Owner=<4>
# Microsoft Developer Studio Generated Build File, Format Version 6.00
# ** DO NOT EDIT **

# TARGTYPE "Win32 (x86) Application" 0x0101

CFG=advertisement - Win32 Release_R
!MESSAGE This is not a valid makefile. To build this project using NMAKE,
!MESSAGE use the Export Makefile command and run
!MESSAGE 
!MESSAGE NMAKE /f "advertisement.mak".
!MESSAGE 
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "advertisement.mak" CFG="advertisement - Win32 Release_R"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "advertisement - Win32 Debug_R" (based on "Win32 (x86) Application")
!MESSAGE "advertisement - Win32 Release_R" (based on "Win32 (x86) Application")
!MESSAGE 

# Begin Project
# PROP AllowPerConfigDependencies 0
# PROP Scc_ProjName ""
# PROP Scc_LocalPath ""
CPP=cl.exe
MTL=midl.exe
RSC=rc.exe

!IF  "$(CFG)" == "advertisement - Win32 Debug_R"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 1
# PROP BASE Output_Dir "advertisement___Win32_Debug_R"
# PROP BASE Intermediate_Dir "advertisement___Win32_Debug_R"
# PROP BASE Ignore_Export_Lib 0
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 1
# PROP Output_Dir "advertisement_Debug_R"
# PROP Intermediate_Dir "advertisement_Debug_R"
# PROP Ignore_Export_Lib 0
# PROP Target_Dir ""
# ADD BASE CPP /nologo /W3 /Gm /GX /ZI /Od /D "WIN32" /D "_DEBUG" /D "_WINDOW" /D "_MBCS" /D "_RATE48000" /D "_AD_EMBEDDER" /YX /FD /GZ /c
# ADD CPP /nologo /W3 /Gm /GX /ZI /Od /D "WIN32" /D "_DEBUG" /D "_WINDOW" /D "_MBCS" /D "_RATE48000" /D "_AD_EXTRACTOR" /YX /FD /GZ /c
# ADD BASE MTL /nologo /D "_DEBUG" /mktyplib203 /win32
# ADD MTL /nologo /D "_DEBUG" /mktyplib203 /win32
# ADD BASE RSC /l 0x804 /d "_DEBUG"
# ADD RSC /l 0x804 /d "_DEBUG"
BSC32=bscmake.exe
# ADD BASE BSC32 /o"advertisement_Debug_Ex/advertisement.bsc"
# SUBTRACT BASE BSC32 /nologo
# ADD BSC32 /o"advertisement_Debug_Ex/advertisement.bsc"
# SUBTRACT BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /subsystem:console /pdb:none /map /debug /debugtype:both /machine:I386 /out:"advertisement_Debug_T/advertisement.exe"
# SUBTRACT BASE LINK32 /nologo /verbose /nodefaultlib
# ADD LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /subsystem:console /pdb:none /map /debug /debugtype:both /machine:I386
# SUBTRACT LINK32 /nologo /verbose /nodefaultlib

!ELSEIF  "$(CFG)" == "advertisement - Win32 Release_R"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 1
# PROP BASE Output_Dir "advertisement___Win32_Release_R"
# PROP BASE Intermediate_Dir "advertisement___Win32_Release_R"
# PROP BASE Ignore_Export_Lib 0
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 1
# PROP Output_Dir "advertisement_Release_R"
# PROP Intermediate_Dir "advertisement_Release_R"
# PROP Ignore_Export_Lib 0
# PROP Target_Dir ""
# ADD BASE CPP /nologo /W3 /Gm /GX /ZI /Od /D "WIN32" /D "_DEBUG" /D "_WINDOW" /D "_MBCS" /D "_RATE48000" /D "_AD_EXTRACTOR" /YX /FD /GZ /c
# ADD CPP /nologo /G6 /W3 /Gm /GX /ZI /Od /D "WIN32" /D "NDEBUG" /D "_WINDOW" /D "_MBCS" /D "_RATE48000" /D "_AD_EXTRACTOR" /YX /FD /GZ /c
# ADD BASE MTL /nologo /D "_DEBUG" /mktyplib203 /win32
# ADD MTL /nologo /D "_DEBUG" /mktyplib203 /win32
# ADD BASE RSC /l 0x804 /d "_DEBUG"
# ADD RSC /l 0x804 /d "NDEBUG"
BSC32=bscmake.exe
# ADD BASE BSC32 /o"advertisement_Debug_Ex/advertisement.bsc"
# SUBTRACT BASE BSC32 /nologo
# ADD BSC32 /o"advertisement_Debug_Ex/advertisement.bsc"
# SUBTRACT BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /subsystem:console /pdb:none /map /debug /debugtype:both /machine:I386 /out:"advertisement_Debug_R/advertisement.exe"
# SUBTRACT BASE LINK32 /nologo /verbose /nodefaultlib
# ADD LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /subsystem:console /pdb:none /map /debug /debugtype:both /machine:I386
# SUBTRACT LINK32 /nologo /verbose /nodefaultlib

!ENDIF 

# Begin Target

# Name "advertisement - Win32 Debug_R"
# Name "advertisement - Win32 Release_R"
# Begin Group "Source Files"

# PROP Default_Filter "cpp;c;cxx;rc;def;r;odl;idl;hpj;bat"
# Begin Group "Cal_Int"

# PROP Default_Filter ""
# Begin Source File

SOURCE=.\source\sys_int.cpp
# End Source File
# Begin Source File

SOURCE=.\source\Wave_Rd.cpp
# End Source File
# Begin Source File

SOURCE=.\source\Wavehead_get.cpp
# End Source File
# End Group
# Begin Group "ad_extractor"

# PROP Default_Filter ""
# Begin Source File

SOURCE=.\array_max.cpp
# End Source File
# Begin Source File

SOURCE=.\source\data_convert.cpp
# End Source File
# Begin Source File

SOURCE=.\source\dss_sync.cpp
# End Source File
# Begin Source File

SOURCE=.\source\filter.cpp
# End Source File
# Begin Source File

SOURCE=.\source\filter_aligned.cpp
# End Source File
# Begin Source File

SOURCE=.\source\Ifft_fft.cpp
# End Source File
# Begin Source File

SOURCE=.\source\linxcorr_fft.cpp
# End Source File
# Begin Source File

SOURCE=.\source\process_acquireddata.cpp
# End Source File
# Begin Source File

SOURCE=.\source\Sig_Engergy.cpp
# End Source File
# Begin Source File

SOURCE=.\source\wmk_extrac.cpp
# End Source File
# End Group
# Begin Source File

SOURCE=.\source\psy_top.cpp
# End Source File
# Begin Source File

SOURCE=.\source\State_Switchini.cpp
# End Source File
# End Group
# Begin Group "Header Files"

# PROP Default_Filter "h;hpp;hxx;hm;inl"
# Begin Source File

SOURCE=.\include\define.h
# End Source File
# Begin Source File

SOURCE=.\include\function.h
# End Source File
# Begin Source File

SOURCE=.\include\ifft_fft.h
# End Source File
# Begin Source File

SOURCE=.\include\user.h
# End Source File
# End Group
# Begin Group "Resource Files"

# PROP Default_Filter "ico;cur;bmp;dlg;rc2;rct;bin;rgs;gif;jpg;jpeg;jpe"
# End Group
# Begin Source File

SOURCE=.\source\Wave_Wr.asp
# End Source File
# End Target
# End Project
