#include "tree.h"
static int nodeaddr = 0;
void TreeNode::addChild(TreeNode* child) {
    if(this->child)
    {
        TreeNode* tmp = this->child->sibling;
        while(tmp)
        {
            tmp = tmp->sibling;
        }
        tmp = child;
    }
    else
    {
        this->child = child;
    }
        

}

void TreeNode::addSibling(TreeNode* sibling){
    if(this->sibling)
    {
        TreeNode* tmp = this->sibling->sibling;
        while(tmp)
        {
            tmp = tmp->sibling;
        }
        tmp = sibling;
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
    cout<<"children: " <<std::left << std::setw(15)<< childrenId<<endl;
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
            break;
        case NODE_EXPR:
            break;
        case NODE_STMT:
            break;
        case NODE_TYPE:
            break;
        default:
            break;
    }
}

string TreeNode::sType2String(StmtType type) {
    return "?";
}


string TreeNode::nodeType2String (NodeType type){
    return "<>";
}
