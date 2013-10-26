%{
	#include <string.h>
	#include "project_phase1.tab.h"
	int line_number = 1;
	char goto_identified;
%}

ws [ \t]
ID ([a-zA-Z_][a-zA-Z0-9_]*)
NUMBER    [0-9]+

%%

\n		{ line_number++; }
{ws}+  		{ 		 }

"class" 	{ return CLASS;}
"main"		{ return MAIN; }

">"		{ return GT; }
"<"		{ return LT; }
">="		{ return GE; }
"<="		{ return LE; }
"=="		{ return EQ; }
"!="		{ return NE; }

"+" |
"-" |
"*" |
"/" |
"(" |
")" |
"[" |
"]" |
"{" |
"}" |
"=" |
"!" |
"," |
";" 		{ return yytext[0]; }

"&&"		{ return AND;}
"||"		{ return OR; }

"if"		{ return IF;   }
"then"		{ return THEN; }
"goto"		{ goto_identified = 'a';
		  return GOTO; }
"print"		{ return PRINT;}
"read"		{ return READ; }
	
"true"		{ yylval.st = yytext; 
		  return BOOL_LITERAL; }
"false"		{ yylval.st = yytext;
		  return BOOL_LITERAL; }

"int"		{ return INT; 	 }
"char"		{ return CHAR;	 }
"boolean" 	{ return BOOL;	 }
	
\"(.)*\"	{ yylval.st = strtok(yytext,"\"");
		  return STR_LITERAL; 		     }
\'(.)\'		{ yylval.ch = yytext[1];
		  return CHAR_LITERAL; 		     }

{ID}:		{ yylval.st = strtok(yytext,":");
		  return LABEL; 		     }

{NUMBER} 	{ yylval.d = atoi(yytext);
		  return NUMBER; 		     }

{ID}		{ yylval.st = yytext;
		  if(goto_identified == 'a'){
			  goto_identified = 'b';
			  return LABEL;
		  }
		  else{
			  return ID;
		  } 				     }

.		{ printf("Character %c is UNKNOWN in line number %d\n", *yytext,line_number); exit(0);}
%%
