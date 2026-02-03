%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "y.tab.h" 
%}

%%

[ \t\n]+                ; 

[0-9]+ { 
    yylval.string_from_lex = (char*) malloc(strlen(yytext) + 1); 
    strcpy(yylval.string_from_lex, yytext);
    return NUMBER; 
}

[a-zA-Z][a-zA-Z0-9]* { 
    yylval.string_from_lex = (char*) malloc(strlen(yytext) + 1); 
    strcpy(yylval.string_from_lex, yytext); 
    return VARIABLE;
}

. {   // ıt returns all the other unmatched characters as a token
    return yytext[0]; 
}

%%

int yywrap() {
    return 1;
}
