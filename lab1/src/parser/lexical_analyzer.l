%option noyywrap
%{
/*****************声明和选项设置  begin*****************/
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#include "syntax_tree.h"
#include "syntax_analyzer.h"

/* 声明 fileno 函数 */
extern int fileno(FILE *stream);

int lines = 1;
int pos_start = 1;
int pos_end = 1;

void pass_node(char *text){
     yylval.node = new_syntax_tree_node(text);
}

/*****************声明和选项设置  end*****************/

%}

delim [ \t\n]
ws {delim}+
letter [a-zA-Z]
digit [0-9]
id {letter}({letter}|{digit})*
integer {digit}+
float {digit}+\.{digit}*([eE][+-]?{digit}+)?

%%

"+"         {pos_start = pos_end; pos_end += 1; pass_node(yytext); return ADD;}
"-"         {pos_start = pos_end; pos_end += 1; pass_node(yytext); return SUB;}
"*"         {pos_start = pos_end; pos_end += 1; pass_node(yytext); return MUL;}
"/"         {pos_start = pos_end; pos_end += 1; pass_node(yytext); return DIV;}

"<="        {pos_start = pos_end; pos_end += 2; pass_node(yytext); return LE;}
">="        {pos_start = pos_end; pos_end += 2; pass_node(yytext); return GE;}
"=="        {pos_start = pos_end; pos_end += 2; pass_node(yytext); return EQ;}
"!="        {pos_start = pos_end; pos_end += 2; pass_node(yytext); return NE;}
"<"         {pos_start = pos_end; pos_end += 1; pass_node(yytext); return LT;}
">"         {pos_start = pos_end; pos_end += 1; pass_node(yytext); return GT;}

"="         {pos_start = pos_end; pos_end += 1; pass_node(yytext); return ASSIGN;}

";"         {pos_start = pos_end; pos_end += 1; pass_node(yytext); return SEMICOLON;}
","         {pos_start = pos_end; pos_end += 1; pass_node(yytext); return COMMA;}
"("         {pos_start = pos_end; pos_end += 1; pass_node(yytext); return LPAREN;}
")"         {pos_start = pos_end; pos_end += 1; pass_node(yytext); return RPAREN;}
"["         {pos_start = pos_end; pos_end += 1; pass_node(yytext); return LBRACKET;}
"]"         {pos_start = pos_end; pos_end += 1; pass_node(yytext); return RBRACKET;}
"{"         {pos_start = pos_end; pos_end += 1; pass_node(yytext); return LBRACE;}
"}"         {pos_start = pos_end; pos_end += 1; pass_node(yytext); return RBRACE;}

"else"      {pos_start = pos_end; pos_end += 4; pass_node(yytext); return ELSE;}
"if"        {pos_start = pos_end; pos_end += 2; pass_node(yytext); return IF;}
"int"       {pos_start = pos_end; pos_end += 3; pass_node(yytext); return INT;}
"return"    {pos_start = pos_end; pos_end += 6; pass_node(yytext); return RETURN;}
"void"      {pos_start = pos_end; pos_end += 4; pass_node(yytext); return VOID;}
"while"     {pos_start = pos_end; pos_end += 5; pass_node(yytext); return WHILE;}
"float"     {pos_start = pos_end; pos_end += 5; pass_node(yytext); return FLOAT;}

{id}        {pos_start = pos_end; pos_end += yyleng; pass_node(yytext); return ID;}
{integer}   {pos_start = pos_end; pos_end += yyleng; pass_node(yytext); return INTEGER;}
{float}     {pos_start = pos_end; pos_end += yyleng; pass_node(yytext); return FLOATNUM;}

"/*"([^*]|\*+[^*/])*\*+"/"  {
    pos_start = pos_end;
    for(int i = 0; i < yyleng; i++) {
        if(yytext[i] == '\n') {
            lines++;
            pos_end = 1;
        } else {
            pos_end++;
        }
    }
}

{ws}        {
    pos_start = pos_end;
    for(int i = 0; i < yyleng; i++) {
        if(yytext[i] == '\n') {
            lines++;
            pos_end = 1;
        } else {
            pos_end++;
        }
    }
}

.           {pos_start = pos_end; pos_end++; pass_node(yytext); return ERROR;}

%%
