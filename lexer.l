%{
#include <stdio.h>
#include <string.h>

typedef enum {
    T_IDENTIFIER,    // Identificadores (variáveis, funções)
    T_NUMBER,        // Números (inteiros, decimais)
    T_STRING,        // Strings (incluindo f-strings)
    T_KEYWORD,       // Palavras-chave (if, else, while, etc.)
    T_OPERATOR,      // Operadores (+, -, *, /, %) e comparações (==, <, >)
    T_DELIMITER,     // Delimitadores (parênteses, chaves, etc.)
    T_ASSIGNMENT,    // Operador de atribuição (=)
    T_WHITESPACE,    // Espaços em branco e nova linha
    T_ERROR          // Erro léxico
} TokenType;

int current_line = 1;
int last_printed_line = 0;

void print_token(TokenType type, char* text);
void update_line(char* text);
%}

%option noyywrap

DIGIT       [0-9]
NUMBER      {DIGIT}+(\.{DIGIT}+)?
LETTER      [a-zA-Z]
IDENTIFIER  [a-zA-Z_][a-zA-Z0-9_]*
WHITESPACE  [ \t\n\r]+

%%

"if"|"else"|"while"|"for"|"in"|"print"|"def"|"return"|"True"|"False"|"None" {
    print_token(T_KEYWORD, yytext);
}

"+"|"-"|"*"|"/"|"%"|"=="|"!="|"<"|">"|"<="|">=" {
    print_token(T_OPERATOR, yytext);
}

"=" {
    print_token(T_ASSIGNMENT, yytext);
}

"("|")"|"{"|"}"|"["|"]"|":"|"," {
    print_token(T_DELIMITER, yytext);
}

\"[^\"]*\"|'[^']*'|f\"[^\"]*\"|f'[^']*' {
    print_token(T_STRING, yytext);
}

{NUMBER} {
    print_token(T_NUMBER, yytext);
}

{IDENTIFIER} {
    print_token(T_IDENTIFIER, yytext);
}

{WHITESPACE} {
    update_line(yytext);
}

. {
    print_token(T_ERROR, yytext);
}

%%

void update_line(char* text) {
    for(int i = 0; i < strlen(text); i++) {
        if(text[i] == '\n') {
            current_line++;
        }
    }
}

void print_token(TokenType type, char* text) {
    if (type == T_WHITESPACE) {
        return;
    }
    
    if (current_line != last_printed_line) {
        if (last_printed_line > 0) {
            printf("\n");
        }
        printf("Linha %d:\n", current_line);
        last_printed_line = current_line;
    }
    
    char* token_name;
    switch(type) {
        case T_IDENTIFIER: token_name = "IDENTIFICADOR"; break;
        case T_NUMBER: token_name = "NÚMERO"; break;
        case T_STRING: token_name = "STRING"; break;
        case T_KEYWORD: token_name = "PALAVRA-CHAVE"; break;
        case T_OPERATOR: token_name = "OPERADOR"; break;
        case T_DELIMITER: token_name = "DELIMITADOR"; break;
        case T_ASSIGNMENT: token_name = "ATRIBUIÇÃO"; break;
        case T_WHITESPACE: token_name = "ESPAÇO"; break;
        case T_ERROR: token_name = "ERRO"; break;
        default: token_name = "DESCONHECIDO"; break;
    }
    printf("%-15s: %s\n", token_name, text);
    
    update_line(text);
}

int main(int argc, char* argv[]) {
    if (argc > 1) {
        FILE *file = fopen(argv[1], "r");
        if (!file) {
            fprintf(stderr, "Não foi possível abrir o arquivo %s\n", argv[1]);
            return 1;
        }
        yyin = file;
    }
    yylex();
    return 0;
}