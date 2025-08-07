/* A Bison parser, made by GNU Bison 3.8.2.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2021 Free Software Foundation,
   Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <https://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* DO NOT RELY ON FEATURES THAT ARE NOT DOCUMENTED in the manual,
   especially those whose name start with YY_ or yy_.  They are
   private implementation details that can be changed or removed.  */

#ifndef YY_YY_HOME_QIANFU_USTC_COMPILER_LAB1_BUILD_SYNTAX_ANALYZER_H_INCLUDED
# define YY_YY_HOME_QIANFU_USTC_COMPILER_LAB1_BUILD_SYNTAX_ANALYZER_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token kinds.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    YYEMPTY = -2,
    YYEOF = 0,                     /* "end of file"  */
    YYerror = 256,                 /* error  */
    YYUNDEF = 257,                 /* "invalid token"  */
    ERROR = 258,                   /* ERROR  */
    ADD = 259,                     /* ADD  */
    SUB = 260,                     /* SUB  */
    MUL = 261,                     /* MUL  */
    DIV = 262,                     /* DIV  */
    LT = 263,                      /* LT  */
    LE = 264,                      /* LE  */
    GT = 265,                      /* GT  */
    GE = 266,                      /* GE  */
    EQ = 267,                      /* EQ  */
    NE = 268,                      /* NE  */
    ASSIGN = 269,                  /* ASSIGN  */
    SEMICOLON = 270,               /* SEMICOLON  */
    COMMA = 271,                   /* COMMA  */
    LPAREN = 272,                  /* LPAREN  */
    RPAREN = 273,                  /* RPAREN  */
    LBRACKET = 274,                /* LBRACKET  */
    RBRACKET = 275,                /* RBRACKET  */
    LBRACE = 276,                  /* LBRACE  */
    RBRACE = 277,                  /* RBRACE  */
    ELSE = 278,                    /* ELSE  */
    IF = 279,                      /* IF  */
    INT = 280,                     /* INT  */
    RETURN = 281,                  /* RETURN  */
    VOID = 282,                    /* VOID  */
    WHILE = 283,                   /* WHILE  */
    FLOAT = 284,                   /* FLOAT  */
    ID = 285,                      /* ID  */
    INTEGER = 286,                 /* INTEGER  */
    FLOATNUM = 287                 /* FLOATNUM  */
  };
  typedef enum yytokentype yytoken_kind_t;
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 34 "syntax_analyzer.y"

    syntax_tree_node *node;  // For syntax tree nodes
    int integer;             // For integer tokens
    float floatnum;          // For float tokens
    

#line 103 "/home/qianfu/USTC-Compiler/lab1/build/syntax_analyzer.h"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;


int yyparse (void);


#endif /* !YY_YY_HOME_QIANFU_USTC_COMPILER_LAB1_BUILD_SYNTAX_ANALYZER_H_INCLUDED  */
