%option nounput
%{
#include "common.h"
#include "main.tab.h"  // yacc header
int lineno=1;
%}
BLOCKCOMMENT \/\*([^\*^\/]*|[\*^\/*]*|[^\**\/]*)*\*\/
LINECOMMENT \/\/[^\n]*
EOL	(\r\n|\r|\n)
WHILTESPACE [[:blank:]]

INTEGER [0-9]+

CHAR \'.?\'
STRING \".+\"

/* IDENTIFIER [[:alpha:]_][[:alpha:][:digit:]_]* */
IDENTIFIER [a-zA-Z][_a-zA-Z0-9]*

LOP_ASSIGN   "="
LOP_ADD     "+"     
LOP_SUB     "-"
LOP_MUL     "*"
LOP_DEV     "/"

LOG_MASS   "=="
LOG_MNOT   "!="
LOG_RB     "<"
LOG_RAB    "<="
LOG_LB     ">"
LOG_LAB    ">="
LOG_OR     "||"
LOG_AND    "&&"

LOP_MADD   "++"
LOP_MSUB   "--"


%%

{BLOCKCOMMENT}  /* do nothing */
{LINECOMMENT}  /* do nothing */
"if"  return SEN_IF;
"while" return SEN_WHILE;
"for"  return SEN_FOR;
"printf" return SEN_PRINTF;
"scanf" return SEN_SCANF;

"int" return T_INT;
"bool" return T_BOOL;
"char" return T_CHAR;

";" return SEMICOLON;
"," return COMMA;
"(" return LP;
")" return RP;
"{" return LB;
"}" return RB;

{INTEGER} {
    TreeNode* node = new TreeNode(lineno, NODE_CONST);
    node->type = TYPE_INT;
    node->int_val = atoi(yytext);
    yylval = node;
    return INTEGER;
}

{CHAR} {
    TreeNode* node = new TreeNode(lineno, NODE_CONST);
    node->type = TYPE_CHAR;
    node->int_val = yytext[1];
    yylval = node;
    return CHAR;
}

{IDENTIFIER} {
    TreeNode* node = new TreeNode(lineno, NODE_VAR);
    node->var_name = string(yytext);
    yylval = node;
    return IDENTIFIER;
}
{STRING} {
    TreeNode* node = new TreeNode(lineno,NODE_CONST);
    node->type = TYPE_STRING;
    yylval = node;
    return STRING;
        }

{WHILTESPACE} /* do nothing */

{LOP_ASSIGN}    {TreeNode* node = new TreeNode(lineno,NODE_EXPR);yylval = node;return LOP_ASSIGN;}
{LOP_ADD}   {TreeNode* node = new TreeNode(lineno,NODE_EXPR);yylval = node;return LOP_ADD;}
{LOP_SUB}   {TreeNode* node = new TreeNode(lineno,NODE_EXPR);yylval = node;return LOP_SUB;}
{LOP_MUL}   {TreeNode* node = new TreeNode(lineno,NODE_EXPR);yylval = node;return LOP_MUL;}
{LOP_DEV}   {TreeNode* node = new TreeNode(lineno,NODE_EXPR);yylval = node;return LOP_DEV;}



{LOG_MASS}  {TreeNode* node = new TreeNode(lineno,NODE_EXPR);yylval = node;return LOG_MASS;}
{LOG_MNOT}  {TreeNode* node = new TreeNode(lineno,NODE_EXPR);yylval = node;return LOG_RB;}
{LOG_RB}    {TreeNode* node = new TreeNode(lineno,NODE_EXPR);yylval = node;return LOG_RB;}
{LOG_RAB}   {TreeNode* node = new TreeNode(lineno,NODE_EXPR);yylval = node;return LOG_RAB;}
{LOG_LB}    {TreeNode* node = new TreeNode(lineno,NODE_EXPR);yylval = node;return LOG_LAB;}
{LOG_LAB}   {TreeNode* node = new TreeNode(lineno,NODE_EXPR);yylval = node;return LOG_LAB;}
{LOG_OR}    {TreeNode* node = new TreeNode(lineno,NODE_EXPR);yylval = node;return LOG_OR;}
{LOG_AND}   {TreeNode* node = new TreeNode(lineno,NODE_EXPR);yylval = node;return LOG_AND;}

{LOP_MADD}  {TreeNode* node = new TreeNode(lineno,NODE_EXPR);yylval = node;return LOP_MADD;}
{LOP_MSUB}  {TreeNode* node = new TreeNode(lineno,NODE_EXPR);yylval = node;return LOP_SUB;}




{EOL} lineno++;

. {
    cerr << "[line "<< lineno <<" ] unknown character:" << yytext << endl;
}
%%
