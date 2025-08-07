#include <stdio.h>
#include <stdlib.h>

// 定义必要的类型
typedef struct syntax_tree_node
{
    char *name;
} syntax_tree_node;

typedef union {
    syntax_tree_node *node;
} YYSTYPE;

YYSTYPE yylval;

// 定义token值（简化版本）
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

// 声明外部变量和函数
extern int lines;
extern int pos_start;
extern int pos_end;
extern FILE *yyin;
extern char *yytext;
extern int yylex();

// 实现 new_syntax_tree_node 函数
syntax_tree_node *new_syntax_tree_node(char *text)
{
    syntax_tree_node *node = malloc(sizeof(syntax_tree_node));
    node->name = text;
    return node;
}

int main(int argc, const char **argv)
{
    if (argc != 2)
    {
        printf("usage: lexer_test input_file\n");
        return 0;
    }

    const char *input_file = argv[1];
    yyin = fopen(input_file, "r");
    if (!yyin)
    {
        fprintf(stderr, "cannot open file: %s\n", input_file);
        return 1;
    }

    int token;
    printf("%5s\t%10s\t%s\t%s\n", "Token", "Text", "Line", "Column (Start,End)");
    while ((token = yylex()))
    {
        printf("%-5d\t%10s\t%d\t(%d,%d)\n", token, yytext, lines, pos_start, pos_end);
    }
    return 0;
}
