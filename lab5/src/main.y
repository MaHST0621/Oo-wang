%{
    #include "common.h"
    #define YYSTYPE TreeNode *  
    TreeNode* root;
    extern int lineno;
    int yylex();
    int yyerror( char const * );
%}
%token SEN_IF SEN_WHILE SEN_FOR SEN_PRINTF SEN_SCANF
%token T_CHAR T_INT T_STRING T_BOOL 
%token LOP_ASSIGN LOP_ADD LOP_SUB LOP_DEV LOP_MUL
%token SEMICOLON COMMA LP RP LB RB
%token IDENTIFIER INTEGER CHAR BOOL STRING
%token LOP_MADD LOP_MSUB
%token LOG_MASS LOG_MNOT LOG_RB LOG_LB LOG_RAB LOG_LAB LOG_AND LOG_OR

%left COMMA
%right LOP_NOT
%left LOP_MUL LOP_DEV
%left LOP_ADD LOP_SUB
%left LOP_MADD LOP_MSUB
%left LOG_LB LOG_RB LOG_LAB LOG_RAB  
%right LOG_MASS
%%

program
: statements {root = new TreeNode(0, NODE_PROG); root->addChild($1);};

statements
:  statement {$$=$1;}
|  statements statement {$$=$1; $$->addSibling($2);}
;

statement
: SEMICOLON  {$$ = new TreeNode(lineno, NODE_STMT); $$->stype = STMT_SKIP;}
| LB statement RB {$$ = $2;}
| declaration SEMICOLON {$$ = $1;}
| if_stm {$$ = $1;}
| printf_stm {$$ = $1;}
| while_stm {$$ = $1;}
;

declaration
: T IDENTIFIER LOP_ASSIGN Number{  // declare and init
    TreeNode* node = new TreeNode($1->lineno, NODE_STMT);
    node->stype = STMT_DECL;
    node->addChild($1);
    node->addChild($2);
    node->addChild($4);
    $$ = node;   
} 
| T IDENTIFIER {
    TreeNode* node = new TreeNode($1->lineno, NODE_STMT);
    node->stype = STMT_DECL;
    node->addChild($1);
    node->addChild($2);
    $$ = node;   
}
;

Ident
: IDENTIFIER {
    $$ = $1;
}
;
Number
: INTEGER {
    $$ = $1;
}
;
Char 
: CHAR {
    $$ = $1;
}
;
String 
: STRING {
    $$ = $1;
}
;

printf_stm
: SEN_PRINTF LP expr RP {
    TreeNode* node = new TreeNode(lineno,NODE_STMT);
    node->stype = STMT_PRINTF;
    node->addChild($3);
    $$ = node;
}

if_stm
: SEN_IF LP Cond  RP LB statements RB {
    
    TreeNode* node = new TreeNode(lineno,NODE_STMT);
    node->stype = STMT_IF;
    node->addChild($3);
    node->addChild($6);
    $$ = node;
}

while_stm
: SEN_WHILE LP Cond RP LB statements RB {
    TreeNode* node = new TreeNode(lineno,NODE_STMT);
    node->addChild($3);
    node->addChild($6);
    $$ = node;
}


T
: T_INT {$$ = new TreeNode(lineno, NODE_TYPE); $$->type = TYPE_INT;} 
| T_CHAR {$$ = new TreeNode(lineno, NODE_TYPE); $$->type = TYPE_CHAR;}
| T_BOOL {$$ = new TreeNode(lineno, NODE_TYPE); $$->type = TYPE_BOOL;}
;

expr
:   Addexpr {$$ = $1;}
;
LVal
:   IDENTIFIER {$$ = $1;}
;
//基本表达式
Primaryexpr
:   LP expr RP {
    $$ = $2;    
}
|   LVal {$$ = $1;}
|   Number {$$ = $1;}
;
//条件表达式
Cond
:   LOrexpr {$$ = $1;}
;
//关系运算符
RelOp
:   LOG_MASS
|   LOG_LB 
|   LOG_RB
|   LOG_LAB
|   LOG_RAB
;
//一元表达式
Unaryexpr
:   Primaryexpr {
    $$ = $1;
}
|   UnaryOp Unaryexpr {
    $1->addChild($2);
    $$ = $1;
}
;
//单目运算符
UnaryOp
:   LOP_ADD 
|   LOP_SUB 
|   LOP_NOT 
;
//乘除表达式
Mulexpr
:   Unaryexpr {
    $$ = $1;
}
|   Addexpr LOP_MUL Mulexpr {
    $2->addChild($1);
    $2->addChild($3);
    $$ = $2;
}
|   Addexpr LOP_DEV Mulexpr {
    $2->addChild($1);
    $2->addChild($3);
    $$ = $2;
}
;
//加减表达式
Addexpr 
:   Mulexpr {
    $$ = $1;
}
|   Addexpr LOP_ADD Mulexpr {
    $2->addChild($1);
    $2->addChild($3);
    $$ = $2;
}
|   Addexpr LOP_SUB Mulexpr{
    $2->addChild($1);
    $2->addChild($3);
    $$ = $2;
}
;
//关系表达式
Relexpr
:   Addexpr {
    $$ = $1;
}
|   Relexpr RelOp Addexpr {
    $2->addChild($1);
    $2->addChild($3);
    $$ = $2;
}
;
//相等性表达式
Eqexpr
:   Relexpr {
    $$ = $1;
}
|   Eqexpr LOG_MASS Relexpr {
    $2->addChild($1);
    $2->addChild($3);
    $$ = $2;
}
|   Eqexpr LOG_MNOT Relexpr {
    $2->addChild($1);
    $2->addChild($3);
    $$ = $2;
}
;

//逻辑与表达式
LAndexpr
:   Eqexpr {
    $$ = $1;
}
|   LAndexpr LOG_AND Eqexpr { 
    $2->addChild($1);
    $2->addChild($3);
    $$ = $2;
}
;
//逻辑或表达式
LOrexpr
:   LAndexpr {
    $$ = $1;
}
|   LOrexpr LOG_OR LAndexpr {
    $2->addChild($1);
    $2->addChild($3);
    $$ = $2;
} 
;
%%

int yyerror(char const* message)
{
  cout << message << " at line " << lineno << endl;
  return -1;
}
