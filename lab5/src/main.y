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
: statements {cout<<1<<endl;root = new TreeNode(0, NODE_PROG); root->addChild($1);};

statements
:  statement {cout<<2<<endl;$$=$1;}
|  statements statement {cout<<3<<endl;$$=$1; $$->addSibling($2);}
;

statement
: SEMICOLON  {$$ = new TreeNode(lineno, NODE_STMT); $$->stype = STMT_SKIP;}
| LB statement RB {cout<<4<<endl;$$ = $2;}
| declaration SEMICOLON {$$ = $1;}
| if_stm {cout<<5<<endl;$$ = $1;}
| printf_stm {$$ = $1;}
;

declaration
: T IDENTIFIER LOP_ASSIGN Number{  // declare and init
    cout<<6<<endl;
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
: SEN_PRINTF LP IDENTIFIER RP {
    TreeNode* node = new TreeNode(lineno,NODE_STMT);
    node->addChild($3);
    $$ = node;
}

if_stm
: SEN_IF LP Number RP LB statements RB {
    cout<<7<<endl;
    TreeNode* node = new TreeNode(lineno,NODE_STMT);
    node->stype = STMT_IF;
    node->addChild($3);
    node->addChild($6);
    $$ = node;
}



T
: T_INT {cout<<8<<endl;$$ = new TreeNode(lineno, NODE_TYPE); $$->type = TYPE_INT;} 
| T_CHAR {$$ = new TreeNode(lineno, NODE_TYPE); $$->type = TYPE_CHAR;}
| T_BOOL {$$ = new TreeNode(lineno, NODE_TYPE); $$->type = TYPE_BOOL;}
;

expr
:   Addexpr 
;
LVal
:   IDENTIFIER
;
//基本表达式
Primaryexpr
:   LP expr RP
|   LVal
|   Number
;
//条件表达式
Cond
:   LOrexpr
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
:   Primaryexpr
|   UnaryOp Unaryexpr
;
//单目运算符
UnaryOp
:   LOP_ADD
|   LOP_SUB
|   LOP_NOT 
;
//乘除表达式
Mulexpr
:   Unaryexpr
|   Addexpr LOP_ADD Mulexpr
|   Addexpr LOP_SUB Mulexpr
;
//加减表达式
Addexpr 
:   Mulexpr
|   Addexpr LOP_ADD Mulexpr
|   Addexpr LOP_SUB Mulexpr
;
//关系表达式
Relexpr
:   Addexpr
|   Relexpr RelOp Addexpr
;
//相等性表达式
Eqexpr
:   Relexpr
|   Eqexpr LOG_MASS Relexpr
|   Eqexpr LOG_MNOT Relexpr
;

//逻辑与表达式
LAndexpr
:   Eqexpr
|   LAndexpr LOG_AND Eqexpr
;
//逻辑或表达式
LOrexpr
:   LAndexpr
|   LOrexpr LOG_OR LAndexpr 
;
%%

int yyerror(char const* message)
{
  cout << message << " at line " << lineno << endl;
  return -1;
}
