#!/bin/bash
# scan.sh : analyse la structure d'un dossier et sort ses mesures (texte ou CSV)
# Usage : ./scan.sh <dossier> [--csv]

##Mesure de structure

#Profondeur
profondeur_max=$(find "$1" -printf '%d\n' | sort -n | tail -1)
#echo "Profondeur max : $profondeur_max"

profondeur_moyenne=$(find "$1" -printf '%d\n' | awk '{sum+=$1; count++} END {if (count > 0) print sum/count; else print 0}')
echo "Profondeur moyenne : $profondeur_moyenne"


