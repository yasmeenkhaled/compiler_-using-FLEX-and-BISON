%{
    
    int data[100];     //array store value that retuen from tokens


%}

/* bison declarations */

%token ROOT INT FLOAT CHAR NUM VAR IF ELSE SWITCH CASE DEFAULT LB RB PRINT BREAK FOR WHILE
%nonassoc IFX
%nonassoc ELSE
%nonassoc SWITCH
%nonassoc CASE
%nonassoc DEFAULT
%left '>' '<'       //precedence
%left '+' '-'
%left '/' '*'     //start from here

/*bison grammers */
%%

program: ROOT ':' LB statements RB  {printf("Main Function Ends\n");}
        ;

statements: /*NULL*/           //statement empty
        |statements statement     //statement anthor statement
        ;                       //empty

statement: ';'
        | declaration ';'       {printf("Decleration\n");}       //represent declaration
        | expression ';'        {printf("The value is: %d\n",$1); $$=$1;         // $$=result    //$1=expression                                        
                        }
        | VAR '=' expression ';'        {
                                        data[$1] = $3;   //array ($1) name var   $3=vlaue
					printf("The Value is: %d\t\n",$3);
					$$=$3;   //to assgin
                                        }
        | NUM '+''+'';'         {
                                printf("\nbefore Increment : %d",$1 );
                                printf("\nafter Increment : %d\n",$1+1 );
                                $$=$1+1;
                        }
        | NUM '-''-'';'         {
                                printf("\nbefore Decrement : %d",$1 );
                                printf("\nafter Decrement : %d\n\n",$1-1 );
                                $$=$1-1;
                        }
        | FOR '(' NUM '<' NUM ')' LB statement RB       {                //this rule represents the syntax for a FOR loop
                                                        int i;
                                                        printf("\nFOR Loop\n");
	                                                for(i=$3 ; i<$5 ; i++) {printf("%dth Loop's expression value: %d\n", i,$8);}
                                                        }
        | WHILE '(' NUM '<' NUM ')' LB statement RB {
	                                                int i;
	                                                printf("\nWHILE Loop\n");
	                                                for(i=$3 ; i<$5 ; i++) 
                                                        {
                                                                printf("%dth Loop's expression value: %d\n", i,$8);
                                                        }
	                                               									
				        }
        | SWITCH '(' VAR ')' LB CS RB           
        | IF '(' expression ')' LB expression ';' RB %prec IFX {
								if($3){
									printf("\nThe value in IF: %d\n",$6);
								}
								else{
									printf("condition value zero in IF block\n");
								}
							}
        | IF '(' expression ')' LB expression ';' RB ELSE LB expression ';' RB {
                                                                                if($3){
									        printf("The value in IF: %d\n",$6);
								                }
								                else{
									        printf("The value in ELSE: %d\n\n",$11);
								                }
                                                                        }


        ; 

CS: C
        | C D
        ;
C: C '+' C 
        | CASE NUM ':' expression ';' BREAK ';'         {}
        ;
D: DEFAULT ':' expression ';' BREAK ';'           {}
        ;

declaration: TYPE ID1     //declaration variable
        ;
TYPE: INT
        |FLOAT
        |CHAR
        ;
ID1: ID1 ',' VAR     //This rule defines a list of identifiers (ID1). It can be a single variable (VAR) or a comma-separated list of variables.
        |VAR 
        ;
expression: NUM				{ printf("\nNumber :  %d\n",$1 ); $$ = $1;  }

	| VAR				{ $$ = data[$1]; }
	
	| expression '+' expression	{printf("\nAdd Two Numbers : %d+%d = %d \n",$1,$3,$1+$3 );  $$ = $1 + $3;}

	| expression '-' expression	{printf("\nSubtract Two Numbers : %d-%d=%d \n ",$1,$3,$1-$3); $$ = $1 - $3; }

	| expression '*' expression	{printf("\nMulti of Two Numbers : %d*%d \n ",$1,$3,$1*$3); $$ = $1 * $3;}

	| expression '/' expression	{ if($3){
				     		printf("\nDivi :%d/%d \n ",$1,$3,$1/$3);
				     		$$ = $1 / $3;
				     					
				  	}
				  	else{
						$$ = 0;
						printf("\nDiv by zero\n\t");
				  	} 	
				}
	
	| expression '<' expression	{printf("\nLess-Than :%d < %d \n",$1,$3,$1 < $3); $$ = $1 < $3 ; }
	
	| expression '>' expression	{printf("\nGreater-Than  :%d > %d \n ",$1,$3,$1 > $3); $$ = $1 > $3; }
        | expression '=''=' expression  {
                                        
                                        printf("\nEqual : %d == %d\n",$1,$4);
                                        $$ = $1 == $4;                                        
                                }
        | expression '!''=' expression  {
                                        
                                        printf("\nInequal : %d == %d\n",$1,$4);
                                        $$ = $1 != $4;                                        
                                }

	| '(' expression ')'		{$$ = $2; }
	
        ;           	

%%

/*Additional C code*/

yyerror(char *s){    //called by yyparse on error
	printf( "%s\n", s);
}

