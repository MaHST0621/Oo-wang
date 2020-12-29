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

LP "("
RP ")"
LB "{"
RB "}"

EQU "=="
NEQ "!="
LT  "<"
GT  ">"
LEQ "<="
GEQ ">="
AND "&&"
OR  "||"
BAND "&"
BOR  "|"
NOT !
ADD "+"
SUB "-"
MULT "*"
DIV "/"
MOD "%"
SADD "++"
SSUB "--"
IDENTIFIER [[:alpha:]_][[:alpha:][:digit:]_]*
%%

{BLOCKCOMMENT}  /* do nothing */
{LINECOMMENT}  /* do nothing */


"int" return T_INT;
"bool" return T_BOOL;
"char" return T_CHAR;
"void" return T_VOID;

"=" return LOP_ASSIGN;//赋值

"," return COMMA;
";" return  SEMICOLON;

"+=" return ADDEQ;
"-=" return SUBEQ;
"*=" return MULTEQ;
"/=" return DIVEQ;
"%=" return MODEQ;

"if" return IF;
"else" return ELSE;
"while" return WHILE;
"printf" return PRINTF;
"scanf" return SCANF;
"const" return CONST;
"return" return RETURN;
"break" return BREAK;
"continue" return CONTINUE;
"for" return FOR;

"{" return LB;
"}" return RB;
"(" return LP;
")" return RP;

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

{STRING} {
    TreeNode* node=new TreeNode(lineno, NODE_CONST);
    node->type=TYPE_STRING;
    node->str_val = string(yytext);
    yylval = node;
    return STRING;
}//常量

{EQU} {
    TreeNode* node=new TreeNode(lineno, NODE_EXPR);
    node->optype=OP_EQ;
    yylval = node;
    return EQU;
}

{NEQ} {
    TreeNode* node=new TreeNode(lineno, NODE_EXPR);
    node->optype=OP_NEQ;
    yylval = node;
    return NEQ;    
}

{LT} {
    TreeNode* node=new TreeNode(lineno, NODE_EXPR);
    node->optype=OP_LT;
    yylval = node;
    return LT;
}

{GT} {
    TreeNode* node=new TreeNode(lineno, NODE_EXPR);
    node->optype=OP_GT;
    yylval = node;
    return GT;
}

{LEQ} {
    TreeNode* node=new TreeNode(lineno, NODE_EXPR);
    node->optype=OP_LEQ;
    yylval = node;
    return LEQ;
}

{GEQ} {
    TreeNode* node=new TreeNode(lineno, NODE_EXPR);
    node->optype=OP_GEQ;
    yylval = node;
    return GEQ;
}

{AND} {
    TreeNode* node=new TreeNode(lineno, NODE_EXPR);
    node->optype=OP_AND;
    yylval = node;
    return AND;
}

{OR} {
    TreeNode* node=new TreeNode(lineno, NODE_EXPR);
    node->optype=OP_OR;
    yylval = node;
    return OR;
}

{NOT} {
    TreeNode* node=new TreeNode(lineno, NODE_EXPR);
    node->optype=OP_NOT;
    yylval = node;
    return NOT;
}

{BAND} {
    TreeNode* node=new TreeNode(lineno, NODE_EXPR);
    node->optype=OP_BAND;
    yylval = node;
    return BAND;
}

{BOR} {
    TreeNode* node=new TreeNode(lineno, NODE_EXPR);
    node->optype=OP_BOR;
    yylval = node;
    return BOR;
}

{ADD} {
    TreeNode* node=new TreeNode(lineno, NODE_EXPR);
    node->optype=OP_ADD;
    yylval = node;
    return ADD;
}

{SUB} {
    TreeNode* node=new TreeNode(lineno, NODE_EXPR);
    node->optype=OP_SUB;
    yylval = node;
    return SUB;
}

{MULT} {
    TreeNode* node=new TreeNode(lineno, NODE_EXPR);
    node->optype=OP_MULT;
    yylval = node;
    return MULT;
}

{DIV} {
    TreeNode* node=new TreeNode(lineno, NODE_EXPR);
    node->optype=OP_DIV;
    yylval = node;
    return DIV;
}

{MOD} {
    TreeNode* node=new TreeNode(lineno, NODE_EXPR);
    node->optype=OP_MOD;
    yylval = node;
    return MOD;
}

{SADD} {
    TreeNode* node=new TreeNode(lineno, NODE_EXPR);
    node->optype=OP_SADD;
    yylval = node;
    return SADD;
}

{SSUB} {
    TreeNode* node=new TreeNode(lineno, NODE_EXPR);
    node->optype=OP_SSUB;
    yylval = node;
    return SSUB;
}//表达式

{IDENTIFIER} {
    TreeNode* node = new TreeNode(lineno, NODE_VAR);
    node->var_name = string(yytext);
    yylval = node;
    return IDENTIFIER;
}//标识符

{WHILTESPACE} /* do nothing */

{EOL} lineno++;

. {
    cerr << "[line "<< lineno <<" ] unknown character:" << yytext << endl;
}
%%
