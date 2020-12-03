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
%token LOG_MASS LOG_RB LOG_LB LOG_RAB LOG_LAB

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
| single_expr   {$$ = $1;}
;

single_expr
: LOP_MADD IDENTIFIER {
    TreeNode* node = new TreeNode(lineno,NODE_STMT);
    node->addChild($2);
    $$ = node;
}
| LOP_MSUB IDENTIFIER {
    TreeNode* node = new TreeNode(lineno,NODE_STMT);
    node->addChild($2);
    $$ = node;
}
declaration
: T IDENTIFIER LOP_ASSIGN expr{  // declare and init
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

expr
: IDENTIFIER {
    $$ = $1;
}
| INTEGER {
    $$ = $1;
}
| CHAR {
    $$ = $1;
}
| STRING {
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
: SEN_IF LP expr RP LB statements RB {
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

%%

int yyerror(char const* message)
{
  cout << message << " at line " << lineno << endl;
  return -1;
}
