
%{
#include "parser.tab.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int linha = 1;

void debug_token(const char* token_type, const char* text) {
    printf("Linha %d: %-15s: %s\n", linha, token_type, text);
}

/* #define DEBUG_LEXER */
%}

%option noyywrap

DIGIT       [0-9]
NUMBER      {DIGIT}+
LETTER      [a-zA-Z]
IDENTIFIER  [a-zA-Z_][a-zA-Z0-9_]*
WHITESPACE  [ \t\r]+

%%

"while" {
    #ifdef DEBUG_LEXER
    debug_token("PALAVRA_CHAVE", yytext);
    #endif
    return PALAVRA_CHAVE_WHILE;
}

"if" {
    #ifdef DEBUG_LEXER
    debug_token("PALAVRA_CHAVE", yytext);
    #endif
    return PALAVRA_CHAVE_IF;
}

"else" {
    #ifdef DEBUG_LEXER
    debug_token("PALAVRA_CHAVE", yytext);
    #endif
    return PALAVRA_CHAVE_ELSE;
}

"print" {
    #ifdef DEBUG_LEXER
    debug_token("PALAVRA_CHAVE", yytext);
    #endif
    return PALAVRA_CHAVE_PRINT;
}

"=" {
    #ifdef DEBUG_LEXER
    debug_token("OP_ATRIB", yytext);
    #endif
    return OP_ATRIB;
}

"==" {
    #ifdef DEBUG_LEXER
    debug_token("OP_IGUAL", yytext);
    #endif
    return OP_IGUAL;
}

"%" {
    #ifdef DEBUG_LEXER
    debug_token("OP_MOD", yytext);
    #endif
    return OP_MOD;
}

"+" {
    #ifdef DEBUG_LEXER
    debug_token("OP_ADICAO", yytext);
    #endif
    return OP_ADICAO;
}

"-" {
    #ifdef DEBUG_LEXER
    debug_token("OP_SUBTRACAO", yytext);
    #endif
    return OP_SUBTRACAO;
}

"<" {
    #ifdef DEBUG_LEXER
    debug_token("OP_MENOR", yytext);
    #endif
    return OP_MENOR;
}

"(" {
    #ifdef DEBUG_LEXER
    debug_token("DELIM_ABRE_PARENT", yytext);
    #endif
    return DELIM_ABRE_PARENT;
}

")" {
    #ifdef DEBUG_LEXER
    debug_token("DELIM_FECHA_PARENT", yytext);
    #endif
    return DELIM_FECHA_PARENT;
}

":" {
    #ifdef DEBUG_LEXER
    debug_token("DELIM_DOIS_PONTOS", yytext);
    #endif
    return DELIM_DOIS_PONTOS;
}

{NUMBER} {
    #ifdef DEBUG_LEXER
    debug_token("NUMERO", yytext);
    #endif
    yylval.num = atoi(yytext);
    return NUMERO;
}

{IDENTIFIER} {
    #ifdef DEBUG_LEXER
    debug_token("IDENTIFICADOR", yytext);
    #endif
    yylval.id = strdup(yytext);
    return IDENTIFICADOR;
}

f?\"[^\"]*\" {
    #ifdef DEBUG_LEXER
    debug_token("STRING_FORMATADA", yytext);
    #endif
    yylval.str = strdup(yytext);
    return STRING_FORMATADA;
}

f?\'[^\']*\' {
    #ifdef DEBUG_LEXER
    debug_token("STRING_FORMATADA", yytext);
    #endif
    yylval.str = strdup(yytext);
    return STRING_FORMATADA;
}

\n {
    linha++;
}

{WHITESPACE} {
    /* Ignora espaços em branco */
}

. {
    fprintf(stderr, "Erro léxico na linha %d: caractere inválido '%s'\n", linha, yytext);
}

%%
