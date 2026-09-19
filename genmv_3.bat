@echo off


if "%1"=="" (
	echo Usage: genmv_3.bat [option] [nomVM]
	exit /b 1
)




if "%1"=="L" goto lister

if "%2"=="" (
	echo Usage: genmv_3.bat [option] [nomVM]
	exit /b 1
)

set NOM=%2
set OSTYPE=Debian_64
set RAM=4096
set DISK=65536
set VMDIR=C:\Users\Wafa\VirtualBoxVMs\%NOM%
set VDI=%VMDIR%\%NOM%.vdi
set NOM_Q="%NOM%"

if "%1"=="N" goto nouveau
if "%1"=="S" goto supprimer
if "%1"=="D" goto demarrer
if "%1"=="A" goto arreter
echo Option inconnue: %1
exit /b 1



:lister
VBoxManage list vms
goto fin

:nouveau
VBoxManage list vms > vmlist.txt
set EXISTE=NON
FOR /F "tokens=1" %%a in (vmlist.txt) do (
	if "%%a"=="%NOM_Q%" set EXISTE=OUI
)
if "%EXISTE%"=="OUI" (
	echo VM %NOM% existe deja, suppression...
	VBoxManage unregistervm %NOM% --delete
	if ERRORLEVEL 1 goto erreur
)
VBoxManage createvm --name %NOM% --ostype %OSTYPE% --register
if ERRORLEVEL 1 goto erreur
VBoxManage modifyvm %NOM% --memory %RAM% --nic1 nat
if ERRORLEVEL 1 goto erreur
if not exist "%VMDIR%" mkdir "%VMDIR%"
VBoxManage createmedium disk --filename "%VDI%" --size %DISK% --format VDI
if ERRORLEVEL 1 goto erreur
VBoxManage storagectl %NOM% --name "SATA" --add sata --controller IntelAhci
if ERRORLEVEL 1 goto erreur
VBoxManage storageattach %NOM% --storagectl "SATA" --port 0 --device 0 --type hdd --medium "%VDI%"
if ERRORLEVEL 1 goto erreur
goto fin

:supprimer
VBoxManage unregistervm %NOM% --delete
if ERRORLEVEL 1 goto erreur
goto fin

:demarrer
VBoxManage startvm "%NOM%" --type headless
goto fin

:arreter
VBoxManage controlvm "%NOM%" acpipowerbutton
goto fin


:fin
exit /b 0

:erreur
echo Erreur commande VBoxManage.
exit /b 1

