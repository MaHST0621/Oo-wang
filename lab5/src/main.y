%{
    #include "common.h"
    #define YYSTYPE TreeNode *  
    TreeNode* root;
    extern int lineno;
    int yylex();
    int yyerror( char const * );
%}
%token T_CHAR T_INT T_STRING T_BOOL T_VOID

%token LOP_ASSIGN 

%token SEMICOLON COMMA LB RB LP RP

%token IDENTIFIER INTEGER CHAR BOOL STRING

%token IF WHILE ELSE FOR

%token OR AND BOR BAND XOR ADD SUB MULT DIV MOD NOT UMINUS SADD SSUB

%token GT LT GEQ LEQ EQU NEQ 

%token PRINTF SCANF

%token RETURN CONST

%token BREAK CONTINUE

%token ADDEQ SUBEQ MULTEQ DIVEQ MODEQ

%left LOP_ASSIGN
%left OR
%left AND
%left BOR
%left XOR
%left BAND
%left EQU NEQ
%left GT LT GEQ LEQ 
%left ADD SUB
%left MULT DIV MOD 
%right NOT
%right UMINUS
%left SADD SSUB
%nonassoc LOWER_THEN_ELSE
%nonassoc ELSE 

%%

program
: statements {root = new TreeNode(0, NODE_PROG); root->addChild($1);
}
;

statements
:  statement {$$=$1;}
|  statements statement {$$=$1; $$->addSibling($2);}
;

statement
: Decl SEMICOLON{$$ = $1;}
| AssignStmt SEMICOLON {$$=$1;}
| Block {$$=$1;}
| EXP SEMICOLON {$$=$1;}
| IF_ELSE {$$=$1;}
| for {$$=$1;}
| while {$$=$1;}
| break {$$=$1;}
| function {$$=$1;}
| continue {$$=$1;}
| return {$$=$1;}
| printf {$$=$1;}
| scanf {$$=$1;}
| SEMICOLON  {$$ = new TreeNode(lineno, NODE_STMT); $$->stype = STMT_SKIP;}
;


Decl
: ConstDecl {$$=$1;}
| VarDecl {$$=$1;}
;

T: T_INT {$$ = new TreeNode(lineno, NODE_TYPE); $$->type = TYPE_INT;} 
| T_CHAR {$$ = new TreeNode(lineno, NODE_TYPE); $$->type = TYPE_CHAR;}
| T_BOOL {$$ = new TreeNode(lineno, NODE_TYPE); $$->type = TYPE_BOOL;}
| T_VOID {$$=new TreeNode(lineno,NODE_TYPE); $$->type=TYPE_VOID;}
;

ArrayID
: IDENTIFIER '[' ConstExpr ']' {
     
}
| ArrayID '[' ConstExpr ']' {

}
;

ConstDecl
: CONST T ConstDefList{
    TreeNode* node=new TreeNode($2->lineno,NODE_STMT);
    node->stype=STMT_CONST;
    node->addChild($2);
    node->addChild($3);
    $$=node;
};

ConstDefList
: ConstDef {$$=$1;}
| ConstDef COMMA ConstDefList {
    $$->addSibling($3);
    $$=$1;
}
;

ConstDef
: ArrayID LOP_ASSIGN InitVal{
    $1->addSibling($3);
    $$=$1;
}
| IDENTIFIER LOP_ASSIGN InitVal{
    $1->addSibling($3);
    $$=$1;
}
;

VarDecl
: T VarDefList {
    TreeNode* node = new TreeNode($1->lineno, NODE_STMT);
    node->stype=STMT_DECL;
    node->addChild($1);
    node->addChild($2);
    $$=node;
}
;

VarDef
: IDENTIFIER LOP_ASSIGN InitVal{
    $1->addSibling($3);
    $$=$1;
}
| ArrayID LOP_ASSIGN '{' InitValList '}' {
    $$=$2;
    $1->addSibling($4);
    $$=$1;
}
| ArrayID{$$=$1;}
| IDENTIFIER{$$=$1;}
;

VarDefList
: VarDef {$$=$1;}
| VarDef COMMA VarDefList {
    $1->addSibling($3);
    $$=$1;
}
;



