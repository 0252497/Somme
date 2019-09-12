#!/bin/bash
# Passer toutes les variables d'environnement NBx
stdin=
[[ -t 0 ]] || stdin=$(cat)
cmd.exe /c somme-env.cmd "$stdin" "$NB1" "$NB2" "$NB3" "$NB4" "$NB5" "$NB6" "$NB7" "$NB8" "$NB9" "$NB0" "$@"
