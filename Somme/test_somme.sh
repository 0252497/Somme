#!./runTests.sh -c

# Inclusions
source check.sh

# Constantes
add="${CIBLE:-./somme-env.sh}"
R1=$((RANDOM - 16384))
R2=$((RANDOM - 16384))
SOMME=$((R1 + R2))

#
# Série 1: Addition simple
#

test_01a_1_nombre_positif()
{ check "$add,33" 33 '' 0; }

test_01b_1_nombre_negatif()
{ check "$add,-33" -33 '' 0; }

test_01c_negatif_plus_positif()
{ check "$add,-33,133" 100 '' 0; }

test_01d_negatif_plus_negatif_plus_positif()
{ check "$add,-33,-133,100" -66 '' 0; }

test_01e_random_plus_random()
{ check "$add,$R1,$R2" "$SOMME" '' 0; }

test_01f_plusieurs_nombres()
{ check "$add,1,-2,-3,4,+6,+2" 8 '' 0; }

POSITIFS=$(echo {1..10} | tr ' ' ',')
NEGATIFS=$(echo -{1..10} | tr ' ' ',')

test_01g_positifs()
{ check "$add,$POSITIFS" 55 '' 0; }

test_01h_negatifs()
{ check "$add,$NEGATIFS" -55 '' 0; }

test_01i_somme_zero()
{ check "$add,$NEGATIFS,$POSITIFS" 0 '' 0; }

#
# Série 2: arguments invalides
#

test_02a_erreur_arg1_invalide()
{ check "$add,10x,20" '' '~10x' 1; }

test_02b_erreur_arg2_invalide()
{ check "$add,10,x20" '' '~x20' 1; }

#
# Série 3: USAGE si aucun argument
#

USAGE="*USAGE: ?* ?--env? ?--help? ?--stdin? ?nombres...?"

test_03a_usage_si_0_arg()
{ check "$add" '' "$USAGE" 1; }

#
# Série 4: option --help
#

test_04a_help_seul()
{ check "$add,--help" "$USAGE" "" 0; }

test_04b_help_et_args()
{ check "$add,--help,1,2,3" "$USAGE" "" 0; }

test_04a_args_et_help()
{ check "$add,1,2,3,--help" "$USAGE" "" 0; }

#
# Série 5: option --env
#

ENV1="NB0=100,NB1=10,NB2=20,NB3=30,NB4=40,NB5=50,NB6=60,NB7=70,NB8=80,NB9=90"
ENV2="NB1=-10,NB5=-50,NB8=-80"

test_05a_env_complet()
{ check "env,$ENV1,$add,--env" 550 '' 0; }

test_05b_env_partiel()
{ check "env,$ENV2,$add,--env" -140 '' 0; }

test_05c_erreur_env_nb0()
{ check "env,$ENV1,NB0=10x,$add,--env" '' '~10x' 1; }

test_05d_erreur_env_nb9()
{ check "env,$ENV1,NB9=20x,$add,--env" '' '~20x' 1; }

test_05e_env_plus_args()
{ check "env,$ENV1,$add,--env,$POSITIFS" 605 '' 0; }

test_05f_args_sans_env()
{ check "env,$ENV1,$add,$POSITIFS" 55 '' 0; }

test_05g_usage_sans_env()
{ check "env,$ENV1,$add" "" "$USAGE" 1; }

#
# Série 6: option --stdin
#

test_06a_stdin()
{ check "eval,echo $POSITIFS | $add --stdin" 55 '' 0; }

test_06b_stdin_aucun_nombre_somme_0()
{ check "eval,echo | $add --stdin" 0 '' 0; }

test_06c_erreur_stdin_arg_invalide()
{ check "eval,echo $POSITIFS 10x | $add --stdin" "" '~10x' 1; }

test_06d_usage_sans_stdin()
{ check "eval,echo $POSITIFS | $add" "" "$USAGE" 1; }

# Marche pas en mode WSL/CMD
# test_06e_stdin_sur_plusieurs_lignes()
# { check "eval,echo -e '1\n2 3\n4' | $add --stdin" 10 '' 0; }

test_06f_stdin_plus_args()
{ check "eval,echo $POSITIFS | $add --stdin $NEGATIFS $NEGATIFS " -55 '' 0; }

test_06g_args_sans_stdin()
{ check "eval,echo $POSITIFS | $add $NEGATIFS " -55 '' 0; }


#
# Série 7: options combinées
#

test_07a_stdin_plus_env_plus_args()
{ check "eval,echo $POSITIFS | env $ENV1 $add --stdin --env $NEGATIFS $NEGATIFS" 495 '' 0; }

test_07b_stdin_plus_env_plus_args_desordre()
{ check "eval,echo $POSITIFS | env $ENV1 $add $NEGATIFS --env $NEGATIFS --stdin $NEGATIFS" 440 '' 0; }

test_07c_stdin_plus_env()
{ check "eval,echo $POSITIFS | env $ENV1 $add --stdin --env" 605 '' 0; }

test_07d_stdin_plus_env_plus_args_plus_help_affiche_aide()
{ check "eval,echo $POSITIFS | env $ENV $add --stdin --env $NEGATIFS $NEGATIFS --help" "$USAGE" '' 0; }

test_07e_stdin_plus_help_affiche_aide()
{ check "eval,echo $POSITIFS | $add --stdin --help" "$USAGE" '' 0; }

test_07f_env_plus_help_affiche_aide()
{ check "env,$ENV1,$add,--env,--help" "$USAGE" '' 0; }


#
# Série 8: options invalides
#

OPTION="--$RANDOM"

test_08a_option_invalide()
{ check "$add,--invalide" "" "~--invalide" 1; }

test_08b_option_invalide_desordre()
{ check "eval,echo $POSITIFS | env $ENV $add --stdin --env $NEGATIFS --$OPTION $NEGATIFS --help" "" "~--$OPTION" 1; }

#
# Série 9: options répétées
#

test_09a_stdin_plus_env_plus_args_avec_repetition_aucune_influence()
{ check "eval,echo $POSITIFS | env $ENV1 $add --stdin $NEGATIFS --env --env --stdin --env $NEGATIFS --stdin --stdin $NEGATIFS" 440 '' 0; }

test_09b_aide_avec_repetition_affiche_aide()
{ check "eval,echo $POSITIFS | env $ENV $add --stdin --env --env --stdin --help $NEGATIFS $NEGATIFS --help" "$USAGE" '' 0; }

