/*----- Sección de Declaraciones --------------*/

%{

int tam(char * f);
int subcadena(char * f, char * subc);
void introducir_negativa(char * f);
void imprime(char * f);

int neg_parentesis = 0;
%}

negacion_parentesis	{formula}*\~\(([a-zV\^\~\(\)])+\)
formula			[a-zV\^"->""<->"\~\(\)]+

/*----- Sección de Reglas ----------------*/
%%

.				{}
\n				{}
{negacion_parentesis}		{introducir_negativa(yytext);}
{formula}			{imprime(yytext);}


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

int subcadena(char * f, char * subc){

	int cont=0,pos=-1,i=0;
	int found=0;
	
	while(i < tam(f) && found==0){

		if(f[i] == subc[cont]){
			pos = i;
			while (f[i] == subc[cont] && cont < tam(subc) && i < tam(f)){
				cont++;
				i++;
			}
			if(cont == tam(subc)) found = 1;
			else{	
				cont = 0;
				pos=-1;
			}
		}
		i++;
	}

 return pos;
}

void introducir_negativa(char * f){

	char * alfa = malloc(sizeof(char)*256); 
	char * beta = malloc(sizeof(char)*256);
	char * c;
	char * abre_p = "(";
	char * cierra_p =")";
	char * y ="^";
	char * o = "V";
	char * negacion = "~";
	char * conectiva = malloc(sizeof(char));
	int pos_n=-1, pos_alfa=-1, pos_final_alfa=-1, pos_final_beta=-1,pos_conectiva=-1,i,j;	

	while (subcadena(f,"~(") != -1){

		pos_n = subcadena(f,"~(");
		c=malloc(sizeof(char)*256);

		//BUSCAMOS LA EXPRESIÓN ALFA
		if (f[pos_n+2]!='('){
			alfa[0] = f[pos_n+2];	
			pos_alfa=pos_n+2;
			pos_final_alfa=pos_n+2;
		}
		else{
			int num_parentesis=1;
			i=1;
			while(f[pos_n+i] == '('){
				i++;
				num_parentesis++;
			}
		
			int parentesis = num_parentesis;
			int ultimo_parentesis = pos_n+i;
			for(i=ultimo_parentesis; i < tam(f), parentesis != 0; i++){
					if(f[i]	== ')')	parentesis--;
			}

			pos_final_alfa=i;

			//Guardamos la expresión beta
			for(i=pos_alfa,j=0; i<pos_final_alfa; i++,j++)
				alfa[j] = f[i];

			
		}
		
		conectiva[0]=f[pos_final_alfa+1];
		pos_conectiva=pos_final_alfa+1;

		//BUSCAMOS LA EXPRESIÓN BETA
		//Si tenemos una expresión beta compuesta por un literal
		if (f[pos_conectiva+1]!='('){
			for(i=pos_conectiva+1,j=0; i<tam(f),f[i]!=')'; i++,j++)
				beta[j] = f[i];
			pos_final_beta = i;
		}
			
		//Si la expresión beta está compuesta por una o varias claúsulas
		else{
			int num_parentesis = 1;

			while (f[pos_conectiva+i] == '('){
				i++;
				num_parentesis++;
			}

			//Calculamos donde termina la expresión beta
			int parentesis = num_parentesis;
			int ultimo_parentesis = pos_n+i;
			for(i=ultimo_parentesis; i < tam(f), parentesis != 0; i++){
				if(f[i]	== ')')	parentesis--;
			}

			pos_final_beta = i;

			//Guardamos la expresión beta
			for(i=pos_conectiva,j=0; i<pos_final_beta; i++,j++)
				beta[j] = f[i];
			
		}

		//Introducimos la negativa
		strncat(c,f,pos_n);
		strcat(c,abre_p);
		strcat(c,negacion);
		strncat(c,f+pos_alfa,pos_conectiva-pos_alfa);	
		if(conectiva[0] == '^')	strcat(c,o);
		else strcat(c,y);
		strcat(c,negacion);
		strcat(c,beta);
		strcat(c,f+pos_final_beta);
	
		f=c;
	}

	printf("%s\n",f);
	neg_parentesis=1;
}

void imprime(char * f){

	if(neg_parentesis == 0)
		printf("%s\n",f);
}
