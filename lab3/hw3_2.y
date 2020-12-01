%{

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#ifndef YYSTYPE
#define YYSTYPE char*
#endif

int yylex();
extern int yyparse();
FILE* yyin;
char NUMSTR[50];
char IDSTR[50];
void yyerror(const char* s);

%}


 
%token NUMBER
%token ID
%token LP
%token RP
%token ADD
%token DESIV
%token MULTI
%token MUL

%left ADD DESIV
%left MULTI MUL
%right UMINUS



%%


lines   : lines expr ';'{ printf("%s\n", $2); }
        | lines ';'
        |
        ;



expr    :   expr ADD expr { $$ = (char*)malloc(50*sizeof(char)); strcpy($$,$1);strcat($$,$3);strcat($$,"+"); }
        |   expr DESIV expr { $$ = (char*)malloc(50*sizeof(char)); strcpy($$,$1);strcat($$,$3);strcat($$,"-");  }
        |   expr MULTI expr { $$ = (char*)malloc(50*sizeof(char)); strcpy($$,$1);strcat($$,$3);strcat($$,"*");  }
        |   expr MUL expr { $$ = (char*)malloc(50*sizeof(char)); strcpy($$,$1);strcat($$,$3);strcat($$,"/");  }
        |   LP expr RP { $$ = (char*)malloc(50*sizeof(char)); strcpy($$,$2); }
        |   DESIV expr %prec UMINUS { $$ = (char*)malloc(50*sizeof(char)) ;strcpy($$,"-");strcat($$,$2);  }
        |   NUMBER {$$ = (char*)malloc(50*sizeof(char));strcpy($$,$1);strcat($$," "); }
        |   ID {$$ = (char*)malloc(50*sizeof(char));strcpy($$,$1);strcat($$," ");}
        ;




%%

int yylex()
{
    int t;
    int ti;
    ti = 0;
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
        }else if (t >= '0' && t <= '9')
        {
            ti = 0;
            while(t >= '0' && t <= '9')
            {
                NUMSTR[ti] = t;
                t = getchar();
                ti++;
            }
            NUMSTR[ti] ='\0';
            yylval = NUMSTR;
            ungetc(t,stdin);
            return NUMBER;
        }else if ((t >= 'a' && t <= 'z') || (t >= 'A' && t <= 'Z') || t == '_')
        {
            ti = 0 ;
            while((t >= 'a' && t <= 'z') || (t >= 'A' && t <= 'Z') || t == '_' || t >= '0' && t <= '9')
            {
                IDSTR[ti] = t;
                t = getchar();
                ti++;
            }
            IDSTR[ti] ='\0';
            yylval = IDSTR;
            ungetc(t,stdin);
            return ID;
        }else
        {
            return t;
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