InitVal
: ConstExpr {$$=$1;}
| '{' InitValList '}' {
    $$=$2;
}
;

InitValList 
: InitVal {
    $$=$1;
}
| InitVal COMMA InitValList{
    $1->addSibling($3);
    $$=$1;
}
;



function
: T IDENTIFIER LP RP Block {
	TreeNode* node=new TreeNode($2->lineno,NODE_STMT);
	node->stype=STMT_FUNCTION;
	node->addChild($1);
	node->addChild($2);
	node->addChild($5);
	$$=node;
}
| T IDENTIFIER LP FUNCFPARAMS RP Block {
	TreeNode* node=new TreeNode($2->lineno,NODE_STMT);
	node->stype=STMT_FUNCTION;
	node->addChild($1);
	node->addChild($2);
	$2->addChild($4);
	node->addChild($5);
	$$=node;
}
;

FUNCFPARAMS
: FUNCFPARAM {$$=$1;}
| FUNCFPARAM COMMA FUNCFPARAMS {
	$1->addSibling($3);
	$$=$1;
}
;

FUNCFPARAM
: T IDENTIFIER {
	$1->addChild($2);
	$$=$1;
}
;

printf
    : PRINTF LP STRING COMMA EXP RP SEMICOLON {
        TreeNode *node=new TreeNode($1->lineno,NODE_STMT);
        node->stype=STMT_PRINTF;
        node->addChild($3);
        node->addChild($5);
        $$=node;
    }
    ;
scanf
    : SCANF LP STRING COMMA EXP RP SEMICOLON {
        TreeNode *node=new TreeNode($1->lineno,NODE_STMT);
        node->stype=STMT_SCANF;
        node->addChild($3);
        node->addChild($5);
        $$=node;
    }
    ;

Block
: LB BlockItemList RB {
    TreeNode* node = new TreeNode($1->lineno, NODE_PROG);
    node->addChild($2);
    $$=node;
}
;

BlockItemList
: BlockItem BlockItemList {
    $1->addSibling($2);
    $$=$1;
}
| BlockItem {
    $$=$1;
}
;

BlockItem
: statement{$$=$1;}
;


AssignStmt
: Lval LOP_ASSIGN EXP {
    TreeNode* node = new TreeNode($1->lineno, NODE_STMT);
    node->stype=STMT_ASSIGN;
    node->addChild($1);
    node->addChild($3);
    $$=node;
}
| Lval ADDEQ EXP {
    TreeNode* node = new TreeNode($1->lineno, NODE_STMT);
    node->stype=STMT_ADD_ASSIGN;
    node->addChild($1);
    node->addChild($3);
    $$=node;
}
| Lval SUBEQ EXP {
    TreeNode* node = new TreeNode($1->lineno, NODE_STMT);
    node->stype=STMT_SUB_ASSIGN;
    node->addChild($1);
    node->addChild($3);
    $$=node;
}
| Lval MULTEQ EXP {
    TreeNode* node = new TreeNode($1->lineno, NODE_STMT);
    node->stype=STMT_MULT_ASSIGN;
    node->addChild($1);
    node->addChild($3);
    $$=node;
}
| Lval DIVEQ EXP {
    TreeNode* node = new TreeNode($1->lineno, NODE_STMT);
    node->stype=STMT_DIV_ASSIGN;
    node->addChild($1);
    node->addChild($3);
    $$=node;
}
| Lval MODEQ EXP {
    TreeNode* node = new TreeNode($1->lineno, NODE_STMT);
    node->stype=STMT_MOD_ASSIGN;
    node->addChild($1);
    node->addChild($3);
    $$=node;
}
;

IF_ELSE
: IF LP Cond RP statement %prec LOWER_THEN_ELSE {
    TreeNode* node = new TreeNode($1->lineno, NODE_STMT);
    node->stype=STMT_IF;
    node->addChild($3);
    node->addChild($5);
    $$=node;
}
| IF LP Cond RP statement ELSE statement {
    TreeNode* node=new TreeNode($1->lineno,NODE_STMT);
    node->stype=STMT_IF;
    node->addChild($3);
    node->addChild($5);
    node->addChild($7);
    $$=node;
}
;

