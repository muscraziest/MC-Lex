/*----- Sección de Declaraciones --------------*/

%{

char * formula;
int tam(char * f);
void sustituir_doble_negacion(char * f);
void imprime();

int negacion=0;

%}

terminal	[ \n\t]
doble_negacion  ({formula}|{terminal})+\~\~({formula})+
formula		[a-zV\^"->""<->"\~\(\)]+

/*----- Sección de Reglas ----------------*/
%%

.			{}
\n			{}
{doble_negacion}	{sustituir_doble_negacion(yytext);}
{formula}		{imprime(yytext);}

%%

/*----- Sección de Procedimientos --------*/
int main (int argc, char *argv[]) {
	if (argc == 2) {
		yyin = fopen (argv[1], "rt");
		if (yyin == NULL) {
			printf ("El fichero %s no se puede abrir\n", argv[1]);
			exit (-1);
		}
	}

	else 
		yyin = stdin;

	yylex();

	return 0;
}



int tam(char * f){

	int i=0;
	while (f[i] != '\0') i++;

	return i;
}

void sustituir_doble_negacion(char * f){

	char * c = malloc(sizeof(char)*256);
	int i,j;	

	//Eliminamos la doble negación
	for(i=0,j=0;i<tam(f);){
		if(f[i]=='~' && f[i+1]=='~'){
			i+=2;	
		}		
		else{
			c[j]=f[i];
			j++;
			i++;
		}
	}	
	
	f=c;

	printf("%s\n",f);

	negacion = 1;
}

void imprime(char * f){

	if(negacion == 0)
		printf("%s\n",f);
}
