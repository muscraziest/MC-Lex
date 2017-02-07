/*----- Sección de Declaraciones --------------*/

%{

int tam(char * f);
int subcadena(char * f, char * subc);
void sustituir_equivalencia(char * f);
void imprime(char * f);

int equivalencia=0;
%}

terminal	[ \n\t]
equivalencia	{terminal}*[a-zV\^"->"\~\(\)]+"<->"[a-zV\^"->"\~\(\)]+{terminal}*
formula		[a-zV\^"->""<->"\~\(\)]+

/*----- Sección de Reglas ----------------*/
%%

.			{}
\n			{}
{equivalencia}		{sustituir_equivalencia(yytext);}
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

void sustituir_equivalencia(char * f){

	char * alfa = malloc(sizeof(char)*256); 
	char * beta = malloc(sizeof(char)*256);
	char * copia = f;
	char * c;
	char * abre_p = "(";
	char * cierra_p=")";
	char * y="^";
	char * implicacion  = "->";
	int pos_eq=-1, pos_alfa=-1, pos_final_beta=-1,i,j;	

	while (subcadena(f,"<->") != -1){
		
		c = malloc(sizeof(char)*256);
		pos_eq = subcadena(f,"<->");

		//BUSCAMOS LA EXPRESIÓN ALFA
		//Si tenemos una expresión alfa compuesta por un literal
		if (f[pos_eq-1]!=')'){
			alfa[0] = f[pos_eq-1];	
			pos_alfa=pos_eq-1;	
		}

		//Si la expresión alfa está compuesta por una o varias claúsulas
		else{

			int num_parentesis = 1;
			i=2;

			while (f[pos_eq-i] == ')'){
				i--;
				num_parentesis++;
			}

			//Calculamos donde empieza la expresión alfa
			int parentesis = num_parentesis;
			int ultimo_parentesis = pos_eq-i;
			for(i=ultimo_parentesis; i >= 0, parentesis != 0; i--){
				if(f[i]	== '(')	parentesis--;
			}

			pos_alfa = i;
			//Guardamos la expresión alfa
			for(i=pos_alfa+1,j=0; i<pos_eq; i++,j++)
				alfa[j]= f[i];
			
		}

		//BUSCAMOS LA EXPRESIÓN BETA
		//Si tenemos una expresión beta compuesta por un literal
		if (f[pos_eq+3]!='('){
			beta[0] = f[pos_eq+3];
			pos_final_beta=pos_eq+3;
		}
			
		//Si la expresión beta está compuesta por una o varias claúsulas
		else{
			int num_parentesis = 1;
			i=4;

			while (f[pos_eq+i] == '('){
				i++;
				num_parentesis++;
			}

			//Calculamos donde termina la expresión beta
			int parentesis = num_parentesis;
			int ultimo_parentesis = pos_eq+i;
			for(i=ultimo_parentesis; i < tam(f), parentesis != 0; i++){
				if(f[i]	== ')')	parentesis--;
			}

			pos_final_beta = i;
			j;

			//Guardamos la expresión beta
			for(i=pos_eq+3,j=0; i<pos_final_beta; i++,j++)
				beta[j] = f[i];
			
		}

		//Eliminamos la equivalencia
		strncat(c,f,pos_alfa+1);	
		strcat(c,abre_p);		
		strcat(c,abre_p);
	
		//Copiamos alfa
		strcat(c,alfa);
		strcat(c,implicacion);

		//Copiamos beta
		strcat(c,beta);
		strcat(c,cierra_p);
		strcat(c,y);
		strcat(c,abre_p);

		//Copiamos beta
		strcat(c,beta);
		strcat(c,implicacion);

		//Copiamos alfa
		strcat(c,alfa);
		strcat(c,cierra_p);
		strcat(c,cierra_p);

		strcat(c,f+pos_final_beta+1);


		f=c;
	}

	printf("%s\n",f);
	equivalencia = 1;
}


void imprime(char * f){

	if(equivalencia == 0)
		printf("%s\n",f);
}
