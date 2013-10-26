%{
	#include <stdio.h>
	#include <stdlib.h>
	FILE* yyin;
	extern int line_number;
%}

%union {
	char ch;
	char *st;
	int d;
}

/* Declaring tokens */

%token GE LE EQ NE OR AND CLASS MAIN INT CHAR BOOL IF THEN GOTO PRINT READ
%token <d> NUMBER 
%token <st> ID LABEL BOOL_LITERAL STR_LITERAL
%token <ch> CHAR_LITERAL

/* Establishing Associativities */

%start program
%right '='
%left OR
%left AND
%left EQ NE
%left GT LT GE LE
%left '+' '-'
%left '*' '/'
%right '!'

%%

program: CLASS MAIN '{' list_decl list_stat '}' { printf("PARSED SUCCESSFULLY\n"); exit(0);}
       ;

list_decl:
     	 | field_decl list_decl
      	 ;

list_stat:
     	 | statement list_stat
     	 ;

field_decl: type variable
	  ;

variable: ID ',' variable
     	| ID '[' NUMBER ']' ',' variable
     	| ID ';'
     	| ID '[' NUMBER ']' ';'
     	;

type: INT
    | CHAR
    | BOOL
    ;

statement: labelled_statement
	 | location '=' expr ';'
	 | IF expr THEN GOTO LABEL ';'
	 | GOTO LABEL ';'
	 | method_call ';'
	 ;

labelled_statement: LABEL statement
		  ;

location: ID
	| ID '[' expr ']'
	;

expr: literal
    | location
    | expr '+' expr
    | expr '-' expr
    | expr '*' expr
    | expr '/' expr
    | expr LT expr
    | expr GT expr
    | expr LE expr
    | expr GE expr
    | expr EQ expr
    | expr NE expr
    | expr AND expr
    | expr OR expr
    | '-' expr
    | '!' expr
    | '(' expr ')'
    ;

literal: NUMBER
       | STR_LITERAL
       | CHAR_LITERAL
       | BOOL_LITERAL
       ;

method_call: PRINT '(' expr_temp ')'
	   | READ '(' location ')'
	   ;

expr_temp: expr ',' expr_temp
         | expr
         ;

%%

/* main function reading the c file*/

int main(int argc, char **argv)
{
	yyin=fopen(argv[1],"r");
	yyparse();
	fclose(yyin);
	return 0;
}

/* prints error*/

yyerror(char *s)
{
	fprintf(stderr, "ERROR detected at line number %d\n", line_number);
}
