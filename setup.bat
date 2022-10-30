@ECHO OFF
FOR /F "tokens=* USEBACKQ" %%F IN (`py --version`) DO (
SET PYVERSION=%%F
)
ECHO %PYVERSION%
SET /p pyexist= "Does the above prompt say Python 3.10.x? [y/n] : "
IF "%pyexist%"=="n" (
    GOTO NeedInstall
) ELSE (
    GOTO EnvSetup
)

:NeedInstall
SET /p needinstall= "Does Python 3.10 need to be installed? [y/n] : "
IF "%needinstall%"=="y"  GOTO GetPython
IF "%needinstall%"=="n"  GOTO FindPython

:FindPython
ECHO Looking for available Python 3.10 installations
FOR /F "tokens=* USEBACKQ" %%F IN (`DIR /S C:\python.exe ^| FINDSTR /e Python310`) DO (
SET pydir=%%F
)
SET pydir=%pydir:Directory of =%
SET py310=%pydir%\python.exe
GOTO EnvSetup

:EnvSetup
IF [%pydir%]==[] SET py310=py
%py310% -m virtualenv venv && venv\Scripts\activate.bat && pip install -r packages.txt && DOSKEY app=py app.py $*
if %ERRORLEVEL% neq 0 GOTO ProcessError

:ProcessError
%py310% -m venv venv && venv\Scripts\activate.bat && pip install -r packages.txt && DOSKEY app=py app.py $*

:GetPython
get_python.bat
