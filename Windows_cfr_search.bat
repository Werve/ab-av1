@echo off
SET "_file=%~f1"
IF "%_file%" == "" (GOTO InputRequired)

FOR /F "tokens=1 USEBACKQ" %%F IN (`where ab-av1`) DO (
	SET "_abav1path=%%F"
)
REM echo %_abav1path%
IF "%_abav1path%" == "" (GOTO abav1Miss)
SET "_abav1dir=%_abav1path:ab-av1.exe=%"
echo %_abav1dir%
FOR /F "tokens=1 USEBACKQ" %%F IN (`where /r %_abav1dir% vmaf_v?.?.?.json`) DO (
	SET "_vmafmodel=%%F"
)
REM echo %_vmafmodel%
IF "%_vmafmodel%" == "" (GOTO VmafModelRequired)

SET "_linuxvmafmodel=%_vmafmodel:\=/%"
REM echo %_linuxvmafmodel%
CALL SET "_linuxvmafmodelR=%%_linuxvmafmodel::=\:%%"
REM echo %_linuxvmafmodelR%

REM echo %_file%
REM GOTO InputRequired
FOR %%G IN (12 10 8 6 4) DO (
	echo =^> preset %%G
	ab-av1 crf-search -i "%_file%" --preset %%G --vmaf '"model_path=%_linuxvmafmodelR%"'
)
pause
exit /b

:InputRequired
echo The video file was not an argument, please try again.
pause

:abav1Miss
echo ab-av1 not found
pause

:VmafModelRequired
echo Vmaf model not found in the directory where ab-av1 is located: %_abav1path%
pause
