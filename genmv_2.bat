@echo off

set NOM=Debian1
set OSTYPE=Debian_64
set RAM=4096
set DISK=65536
set VMDIR=C:\Users\Wafa\VirtualBoxVMs\%NOM%
set VDI=%VMDIR%\%NOM%.vdi
set NOM_Q="%NOM%"


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


VBoxManage unregistervm %NOM% --delete
if ERRORLEVEL 1 goto erreur

exit /b 0

:erreur
echo Erreur lors de l'éxecution dúne commande VBoxManage.
exit /b 1

