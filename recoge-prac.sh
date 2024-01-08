#!/bin/bash
#
#Este script tiene como finalidad recoger prácticas con el nombre que se pasa como parámetro
#y se encuentran en el directorio origen que también se pasa como parámetro, y se llevan a otro
#directorio pasado también como parámetro
#
# $1 = Nombre de la asignatura
# $2 = Directorio origen de las prácticas
# $3 = Directorio destino de las prácticas

alumno=$(basename $2)
for prac in $2*.sh
do
	mv $prac $3/$alumno.sh
done