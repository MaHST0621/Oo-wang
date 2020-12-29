#ifndef TREE_H
#define TREE_H

#include "pch.h"
#include "type.h"

enum NodeType
{
    NODE_CONST, 
    NODE_VAR,
    NODE_EXPR,
    NODE_TYPE,

    NODE_STMT,
    NODE_PROG,
};

enum OperatorType
{
      // ==
    OP_AND,
    OP_OR,
    OP_ADD,
    OP_SUB,
    OP_EQ,
    OP_NEQ,
    OP_LT,
    OP_GT,
    OP_LEQ,
    OP_GEQ,
    OP_NOT,
    OP_BAND,
    OP_BOR,
    OP_MULT,
    OP_DIV,
    OP_MOD,
    OP_SADD,
    OP_SSUB,
};

enum StmtType {
    STMT_CONST,
    STMT_FUNCTION,
    STMT_SCANF,
    STMT_ASSIGN,
    STMT_ADD_ASSIGN,
    STMT_SUB_ASSIGN,
    STMT_MULT_ASSIGN,
    STMT_DIV_ASSIGN,
    STMT_MOD_ASSIGN,
    STMT_RETURN,
    STMT_BREAK,
    STMT_CONTINUE,
    STMT_SKIP,
    STMT_DECL,
    STMT_PRINTF,
    STMT_IF,
    STMT_FOR,
    STMT_WHILE,
}
;

struct TreeNode {
public:
    int nodeID;  // 用于作业的序号输出
    int lineno;
    NodeType nodeType;

    TreeNode* child = nullptr;
    TreeNode* sibling = nullptr;

    void addChild(TreeNode*);
    void addSibling(TreeNode*);
    
    void printNodeInfo();
    void printChildrenId();

    void printAST(); // 先输出自己 + 孩子们的id；再依次让每个孩子输出AST。
    void printSpecialInfo();

    void genNodeId();

public:
    OperatorType optype;  // 如果是表达式
    Type* type;  // 变量、类型、表达式结点，有类型。
    StmtType stype;
    int int_val;
    char ch_val;
    bool b_val;
    string str_val;
    string var_name;
public:
    static string nodeType2String (NodeType type);
    static string opType2String (OperatorType type);
    static string sType2String (StmtType type);

public:
    TreeNode(int lineno, NodeType type);
};

#endif
