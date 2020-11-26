%{

#include <stdio.h>
#include <stdlib.h>
#ifndef YYSTYPE
#define YYSTYPE double
#endif

int yylex();
extern int yyparse();
FILE* yyin;

void yyerror(const char* s);

%}


%token NUMBER
%token ADD 
%token DESIV
%token MULTI
%token MUL
%token LP
%token RP

%left ADD DESIV
%left MULTI MUL
%right UMINUS



%%


lines   :   lines expr ';' {printf("%f\n",$2 );}
        |   lines ';'
        |
        ;



expr    :   expr ADD expr { $$ = $1 + $3; }
        |   expr DESIV expr { $$ = $1 - $3; }
        |   expr MULTI expr { $$ = $1 * $3; }
        |   expr MUL expr { $$ = $1 / $3; }
        |   LP expr RP { $$ = $2; }
        |   DESIV expr %prec UMINUS { $$ = -$2; }
        |   NUMBER
        ;




%%

int yylex()
{
    int t;
    while(1)
    {
        t = getchar();
        if (t == ' '|| t == '\t' || t == '\n' )
        {
            ;
        }else if(t == '+')
        {
            return ADD;
        }else if(t == '-')
        {
            return DESIV;
        }else if (t == '*')
        {
            return MULTI;
        }else if (t == '/')
        {
            return MUL;
        }else if(t == '(')
        {
            return LP;
        }else if(t == ')')
        {
            return RP;
        }else if (isdigit(t))
        {
            yylval = 0 ;
            while(isdigit(t)){
                yylval = yylval * 10 + t - '0';
                t = getchar();
            }
            ungetc(t,stdin);
            return NUMBER;
        }else
        {
            return t ;
        }
    }
}


int main(void)
{
    yyin = stdin;
    do{
        yyparse();
    }while(!feof(yyin));
    return 0;
}

void yyerror(const char* s){
    fprintf(stderr, "Parse error:%s\n", s);
    exit(1);
}
