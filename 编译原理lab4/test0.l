%option noyywrap
%{
    #include <iostream>
    #include <iomanip>
    #include <errno.h>
    #include <cstdlib>
    #include <cstdio>
    #include <cstring>
    #include <map>
    std::map<std::string,int>addr_list;
    std::map<std::string,int>addr_List;
    std::map<std::string,int>::iterator iter;
    std::map<std::string,int>::iterator Iter;
    int line=1;
    int count;
    int br = 0;
    int level_v = 0;
    int type_v = 0;
    int level;
    int out(std::string s)
    {
    	iter = addr_list.find(s);
    	Iter = addr_List.find(s);
    	if((iter != addr_list.end())&&(Iter != addr_List.end()))
    	{
    		if (addr_list[s] > addr_List[s])
    		{
    			return addr_list[s];
    		}
    		else
    		{
    			return addr_List[s];
    		}
    	}else if(iter != addr_list.end())
    	{
    		return addr_list[s];
    	}else if(Iter != addr_List.end())
    	{
    		return addr_List[s];
    	}
    	return -1;
    }
    
%}
WORD [a-zA-Z]
ID ({WORD}|_)({WORD}|_|{DIGIT})*
OPT ("+"|"-"|"*"|"/"|"+="|"-="|"*="|"/="|">="|"<="|"=="|">"|"<"|"="|"++"|"--") 
BRACKET ("("|")"|"["|"]"|";"|","|"\'"|"\""|"#")
RBR "}"
LBR "{" 
KEYWORD_LEVEL for|while|if
DIGIT [0-9]
INTEGER [1-9]{DIGIT}*
OINTEGER ("+"|"-")?{INTEGER}
DECIMAL {OINTEGER}(.{INTEGER})
TYPE void|int|double|char
KEYWORD else|do|scanf|printf|sqrt|abs|return


%%

\n {++line;}
{RBR}   {if (level_v != 0){level_v--;addr_list.clear();}else {br--;};count--;if(count==0){addr_List.clear();};std::cout<<std::setw(15)<<line<<std::setw(15)<<"bracket"<<std::setw(15)<<yytext<<std::endl;}
{LBR}   {if (level_v == 0){br++;};count++;std::cout<<std::setw(15)<<line<<std::setw(15)<<"bracket"<<std::setw(15)<<yytext<<std::endl;}
{TYPE}  {if (level_v != 0){type_v = 1;};std::cout<<std::setw(15)<<line<<std::setw(15)<<"type"<<std::setw(15)<<yytext<<std::endl;}
{KEYWORD_LEVEL}   {level_v++;std::cout<<std::setw(15)<<line<<std::setw(15)<<"keyword"<<std::setw(15)<<yytext<<std::setw(15)<<std::endl;}
{KEYWORD}   {std::cout<<std::setw(15)<<line<<std::setw(15)<<"keyword"<<std::setw(15)<<yytext<<std::endl;}
{DIGIT} {std::cout<<std::setw(15)<<line<<std::setw(15)<<"integer"<<std::setw(15)<<yytext<<std::endl;} 
{INTEGER}   {std::cout<<std::setw(15)<<line<<std::setw(15)<<"integer"<<std::setw(15)<<yytext<<std::endl;}
{ID}    {if(count == 1){addr_List.insert(std::map<std::string,int>::value_type(yytext,count));};if (type_v != 0){addr_list.insert(std::map<std::string,int>::value_type(yytext,count));type_v = 0;};std::cout<<std::setw(15)<<line<<std::setw(15)<<"id"<<std::setw(15)<<yytext<<std::setw(15)<<out(yytext)<<std::endl;}
{BRACKET}   {std::cout<<std::setw(15)<<line<<std::setw(15)<<"bracket"<<std::setw(15)<<yytext<<std::endl;} 
{OPT}   {std::cout<<std::setw(15)<<line<<std::setw(15)<<"opt"<<std::setw(15)<<yytext<<std::endl;}
{OINTEGER}  {std::cout<<std::setw(15)<<line<<std::setw(15)<<"integer"<<std::setw(15)<<yytext<<std::endl;}
{DECIMAL}   {std::cout<<std::setw(15)<<line<<std::setw(15)<<"decimal"<<std::setw(15)<<yytext<<std::endl;}
. {}
[ \t]+ {}


%%
int main(){
    std::cout<<std::setw(15)<<"line"<<std::setw(15)<<"id_type"<<std::setw(15)<<"id_name"<<std::setw(15)<<"id_adder"<<std::endl; 
    yyFlexLexer lexer;
    lexer.yylex();
    return 0;
}



