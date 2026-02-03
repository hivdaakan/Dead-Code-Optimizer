%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <iostream>
#include <set>
#include <string>
#include <vector>

using namespace std;

extern int yylex();
void yyerror(const char *s);


set<string> activeVariables; //this set includes variables that should be produced in upper lines and are needed by other lines further down

set<string> tempSet;

bool isLive(char* varName) {
    return activeVariables.count(string(varName)) > 0;
}

void setDead(char* varName) {
    activeVariables.erase(string(varName));
}


void addTempUse(char* varName) {
    tempSet.insert(string(varName));
}

%}

%union {
    char* string_from_lex;
}

%token <string_from_lex> VARIABLE NUMBER //token(terminal)
%type <string_from_lex> operand expr //non-terminal

%%

program:
    starting_set  statements
    ;

starting_set:
    '{' variable_list '}' 
    {
        printf("{ ");
        int first = 1;
        for(auto const& v : activeVariables) {
             if(!first) printf(", ");
             printf("%s", v.c_str());
             first = 0;
        }
        printf(" }\n");
    }
    ;

variable_list:
    variable_list ',' VARIABLE { activeVariables.insert(string($3)); }
    | VARIABLE            { activeVariables.insert(string($1)); }
    ;

statements:
    statements statement
    | statement
    ;

statement:
    VARIABLE '=' expr ';' 
    {
        if (isLive($1)) { // if it is  in activeVariables set
            printf("%s=%s;\n", $1, $3); // print the line
            setDead($1); // delete $1 from the list

            for(const string& s : tempSet) { // active variable's dependencies stored in tempSet
                activeVariables.insert(s); // when we delete the last active variable we need to add its dependencies to the set
            }
        }
        
        tempSet.clear();
    }
    ;

expr:
    operand '+' operand { 
        char b[100]; sprintf(b, "%s+%s", $1, $3); 
        $$ = (char*) malloc(strlen(b) + 1); strcpy($$, b); 
    }
    | operand '-' operand { 
        char b[100]; sprintf(b, "%s-%s", $1, $3); 
        $$ = (char*) malloc(strlen(b) + 1); strcpy($$, b); 
    }
    | operand '*' operand { 
        char b[100]; sprintf(b, "%s*%s", $1, $3); 
        $$ = (char*) malloc(strlen(b) + 1); strcpy($$, b); 
    }
    | operand '/' operand { 
        char b[100]; sprintf(b, "%s/%s", $1, $3); 
        $$ = (char*) malloc(strlen(b) + 1); strcpy($$, b); 
    }
    | operand '^' operand { 
        char b[100]; sprintf(b, "%s^%s", $1, $3); 
        $$ = (char*) malloc(strlen(b) + 1); strcpy($$, b); 
    }
    | operand { $$ = $1; }
    ;

operand:
    VARIABLE 
    { 
        $$ = $1; 
        addTempUse($1); 
    }
    | NUMBER 
    { 
        $$ = $1; //numbers cant be live (5 is always 5 no need to be produced) so it just keeps its value
    }
    ;

%%

void yyerror(const char *s) {

}

int main() {
    yyparse();
    return 0;
}
\
