@echo off
SET "_file=%~f1"
IF "%_file%" == "" (GOTO InputRequired)

FOR /F "tokens=1 USEBACKQ" %%F IN (`where ab-av1`) DO (
	SET "_abav1path=%%F"
)

IF "%_abav1path%" == "" (GOTO abav1Miss)
SET "_abav1dir=%_abav1path:ab-av1.exe=%"

FOR /F "tokens=1 USEBACKQ" %%F IN (`where /r %_abav1dir% vmaf_v?.?.?.json`) DO (
	SET "_vmafmodel=%%F"
)

IF "%_vmafmodel%" == "" (GOTO VmafModelRequired)

SET "_linuxvmafmodel=%_vmafmodel:\=/%"

CALL SET "_linuxvmafmodelR=%%_linuxvmafmodel::=\:%%"


SET /P "_arg=If you want to pass an argument to ab-av1 write now (like: --min-vmaf <MIN_VMAF>)"
FOR %%G IN (12 10 8 6 4) DO (
	echo =^> preset %%G
	ab-av1 crf-search -i "%_file%" --preset %%G --vmaf '"model_path=%_linuxvmafmodelR%"' %_arg%
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
