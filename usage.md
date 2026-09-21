# Automatisation de création de VM VirtualBox

**Auteurs :** Wafa Zenasni, Ikram Atqaoui 

## Résumé

Scripts `genmv_X.bat` pilotant `VBoxManage` pour créer, lister, démarrer, arrêter et supprimer des VM sous Windows.\
Versionné de façon incrémentale (v1 à v5).\
Ce document décrit l'installation, l'usage, les limites de ce projet.

## Prérequis

- VirtualBox installé (testé avec 7.2.6)
- `C:\Program Files\Oracle\VirtualBox` ajouté au PATH utilisateur
- Lancer les scripts depuis **cmd.exe** (pas PowerShell)
- Ne pas mettre de caractères ni d'espaces dans le nom de la VM (voir Limites)

## Installation

Lancer la commande: git clone https://github.com/zenaswa/projet-vbox.git \
Tester le fonctionnement de VBoxManage dans le repo.

## Usage

| Commande | Action |
|----------|--------|
| `genmv_4.bat L` | Liste les VM + métadonnées |
| `genmv_4.bat N <nom>` | Crée une VM |
| `genmv_4.bat S <nom>` | Supprime |
| `genmv_4.bat D <nom>` | Démarre |
| `genmv_4.bat A <nom>` | Arrête |

Exemples concrets ci-dessous.
```cmd
C:\Users\Wafa\Documents\cours\projet-vbox>genmv_4.bat N debianServ
Virtual machine 'debianServ' is created and registered.
UUID: 2416531a-0a08-474d-82f1-864f399163f6
Settings file: 'C:\Users\Wafa\VirtualBox VMs\debianServ\debianServ.vbox'
0%...10%...20%...30%...40%...50%...60%...70%...80%...90%...100%
Medium created. UUID: 54df09cf-fc52-4d53-b572-9ccaa1569891
```
```cmd
C:\Users\Wafa\Documents\cours\projet-vbox>genmv_4.bat S serv3
0%...10%...20%...30%...40%...50%...60%...70%...80%...90%...100%
```
```cmd
C:\Users\Wafa\Documents\cours\projet-vbox>genmv_4.bat L
"serv11"
Key: created_by, Value: Wafa
Key: creation_date, Value: 21/09/2026

"serv33"
Key: created_by, Value: Wafa
Key: creation_date, Value: 21/09/2026

"serv22"
Key: created_by, Value: Wafa
Key: creation_date, Value: 21/09/2026

"debianServ"
Key: created_by, Value: Wafa
Key: creation_date, Value: 21/09/2026
```
## Limites connues

- Pas de guillemets ni d'espaces dans `<nom>` — casse les chemins.
- Les VM créées manuellement n'ont pas de métadonnées.
- `A` envoie un signal ACPI : sur VM sans OS, ne l'éteint pas réellement.

## Version 5 - Démarrage PXE

La version `genmv_5.bat` ajoute la configuration du démarrage réseau PXE.

Lors de la création d'une VM :
- le démarrage réseau est configuré en priorité ;
- l'interface réseau utilise le mode NAT ;
- le serveur TFTP intégré de VirtualBox est activé ;
- l'adresse du serveur TFTP est `10.0.2.4` ;
- le répertoire TFTP utilisé est `C:\TFTP` ;
- le fichier de démarrage PXE est `pxelinux.0`.

Les paramètres principaux restent :
- système : Debian 64 bits ;
- RAM : 4096 Mo ;
- disque : 65536 Mo.


## Astuces techniques

- Redirection `>` + `FOR /F "tokens=1"` pour parser `list vms`
- Flag `EXISTE=NON/OUI` pour la vérification d'idempotence
- `setextradata` / `getextradata` pour les métadonnées
- Variables `RAM`, `DISK`, `OSTYPE` en tête de script

## Développements futurs

- Support des noms entre guillemets et avec espaces via `%~2`