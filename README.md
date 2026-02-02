# Dead-Code-Optimizer
A Lex/Yacc based dead code elimination tool using backward liveness analysis.
The objective of this project is to design and implement a Dead Code Elimination optimizer for an
Intermediate Language.The input is given as an intermediate language code and the goal is to
analyze this code and keep only the parts needed for a future calculation.By this way the output
will be free of dead code and leave only the essential ones.

For optimization,I used this command in my run.sh script : tail-r input.txt | ./project | tail-r
This process follows three steps:
1.Reverse : The input is reversed using tail-r.This is necessary because knowing the final result is
the only way to decide if the previous lines are necessary.

2.Analyze : My Lex/Yacc program processes the code from bottom to top.It keeps alive variables
and deletes dead code.

3.Restore : The optimized output is reversed again to return it to its original order.

To run the optimizer on your own intermediate code:
Ensure you have Lex and Yacc installed.
Give execution permission: chmod +x run.sh
Execute the script: ./run.sh
