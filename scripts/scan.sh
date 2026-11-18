#!/bin/bash
# scan.sh : analyse la structure d'un dossier et sort ses mesures (texte ou CSV)
# Usage : ./scan.sh <dossier> [--csv]

if [ "$#" -ne 1 ]; then
    echo "Usage : $0 <dossier>"
    exit 1
fi

if [ ! -d "$1" ]; then
    echo "Erreur : '$1' n'est pas un dossier"
    exit 1
fi


##Mesure de structure

#Profondeur
profondeur_max=$(find "$1" -mindepth 1 -printf '%d\n' | sort -n | tail -1)
echo "Profondeur max : $profondeur_max"

profondeur_moyenne=$(find "$1" -mindepth 1 -printf '%d\n' | awk '{sum+=$1; count++} END {if (count > 0) print sum/count; else print 0}')
echo "Profondeur moyenne : $profondeur_moyenne"

#Pourcentage de fichier racine
fichier_r=$(find "$1" -maxdepth 1 -type f | wc -l)
fichier_tot=$(find "$1" -type f | wc -l)
pct_racine=$(awk -v r="$fichier_r" -v t="$fichier_tot" 'BEGIN {if (t > 0) print r*100/t; else print 0}')
echo "$pct_racine"
