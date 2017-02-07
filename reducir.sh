#!/bin/bash
lex equivalencia.l
gcc -o eq lex.yy.c -lfl
./eq formulas > equivalencia

lex implicacion.l
gcc -o im lex.yy.c -lfl
./im equivalencia > implicacion

lex negacion.l
gcc -o ne lex.yy.c -lfl
./ne implicacion > negacion1

lex parentesis-negado.l
gcc -o pneg lex.yy.c -lfl
./pneg negacion1 > negacion-parentesis

./ne negacion-parentesis > forma-reducida



