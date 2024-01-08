#!/bin/bash

#log para documentar errores
logf=$/HOME/informe.log

function _crealog ()
{
#$1 es el mensaje que se quiere añadir
echo "[$fechahoy, $hora]: $1" >> logf
}

#Variables globales
declare -i fin=0
fechahoy=$(date "+%y%m%d")
hora=$(date | cut -d ' ' -f 4)
dirActual=$(pwd)

#Función 1: Programar recogida de prácticas
function _recogida ()
{
echo "Menú 1 - Programar recogida de prácticas"
echo
echo "Asignatura cuyas prácticas desea recoger: "
read Asig
echo "Ruta con las prácticas de los alumnos: "
read dirOrigen
if [-d $dirOrigen]
then
	echo "Ruta para almacenar las prácticas: "
	read dirDestino
	if [! -d $dirDestino]
	then
		mkdir $dirDestino
	fi
	echo "Se va a programar la recogida de prácticas de $Asig para mañana a las 8:00."
	echo "Origen: $dirOrigen. Destino: $dirDestino."
	echo
	echo "¿Estás de acuerdo? (s/n)"
	read respuesta1
	if [$respuesta1 = "s"]
	then
		_crealog "Recogida de prácticas"
		crontab -l >> tareass
		echo "0 8 * * * $dirActual/recoge-prac.sh $Asig $dirOrigen $dirDestino" >> tareass
		crontab tareass
	elif [$respuesta1 = "n"]
	then
		_crealog "Recogida cancelada"
		echo "Recogida cancelada"
	fi
else
	echo "No existe el directorio origen"
	_crealog "No existe el directorio origen"
fi
}

#Función 2: Empaquetar prácticas de la asignatura
function _empaquetado ()
{
echo "Menú 2 - Empaquetar prácticas de la asignatura"
echo
echo "Asignatura cuyas prácticas se desea empaquetar: "
read Asig2
echo "Ruta absoluta del directorio de prácticas: "
read dirPracticas
if [-d $dirPracticas]
then
	echo "Se van a empaquetar las prácticas de la asignatura $Asig2 presentes en el directorio $dirPracticas."
	echo
	echo "¿Estás de acuerdo? (s/n)"
	read respuesta2
	if[$respuesta2 = "s"]
	then
		tar -cvzf "$Asig2-$fechahoy.tgz" $dirPracticas
		mv "$Asig2-$fechahoy.tgz" $dirPracticas
		_crealog "Empaquetado hecho"
	elif [$respuesta2 = "n"]
	then
		_crealog "Empaquetado cancelado"
		echo "Empaquetado cancelado"
	fi
else
	echo "El directorio a salvar no existe."
	_crealog "No existe el directorio donde guardar el empaquetado"
fi
}

#Función 3: Obtener el tamaño y la fecha del fichero comprimido
function _tamanio ()
{
echo "Menú 3 - Obtener tamaño y fecha del fichero"
echo
echo "Asignatura sobre la que queremos información: "
read Asig3
echo "Ruta absoluta del directorio donde se encuentra el fichero: "
read dirFichero
if [-d $dirFichero]
then
	fichero=$(find $dirFichero -type f -name "$Asig3-$fechahoy*")
	nombre=$(basename $fichero)
	peso=$(du -sh $fichero | cut -f1)
	echo "El fichero generado es $nombre y ocupa $peso bytes."
else
	echo "Directorio no encontrado"
	_crealog "No existe directorio"
fi
}

#Función Menú
function _menu ()
{
declare -i opcion
echo 
echo "Menú"
echo "  1. Programar recogida de prácticas"
echo "  2. Empaquetado de prácticas de una asignatura"
echo "  3. Ver tamaño y fecha del fichero de una asignatura"
echo "  4. Finalizar programa"
echo
echo "  Elige opción: "
read opcion
case $opcion in
	1)
	_recogida;;
	2)
	_empaquetado;;
	3)
	_tamanio;;
	4)
	fin=1;;
	*)
		echo "Instrucción incorrecta"
		_crealog "Instrucción incorrecta"
esac
}

echo "ASO 22/23 - Práctica 6"
echo "Raúl López Rodríguez"
echo
echo "Gestión de prácticas"
echo "--------------------"

while [$fin == 0]
do
	_menu
done