for
: FOR LP EXP SEMICOLON Cond SEMICOLON EXP RP LB statements RB {
    TreeNode* node = new TreeNode($3->lineno,NODE_STMT);
    node->stype=STMT_FOR;
    node->addChild($3);
    node->child->addChild($5);
    node->child->addChild($7);
    node->addChild($10);
    $$ = node;}
| FOR LP VarDecl SEMICOLON Cond SEMICOLON EXP RP Block {
    TreeNode* node = new TreeNode($3->lineno,NODE_STMT);
    node->stype=STMT_FOR;
    node->addChild($3);
    node->child->addChild($5);
    node->child->addChild($7);
    node->addChild($9);
    $$ = node;}
| FOR LP SEMICOLON Cond SEMICOLON EXP RP Block {
    TreeNode* node = new TreeNode($4->lineno,NODE_STMT);
    TreeNode* node2 = new TreeNode($4->lineno,NODE_STMT);
    node->stype=STMT_FOR;
    node2->stype=STMT_SKIP;
    node->addChild(node2);
    node->child->addChild($4);
    node->child->addChild($6);
    node->addChild($8);
    $$ = node;}
| FOR LP EXP SEMICOLON SEMICOLON EXP RP Block {
    TreeNode* node = new TreeNode($3->lineno,NODE_STMT);
    TreeNode* node2 = new TreeNode($3->lineno,NODE_STMT);
    node->stype=STMT_FOR;
    node2->stype=STMT_SKIP;
    node->addChild($3);
    node->child->addChild(node2);
    node->child->addChild($6);
    node->addChild($8);
    $$ = node;}
| FOR LP EXP SEMICOLON EXP SEMICOLON RP Block {
    TreeNode* node = new TreeNode($3->lineno,NODE_STMT);
    TreeNode* node2 = new TreeNode($3->lineno,NODE_STMT);
    node->stype=STMT_FOR;
    node2->stype=STMT_SKIP;
    node->addChild($3);
    node->child->addChild($5);
    node->child->addChild(node2);
    node->addChild($8);
    $$ = node;}
| FOR LP SEMICOLON SEMICOLON EXP RP Block {
    TreeNode* node = new TreeNode($5->lineno,NODE_STMT);
    TreeNode* node2 = new TreeNode($5->lineno,NODE_STMT);
    TreeNode* node3=new TreeNode($5->lineno,NODE_STMT);
    node->stype=STMT_FOR;
    node2->stype=STMT_SKIP;
    node3->stype=STMT_SKIP;
    node->addChild(node2);
    node->child->addChild(node3);
    node->child->addChild($5);
    node->addChild($7);
    $$ = node;}
| FOR LP SEMICOLON EXP SEMICOLON RP Block {
    TreeNode* node = new TreeNode($4->lineno,NODE_STMT);
    TreeNode* node2 = new TreeNode($4->lineno,NODE_STMT);
    TreeNode* node3=new TreeNode($4->lineno,NODE_STMT);
    node->stype=STMT_FOR;
    node2->stype=STMT_SKIP;
    node3->stype=STMT_SKIP;
    node->addChild(node2);
    node->child->addChild($4);
    node->child->addChild(node3);
    node->addChild($7);
    $$ = node;}
| FOR LP EXP SEMICOLON SEMICOLON RP Block {
    TreeNode* node = new TreeNode($3->lineno,NODE_STMT);
    TreeNode* node2 = new TreeNode($3->lineno,NODE_STMT);
    TreeNode* node3=new TreeNode($3->lineno,NODE_STMT);
    node->stype=STMT_FOR;
    node2->stype=STMT_SKIP;
    node3->stype=STMT_SKIP;
    node->addChild($3);
    node->child->addChild(node2);
    node->child->addChild(node3);
    node->addChild($7);
    $$ = node;}
| FOR LP SEMICOLON SEMICOLON RP Block {
    TreeNode* node = new TreeNode($1->lineno,NODE_STMT);
    TreeNode* node2 = new TreeNode($1->lineno,NODE_STMT);
    TreeNode* node3=new TreeNode($1->lineno,NODE_STMT);
    TreeNode* node4=new TreeNode($1->lineno,NODE_STMT);
    node->stype=STMT_FOR;
    node2->stype=STMT_SKIP;
    node3->stype=STMT_SKIP;
    node4->stype=STMT_SKIP;
    node->addChild(node2);
    node->child->addChild(node3);
    node->child->addChild(node4);
    node->addChild($6);
    $$ = node;}
