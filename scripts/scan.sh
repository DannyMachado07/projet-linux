#!/bin/bash
# scan.sh : analyse la structure d'un dossier et sort ses mesures (texte ou CSV)
# Usage : ./scan.sh <dossier> [--csv]

if [ "$#" -lt 1 ] || [ "$#" -gt 2 ]; then
    echo "Usage : $0 <dossier> [--csv]"
    exit 1
fi

if [ ! -d "$1" ]; then
    echo "Erreur : '$1' n'est pas un dossier"
    exit 1
fi


##Mesure de structure

#Profondeur
profondeur_max=$(find "$1" -mindepth 1 -printf '%d\n' | sort -n | tail -1)

profondeur_moyenne=$(find "$1" -mindepth 1 -printf '%d\n' | awk '{sum+=$1; count++} END {if (count > 0) print sum/count; else print 0}')

#Pourcentage de fichier racine
fichier_r=$(find "$1" -maxdepth 1 -type f | wc -l)
fichier_tot=$(find "$1" -type f | wc -l)
pct_racine=$(awk -v r="$fichier_r" -v t="$fichier_tot" 'BEGIN {if (t > 0) print r*100/t; else print 0}')

#Moyenne de fichier par dossier
stats=$(find "$1" -type d | while read -r d; do
    find "$d" -maxdepth 1 -type f | wc -l
done | awk 'BEGIN {max=0} {sum+=$1; count++; if ($1 > max) max=$1} END {if (count > 0) print sum/count, max; else print 0, 0}')
read moyenne max_fdossier <<< "$stats"
pct_max_dossier=$(awk -v r="$max_fdossier" -v t="$fichier_tot" 'BEGIN {if (t > 0) print r*100/t; else print 0}')



#Pourcentage de dossiers vides
dossier_vide=$(find "$1" -mindepth 1 -type d -empty | wc -l)
dossier_tot=$(find "$1" -mindepth 1 -type d | wc -l)
pct_dossier_vide=$(awk -v r="$dossier_vide" -v t="$dossier_tot" 'BEGIN {if (t > 0) print r*100/t; else print 0}')



#Pourcentage des noms de dossier génériques
generiques=("nouveau dossier" "new folder" "sans titre" "untitled" "divers" "autres" "misc" "tmp" "temp" "nouveau" "old" "backup" "archive" "stuff" "truc")
nb_generiques=0
while read -r d; do
    nom=$(basename "$d")
    for g in "${generiques[@]}"; do
        if [ "${nom,,}" = "$g" ]; then
            ((nb_generiques++))
	    break
        fi
    done
done < <(find "$1" -mindepth 1 -type d)

pct_generiques=$(awk -v r="$nb_generiques" -v t="$dossier_tot" 'BEGIN {if (t > 0) print r*100/t; else print 0}')



if [ "$2" = "--csv" ]; then
    echo "$profondeur_max,$profondeur_moyenne,$pct_racine,$moyenne,$max_fdossier,$pct_max_dossier,$pct_dossier_vide,$pct_generiques,$fichier_tot"
else
    echo "Profondeur max : $profondeur_max"
    echo "Profondeur moyenne : $profondeur_moyenne"
    echo "Pourcentage de fichier à la racine : $pct_racine%"
    echo "moyenne de fichier par dossier : $moyenne"
    echo "maximum de fichier dans un dossier : $max_fdossier"
    echo "La part des fichiers dans le plus gros dossier : $pct_max_dossier%"
    echo "Pourcentage de dossier vide : $pct_dossier_vide%"
    echo "Pourcentage des noms de dossier génériques : $pct_generiques%"
    echo "Fichier total : $fichier_tot"
fi
