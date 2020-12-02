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
   // cout<<std::left<<std::setw(3)<<"ln@"<<std::left<<std::setw(3)<<this->lineno<<std::left<<std::setw(3)<<"@"<<this->nodeID<<std::left << std::setw(12)<<this->nodeType2String(this->nodeType);
   cout<<"ln@"<<std::left << std::setw(3)<<this->lineno<<"@"<<std::left << std::setw(3)<<this->nodeID<<std::left << std::setw(12)<<this->nodeType2String(this->nodeType);

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
    cout<<"children: " <<std::left << std::setw(15)<< childrenId<<"  ";
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
            cout<<std::left<<"NODE_CONST:"<<this->int_val<<endl;
            break;
        case NODE_VAR:
            cout<<std::left<<"NODE_VAR:"<<this->var_name<<endl;
            break;
        case NODE_EXPR:
            cout<<"NODE_EXPR:"<<endl;
            break;
        case NODE_STMT:
            cout<<"NODE_STMT:"<<endl;
            break;
        case NODE_TYPE:
            cout<<std::left<<"NODE_TYPE:"<<this->type->getTypeInfo()<<endl;
            break;
        case NODE_PROG:
            cout<<"NODE_PROG:"<<endl;
        default:
            break;
            
    }
}

string TreeNode::sType2String(StmtType type) {
    return "?";
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
}