;

while
: WHILE LP Cond RP Block{
    TreeNode* node=new TreeNode($1->lineno,NODE_STMT);
    node->stype=STMT_WHILE;
    node->addChild($3);
    node->addChild($5);
    $$=node;
}
;

return
: RETURN SEMICOLON {
    TreeNode* node=new TreeNode($1->lineno,NODE_STMT);
    node->stype=STMT_RETURN;
    $$=node;
}
| RETURN EXP SEMICOLON {
    TreeNode* node=new TreeNode($1->lineno,NODE_STMT);
    node->stype=STMT_RETURN;
    node->addChild($2);
    $$=node;
}
;

break
: BREAK SEMICOLON {
    TreeNode* node=new TreeNode($1->lineno,NODE_STMT);
    node->stype=STMT_BREAK;
    $$=node;
}
;
continue
: CONTINUE SEMICOLON {
    TreeNode* node=new TreeNode($1->lineno,NODE_STMT);
    node->stype=STMT_CONTINUE;
    $$=node;
}
;
EXP
: AddExp {$$=$1;}
;

Cond
: LOrExp {$$=$1;}
;

Lval
: IDENTIFIER {$$=$1;}
| ArrayID {$$=$1;}
;

PrimaryExp
: '(' EXP ')' {$$=$2;}
| Lval {$$=$1;}
| NUMBER {$$=$1;}
| CHAR {$$=$1;}
;

NUMBER
: INTEGER {$$=$1;}
;

UnaryExp
: PrimaryExp {$$=$1;}
| ADD UnaryExp {
    $1->addChild($2);
    $$=$1;
}
| SUB UnaryExp %prec UMINUS {
    $1->addChild($2);
    $$=$1;
}
| NOT UnaryExp {
    $1->addChild($2);
    $$=$1;
}
| UnaryExp SADD {
    $2->addChild($1);
    $$=$2;
}
| UnaryExp SSUB {
    $2->addChild($1);
    $$=$2;
}
;

MulExp 
: MulExp MULT UnaryExp { 
    $2->addChild($1);
    $2->addChild($3);
    $$=$2;
}
| MulExp DIV UnaryExp { 
    $2->addChild($1);
    $2->addChild($3);
    $$=$2;
}
| MulExp MOD UnaryExp { 
    $2->addChild($1);
    $2->addChild($3);
    $$=$2;
}
| UnaryExp {$$=$1;}
;

AddExp  
: MulExp {$$=$1;}
| AddExp ADD MulExp {
    $2->addChild($1);
    $2->addChild($3);
    $$=$2;
}
| AddExp SUB MulExp {
    $2->addChild($1);
    $2->addChild($3);
    $$=$2;
}
;

RelExp
: AddExp {$$=$1;}
| RelExp LT AddExp {
    $2->addChild($1);
    $2->addChild($3);
    $$=$2;
}
| RelExp GT AddExp {
    $2->addChild($1);
    $2->addChild($3);
    $$=$2;
}
| RelExp LEQ AddExp {
    $2->addChild($1);
    $2->addChild($3);
    $$=$2;
}
| RelExp GEQ AddExp {
    $2->addChild($1);
    $2->addChild($3);
    $$=$2;
}
;

EqExp
: RelExp {$$=$1;}
| EqExp EQU RelExp {
    $2->addChild($1);
    $2->addChild($3);
    $$=$2;
}
| EqExp NEQ RelExp {
    $2->addChild($1);
    $2->addChild($3);
    $$=$2;
}
;

LAndExp
: EqExp {$$=$1;}
| LAndExp AND EqExp {
    $2->addChild($1);
    $2->addChild($3);
    $$=$2;
}
;

LOrExp
: LAndExp {$$=$1;}
| LOrExp OR LAndExp {
    $2->addChild($1);
    $2->addChild($3);
    $$=$2;
}
;

ConstExpr
: AddExp {$$=$1;}
;

%%

int yyerror(char const* message)
{
  cout << message << " at line " << lineno << endl;
  return -1;
}
