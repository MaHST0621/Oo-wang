%option noyywrap
%{
	#include<math.h>
	int line=1;
	
%}
WORD [a-zA-Z]
ID ({WORD}|_)({WORD}|_|{DIGIT})*
OPT ("+"|"-"|"*"|"/"|"+="|"-="|"*="|"/="|">="|"<="|"=="|">"|"<"|"="|"++"|"--") 
BRACKET ("("|")"|"["|"]"|"{"|"}"|";"|","|"\'"|"\""|"#") 
DIGIT [0-9]
INTEGER [1-9]{DIGIT}*
OINTEGER ("+"|"-")?{INTEGER}
DECIMAL {OINTEGER}(.{INTEGER})
TYPE void|int|double|char
KEYWORD if|else|do|while|for|scanf|printf|sqrt|abs|main|return|float


%%
\n {++line;}
{TYPE}	{printf("\t%d\t%-10s\t%-10s\n",line,"type",yytext);}
{KEYWORD} {printf("\t%d\t%-10s\t%-10s\n",line,"keyword",yytext);}
{DIGIT} {printf("\t%d\t%-10s\t%-10s\n",line,"integer",yytext);} 
{INTEGER} {printf("\t%d\t%-10s\t%-10s\n",line,"integer",yytext);}
{ID} {printf("\t%d\t%-10s\t%-10s\n",line,"identy",yytext);}
{BRACKET} {printf("\t%d\t%-10s\t%-10s\n",line,"bracket",yytext);} 
{OPT} {printf("\t%d\t%-10s\t%-10s\n",line,"opt",yytext);}
{OINTEGER} {printf("\t%d\t%-10s\t%-10s\n",line,"integer",yytext);}
{DECIMAL} {printf("\t%d\t%-10s\t%-10s\n",line,"decimal",yytext);}



%%
int main(){
	printf("\t%s\t%-10s\t%-10s\t%-10s\n","line", "id_type", "id_name", "id_identy"); 
	yylex();
	return 0;
}



