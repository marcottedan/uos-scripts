REM !!!!!!!!!!!!!!!!!!!!!!!!!
REM Run this as Administrator
REM !!!!!!!!!!!!!!!!!!!!!!!!!
@echo off

REM Your Git Clone folder here
set "GitCloneDir=C:\Users\marco\git\uos-scripts"

REM The place where you installed UO Sagas (base directory with trailing "\")
set "UOSagasDir=C:\Program Files\Ultima Online - Sagas\"


set "ScriptDir=%UOSagasDir%ClassicUO\Data\Profiles\Scripts"
set "ScriptDirBak=%UOSagasDir%ClassicUO\Data\Profiles\Scripts_Bak"

REM If "Scripts" already exists, rename it to "Scripts_Bak"
if exist "%ScriptDir%" (
    echo Renaming existing Scripts folder to "Scripts_Bak"...
    ren "%ScriptDir%" "Scripts_Bak"
    echo Renamed existing folder successfully.
)

REM Create new symlink
mklink /D "%ScriptDir%" "%GitCloneDir%"

REM Validate symlink creation
echo ................................................
if exist "%ScriptDir%" (
    echo Symlink created successfully.
) else (
    echo Failed to create symlink. Verify paths and run as administrator.
)
echo ................................................

pause