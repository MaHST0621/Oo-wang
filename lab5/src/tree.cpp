#include "tree.h"
static int nodeaddr = 0;
void TreeNode::addChild(TreeNode* child) {
    if(this->child)
    {
        TreeNode* tmp = this->child;
        while(tmp->sibling)
        {
            tmp = tmp->sibling;
        }
        tmp->sibling = child;
    }
    else
    {
        this->child = child;
    }
        

}

void TreeNode::addSibling(TreeNode* sibling){
    if(this->sibling)
    {
        TreeNode* tmp = this->sibling;
        while(tmp->sibling)
        {
            tmp = tmp->sibling;
        }
        tmp->sibling = sibling;
    }
    else
    {
        this->sibling = sibling;
    }
}

TreeNode::TreeNode(int lineno, NodeType type) {
    this->nodeType = type;
    this->lineno = lineno;

}

void TreeNode::genNodeId() {
    this->nodeID = nodeaddr++;
    if(this->sibling)
    {
        this->sibling->genNodeId();
    }
    if(this->child)
    {
        this->child->genNodeId();
    }
}

void TreeNode::printNodeInfo() {
   cout<<"ln@"<<std::left << std::setw(3)<<this->lineno<<"@"<<std::left << std::setw(3)<<this->nodeID<<std::left << std::setw(15)<<this->nodeType2String(this->nodeType);

}

void TreeNode::printChildrenId() {
    string childrenId="[";
    if(this->child)
        {
            childrenId+="@";
            childrenId+=to_string(this->child->nodeID);
            childrenId+=" ";
            TreeNode* temp=this->child;
            while(temp->sibling)
            {
                childrenId+="@";
                childrenId+=to_string(temp->sibling->nodeID);
                childrenId+=" ";
                temp = temp->sibling;   
            }
        }
    childrenId+="]";
    cout<<"children:" <<std::left << std::setw(20)<< childrenId<<"  ";
}
void TreeNode::printAST() {
    this->printNodeInfo();
    this->printChildrenId();
    this->printSpecialInfo();
    if(this->child)
    {
        this->child->printAST();
    }
    if(this->sibling)
    {
        this->sibling->printAST();
    }

}


// You can output more info...
void TreeNode::printSpecialInfo() {
    switch(this->nodeType){
        case NODE_CONST:
            break;
        case NODE_VAR:
            cout<<std::left<<"var_name:"<<this->var_name<<endl;
            break;
        case NODE_EXPR:
            cout<<"expr:"<<this->opType2String(this->optype)<<endl;
            break;
        case NODE_STMT:
            cout<<"STMT:"<<this->sType2String(this->stype)<<endl;
            break;
        case NODE_TYPE:
            cout<<std::left<<"dec_type:"<<this->type->getTypeInfo()<<endl;
            break;
        case NODE_PROG:
            cout<<"PROG"<<endl;
        default:
            break;
            
    }
}

string TreeNode::sType2String(StmtType type) {
    switch(type)
    {
        case STMT_IF:
            return "smt-if";
        case STMT_FOR:
            return "smt-for";
        case STMT_DECL:
            return "smt-decl";
        case STMT_WHILE:
            return "smt-while";
        case STMT_PRINTF:
            return "smt-printf";
        case STMT_SKIP:
            return "smt-skip";
    }
}



string TreeNode::nodeType2String (NodeType type){
    switch(type)
    {
        case NODE_VAR:
            return "var";
        case NODE_EXPR:
            return "expr";
        case NODE_PROG:
            return "prog";
        case NODE_STMT:
            return "stmt";
        case NODE_TYPE:
            return "type";
        case NODE_CONST:
            return "const";
    }
}string TreeNode::opType2String(OperatorType type)
{
    switch(type)
    {
        case OP_ASSIGN:
            return "=";
        case OP_ADD:
            return "+";
        case OP_SUB:
            return "-";
        case OP_MUL:
            return "*";
        case OP_DEV:
            return "/";
        case OP_LB:
            return ">";
        case OP_OR:
            return "||";
        case OP_RB:
            return "<";
        case OP_AND:
            return "&&";
        case OP_LAB:
            return ">=";
        case OP_RAB:
            return "<=";
        case OP_MADD:
            return "++";
        case OP_MASS:
            return "==";
        case OP_MNOT:
            return "!=";
        case OP_MSUB:
            return "--";
    }

}
