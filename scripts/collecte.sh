#!/bin/bash

echo "profondeur_max,profondeur_moyenne,pct_racine,moyenne,max_fdossier,pct_max_dossier,pct_dossier_vide,pct_generiques,fichier_tot,etiquette" > data/dossiers.csv

for d in tests/*/; do
    nom=$(basename "$d")
    etiquette="${nom##*_}"
    echo "$(./scripts/scan.sh "$d" --csv),$etiquette" >> data/dossiers.csv
done
