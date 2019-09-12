@echo off

if [%1] NEQ [""] set STDIN=%~1
shift

REM Rétablir les variables d'environnement
if [%1] NEQ [""] set NB1=%1
shift
if [%1] NEQ [""] set NB2=%1
shift
if [%1] NEQ [""] set NB3=%1
shift
if [%1] NEQ [""] set NB4=%1
shift
if [%1] NEQ [""] set NB5=%1
shift
if [%1] NEQ [""] set NB6=%1
shift
if [%1] NEQ [""] set NB7=%1
shift
if [%1] NEQ [""] set NB8=%1
shift
if [%1] NEQ [""] set NB9=%1
shift
if [%1] NEQ [""] set NB0=%1
shift

REM Récupérer le reste des arguments dans params.
set params=%1
:loop
shift
if [%1]==[] goto afterloop
set params=%params% %1
goto loop
:afterloop

REM Appeler le programme avec le reste des arguments

if ["%STDIN%"]==[] ( 
	Somme %params% 
) else (
	echo. %STDIN% | Somme %params%
)

