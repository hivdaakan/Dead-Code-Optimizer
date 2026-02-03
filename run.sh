rm -f lex.yy.c y.tab.c y.tab.h project
yacc -d project.y
lex project.l
g++ -w lex.yy.c y.tab.c -o project
tail -r input.txt | ./project | tail -r
