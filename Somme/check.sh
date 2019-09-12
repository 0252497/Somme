ERROR_FILE=/tmp/erreur.txt

assertLike()
{
	# Vérifie que la valeur reçue est conforme au pattern.
	# Si le pattern débute par ~, il s agit d un regex, sinon un pattern verbatim.
	#
	# NB pour un pattern verbatim qui débute par ~, il faut le doubler ~~.
	#
	# ARGUMENTS
	#	1 pattern attendu
	#	2 valeur reçue
	#	3 message d'erreur
	#	4 ajustement de la profondeur d'appel (0 par défaut)

	if [[ $1 == ~~* || $1 == \*\** ]]; then
		assertEquals "${1:1}" "$2" "$3" $((${4:-0} + 1))
	elif [[ $1 == ~* ]]; then
		assertMatches "${1:1}" "$2" "$3" $((${4:-0} + 1))
	elif [[ $1 == \** ]]; then
		assertGlobs "${1:1}" "$2" "$3" $((${4:-0} + 1))
	else
		assertEquals "$1" "$2" "$3" $((${4:-0} + 1))
	fi
}

check()
{
	# Lance une commande et vérifie que cette commande fournie
	# les sorties attendue: stdout, stderr, et exitcode.
	#
	# NB Du aux limitations de bash, la commande doit être fournie
	# 	 en séparant les constituantes par des virgules.
	#	 Elle sera convertie en array et exécutée ainsi.
	#
	# ARGUMENTS
	#	1 commande a tester
	#	2 sortie attendue
	#	3 patron d'erreur attendu
	#	4 exitcode attendu (0 ou 1)

	# Splitter l'argument $1 séparé par des virgules dans un array
	local cmdarr
	if [[ $1 == \;* ]]; then
		IFS=\; read -ra cmdarr <<< "${1:1}"
	else
		IFS=, read -ra cmdarr <<< "$1"
	fi

	# Obtenir une présentation sans virgules de la commande
	local commande="${cmdarr[@]}"

	# echo "$commande | ${cmdarr[@]} size:${#cmdarr[@]}"

	# Exéctuer la commande
	local sortie
	sortie=$("${cmdarr[@]}" 2> "$ERROR_FILE")
	local exitcode=$?
	local erreur=$(cat "$ERROR_FILE" | tr -d '\r')

	# Pour usage sous DOS, supprimer les \r.
	sortie=$(echo -n $sortie | tr -d '\r')
	# echo "$commande -> $exitcode | $sortie | $erreur"


	assertLike "$3" "$erreur" "$commande -> Mauvais message d'erreur (stderr)" 1
	assertLike "$2" "$sortie" "$commande -> Mauvais message (stdout)" 1

	# Tous les codes d'erreur sont ramenés à 1.
	if (( exitcode != 0 )); then
		exitcode=1
	fi
	assertEquals "$4" "$exitcode" "$commande -> Mauvais exit code" 1
}
