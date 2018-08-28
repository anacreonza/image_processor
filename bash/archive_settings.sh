#!/bin/bash

# Settings file for archiving script

# Working folder for archiving
WRK="/Users/stuart.kinnear/Desktop/ArchiveWork"

# SmartMover source server
SMARTMOVER_SOURCE="smb://02auc-wwap04/SmartMover temp/"

# Fotoware server
FOTOWARE_SERVER="smb://02auc-fws01new/Images3/"

# Source and destination folders for each title
# BRANDSRC = Source folder on SmartMover output
# BRANDDEST = Destination folder on brand's own server / external
# BRANDFWDEST = Destination folder inside brand's Fotoware archive

YPSRC="/Volumes/SmartMover temp/YourPregnancyArchive/YOUR PREGNANCY/Archived/print/"
YPDEST="/Volumes/Alchemy/Your Pregnancy/Archive/"
YPFWDEST="/Volumes/Images3/WOMENS/YOUR PREGNANCY/JPG/"

YBSRC="/Volumes/SmartMover temp/YourBabyArchive/YOUR BABY/Archived/print/"
YBDEST="/Volumes/Alchemy/Your Baby/Editorial/Archive"
YBFWDEST="/Volumes/Images3/WOMENS/YOUR BABY/JPG/"

BKSRC="/Volumes/SmartMover temp/BabaEnKleuterArchive/BABA&KLEUTER/Archived/print/"
BKDEST="/Volumes/Alchemy/Baba&Kleuter/Archive/"
BKFWDEST="/Volumes/Images3/WOMENS/BABA EN KLEUTER/JPG/"

MVSRC="/Volumes/SmartMover temp/MoveArchive/MOVE/Archived/Print/"
MVDEST="/Volumes/640GB/Ready_for_external/Move/"
MVFWDEST="/Volumes/Images3/WOMENS/MOVE/JPG/"

TLSRC="/Volumes/SmartMover temp/TrueLoveArchive/TRUELOVE/Archived/Print/"
TLDEST="/Volumes/TrueLove/Archive/"
TLFWDEST="/Volumes/Images3/WOMENS/TRUELOVE/JPG/"

FWSRC="/Volumes/SmartMover temp/FinweekArchive/FINWEEK/Archived/Print/"
FWDEST="/Volumes/FNT/FinART/Archive/"
FWFWDEST="/Volumes/Images3/WEEKLIES/FINWEEK/JPG/"

TVSRC="/Volumes/SmartMover temp/TVPlusArchive/TVPLUS/Archived/Print/"
TVDEST="/Volumes/TVPlus/TVART/Archive/"
TVWDEST="/Volumes/Images3/WEEKLIES/TVPLUS/JPG/"
