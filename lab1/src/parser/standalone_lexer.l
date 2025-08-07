%option noyywrap
%{
/*****************声明和选项设置  begin*****************/
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

// 定义必要的类型
typedef struct syntax_tree_node {
    char* name;
} syntax_tree_node;

typedef union {
    syntax_tree_node* node;
} YYSTYPE;

YYSTYPE yylval;

// 定义token值
#define ADD 1
#define SUB 2
#define MUL 3
#define DIV 4
#define LT 5
#define LE 6
#define GT 7
#define GE 8
#define EQ 9
#define NE 10
#define ASSIGN 11
#define SEMICOLON 12
#define COMMA 13
#define LPAREN 14
#define RPAREN 15
#define LBRACKET 16
#define RBRACKET 17
#define LBRACE 18
#define RBRACE 19
#define ELSE 20
#define IF 21
#define INT 22
#define RETURN 23
#define VOID 24
#define WHILE 25
#define FLOAT 26
#define ID 27
#define INTEGER 28
#define FLOATNUM 29
#define ERROR 30

int lines = 1;
int pos_start = 1;
int pos_end = 1;

/* 声明 fileno 函数 */
extern int fileno(FILE *stream);

// 实现 new_syntax_tree_node 函数
syntax_tree_node* new_syntax_tree_node(char* text) {
    syntax_tree_node* node = malloc(sizeof(syntax_tree_node));
    node->name = text;
    return node;
}

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

int main(int argc, const char **argv) {
    if (argc != 2) {
        printf("usage: lexer_test input_file\n");
        return 0;
    }

    const char *input_file = argv[1];
    yyin = fopen(input_file, "r");
    if (!yyin) {
        fprintf(stderr, "cannot open file: %s\n", input_file);
        return 1;
    }

    int token;
    printf("%5s\t%10s\t%s\t%s\n", "Token", "Text", "Line", "Column (Start,End)");
    while ((token = yylex())) {
        printf("%-5d\t%10s\t%d\t(%d,%d)\n",
               token, yytext, lines, pos_start, pos_end);
    }
    fclose(yyin);
    return 0;
}
