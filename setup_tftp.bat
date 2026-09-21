@echo off

REM set TFTPDIR=C:\TFTP
REM set SYSLINUX_URL=https://mirrors.edge.kernel.org/pub/linux/utils/boot/syslinux/6.03/syslinux-6.03.zip
set DEBIAN_BASE=https://deb.debian.org/debian/dists/stable/main/installer-amd64/current/images/netboot/debian-installer/amd64

echo Preparation du dossier TFTP 
if not exist C:\TFTP mkdir C:\TFTP
if not exist C:\TFTP\pxelinux.cfg mkdir C:\TFTP\pxelinux.cfg

echo Telechargement de pxelinux.0 
curl -L -o "C:\TFTP\pxelinux.0" "https://deb.debian.org/debian/dists/stable/main/installer-amd64/current/images/netboot/debian-installer/amd64/pxelinux.0"
if ERRORLEVEL 1 goto erreur

echo  Telechargement du noyau et de l'initrd Debian 
curl -L -o "C:\TFTP\vmlinuz" "%DEBIAN_BASE%/linux"
if ERRORLEVEL 1 goto erreur
curl -L -o "C:\TFTP\initrd.gz" "%DEBIAN_BASE%/initrd.gz"
if ERRORLEVEL 1 goto erreur

echo Creation du fichier pxelinux.cfg\default 
(
    echo DEFAULT debian
    echo LABEL debian
    echo     KERNEL vmlinuz
    echo     APPEND initrd=initrd.gz
) > C:\TFTP\pxelinux.cfg\default

echo Termine 
dir C:\TFTP
exit /b 0

:erreur
echo Erreur lors du telechargement.
exit /b 1