#!/bin/bash

LOG_FILE="$rdhome/.logs/gzdoom.log"

if [ -e "$LOG_FILE" ]; then
    rm "$LOG_FILE"
fi

echo "RetroDECK GZDOOM wrapper init." | tee -a "$LOG_FILE"

# List of IWAD files
IWAD_FILES=("DOOM1.WAD" "DOOM.WAD" "DOOM2.WAD" "DOOM2F.WAD" "DOOM64.WAD" "TNT.WAD"
            "PLUTONIA.WAD" "HERETIC1.WAD" "HERETIC.WAD" "HEXEN.WAD" "HEXDD.WAD"
            "STRIFE0.WAD" "STRIFE1.WAD" "VOICES.WAD" "CHEX.WAD"
            "CHEX3.WAD" "HACX.WAD" "freedoom1.wad" "freedoom2.wad" "freedm.wad" # unlicenced iwads
            "doom_complete.pk3"                                                 # this includes them all
            )

echo "Trying to load \"$1\"." | tee -a "$LOG_FILE"

if [ ! -e "$1" ]; then
    echo "$1 not found. Quitting." | tee -a "$LOG_FILE"
    exit 0
fi

filename=$(basename "$1")  # Extracts only the filename from the full path

shopt -s nocasematch   # Enable case-insensitive matching
if [[ "${IWAD_FILES[@]}" =~ "$filename" ]]; then
    type="iwad"
else
    type="file"
fi
shopt -u nocasematch   # Disable case-insensitive matching after use

echo "Found $type: $1, loading it." | tee -a "$LOG_FILE"
gzdoom +fluid_patchset /app/share/sounds/sf2/gzdoom.sf2 -config /var/config/gzdoom/gzdoom.ini -$type "$1" | tee -a "$LOG_FILE"