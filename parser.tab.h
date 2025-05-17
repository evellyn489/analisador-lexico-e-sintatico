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

#ifndef YY_YY_PARSER_TAB_H_INCLUDED
# define YY_YY_PARSER_TAB_H_INCLUDED
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
    NUMERO = 258,                  /* NUMERO  */
    IDENTIFICADOR = 259,           /* IDENTIFICADOR  */
    STRING_FORMATADA = 260,        /* STRING_FORMATADA  */
    PALAVRA_CHAVE_WHILE = 261,     /* PALAVRA_CHAVE_WHILE  */
    PALAVRA_CHAVE_IF = 262,        /* PALAVRA_CHAVE_IF  */
    PALAVRA_CHAVE_ELSE = 263,      /* PALAVRA_CHAVE_ELSE  */
    PALAVRA_CHAVE_PRINT = 264,     /* PALAVRA_CHAVE_PRINT  */
    OP_ATRIB = 265,                /* OP_ATRIB  */
    OP_IGUAL = 266,                /* OP_IGUAL  */
    OP_MOD = 267,                  /* OP_MOD  */
    OP_ADICAO = 268,               /* OP_ADICAO  */
    OP_SUBTRACAO = 269,            /* OP_SUBTRACAO  */
    OP_MENOR = 270,                /* OP_MENOR  */
    DELIM_ABRE_PARENT = 271,       /* DELIM_ABRE_PARENT  */
    DELIM_FECHA_PARENT = 272,      /* DELIM_FECHA_PARENT  */
    DELIM_DOIS_PONTOS = 273,       /* DELIM_DOIS_PONTOS  */
    MENOR_QUE_ELSE = 274           /* MENOR_QUE_ELSE  */
  };
  typedef enum yytokentype yytoken_kind_t;
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 26 "parser.y"

    int num;
    char* id;
    char* str;
    struct no* node;

#line 90 "parser.tab.h"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;


int yyparse (void);


#endif /* !YY_YY_PARSER_TAB_H_INCLUDED  */
