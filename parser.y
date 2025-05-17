%{
#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <string.h>

typedef struct no {
    char *nome;
    int nfilhos;
    struct no **filhos;
} no;

no* novo_no(char* nome, int nfilhos, ...);
void gerar_dot(no* raiz);
void gerar_dot_recursivo(FILE* fp, no* node, int* contador);
void liberar_no(no* node);

extern int linha;
int yylex();
void yyerror(const char* s);
extern FILE* yyin;

no* raiz_ast = NULL;
%}

%union {
    int num;
    char* id;
    char* str;
    struct no* node;
}

%token <num> NUMERO
%token <id> IDENTIFICADOR
%token <str> STRING_FORMATADA

%token PALAVRA_CHAVE_WHILE PALAVRA_CHAVE_IF PALAVRA_CHAVE_ELSE PALAVRA_CHAVE_PRINT
%token OP_ATRIB OP_IGUAL OP_MOD OP_ADICAO OP_SUBTRACAO OP_MENOR
%token DELIM_ABRE_PARENT DELIM_FECHA_PARENT DELIM_DOIS_PONTOS

%type <node> programa comando expressao expressao_or expressao_and expressao_comp expressao_aditiva expressao_mult expressao_unaria expressao_primaria

%nonassoc MENOR_QUE_ELSE
%nonassoc PALAVRA_CHAVE_ELSE

%right OP_ATRIB
%left OP_IGUAL OP_MENOR
%left OP_ADICAO OP_SUBTRACAO
%left OP_MOD

%start programa

%%

programa
    : /* vazio */
        { $$ = novo_no("Programa", 0); raiz_ast = $$; }
    | programa comando
        { $$ = novo_no("Programa", 2, $1, $2); raiz_ast = $$; }
    ;

comando
    : expressao
        { $$ = $1; }
    | PALAVRA_CHAVE_IF expressao DELIM_DOIS_PONTOS comando %prec MENOR_QUE_ELSE
        { $$ = novo_no("If", 2, $2, $4); }
    | PALAVRA_CHAVE_IF expressao DELIM_DOIS_PONTOS comando PALAVRA_CHAVE_ELSE DELIM_DOIS_PONTOS comando
        { $$ = novo_no("IfElse", 3, $2, $4, $7); }
    | PALAVRA_CHAVE_WHILE expressao DELIM_DOIS_PONTOS comando
        { $$ = novo_no("While", 2, $2, $4); }
    | PALAVRA_CHAVE_PRINT DELIM_ABRE_PARENT expressao DELIM_FECHA_PARENT
        { $$ = novo_no("Print", 1, $3); }
    ;

expressao
    : IDENTIFICADOR OP_ATRIB expressao
        { $$ = novo_no("Atrib", 2, novo_no($1, 0), $3); }
    | expressao_or
        { $$ = $1; }
    ;

expressao_or
    : expressao_and
        { $$ = $1; }
    ;

expressao_and
    : expressao_comp
        { $$ = $1; }
    ;

expressao_comp
    : expressao_aditiva
        { $$ = $1; }
    | expressao_comp OP_IGUAL expressao_aditiva
        { $$ = novo_no("Igual", 2, $1, $3); }
    | expressao_comp OP_MENOR expressao_aditiva
        { $$ = novo_no("Menor", 2, $1, $3); }
    ;

expressao_aditiva
    : expressao_mult
        { $$ = $1; }
    | expressao_aditiva OP_ADICAO expressao_mult
        { $$ = novo_no("Soma", 2, $1, $3); }
    | expressao_aditiva OP_SUBTRACAO expressao_mult
        { $$ = novo_no("Sub", 2, $1, $3); }
    ;

expressao_mult
    : expressao_unaria
        { $$ = $1; }
    | expressao_mult OP_MOD expressao_unaria
        { $$ = novo_no("Mod", 2, $1, $3); }
    ;

expressao_unaria
    : expressao_primaria
        { $$ = $1; }
    ;

expressao_primaria
    : IDENTIFICADOR
        { $$ = novo_no($1, 0); }
    | NUMERO
        {
            char buf[32];
            snprintf(buf, sizeof(buf), "%d", $1);
            $$ = novo_no(strdup(buf), 0);
        }
    | STRING_FORMATADA
        { $$ = novo_no($1, 0); }
    | DELIM_ABRE_PARENT expressao DELIM_FECHA_PARENT
        { $$ = $2; }
    ;

%%

#include <stdarg.h>

no* novo_no(char* nome, int nfilhos, ...) {
    va_list ap;
    no* resultado = malloc(sizeof(no));
    resultado->nome = strdup(nome);
    resultado->nfilhos = nfilhos;
    if (nfilhos > 0)
        resultado->filhos = malloc(nfilhos * sizeof(no*));
    else
        resultado->filhos = NULL;

    va_start(ap, nfilhos);
    for (int i = 0; i < nfilhos; i++) {
        resultado->filhos[i] = va_arg(ap, no*);
    }
    va_end(ap);
    return resultado;
}

void yyerror(const char* s) {
    fprintf(stderr, "Erro na linha %d: %s\n", linha, s);
}

void gerar_dot(no* raiz) {
    FILE* fp = fopen("arvore_sintatica.dot", "w");
    if (fp == NULL) {
        fprintf(stderr, "Erro ao criar arquivo Graphviz\n");
        return;
    }
    
    fprintf(fp, "digraph AST {\n");
    fprintf(fp, "  node [shape=box];\n");
    
    int contador = 0;
    gerar_dot_recursivo(fp, raiz, &contador);
    
    fprintf(fp, "}\n");
    fclose(fp);
    
    printf("Arquivo 'arvore_sintatica.dot' gerado com sucesso.\n");
}

void gerar_dot_recursivo(FILE* fp, no* node, int* contador) {
    if (node == NULL) return;
    
    int node_id = (*contador)++;
    
    char nome_escapado[1024];
    char *s = node->nome;
    char *d = nome_escapado;
    
    while (*s) {
        if (*s == '"' || *s == '\\') {
            *d++ = '\\';
        }
        *d++ = *s++;
    }
    *d = '\0';
    
    fprintf(fp, "  node%d [label=\"%s\"];\n", node_id, nome_escapado);
    
    for (int i = 0; i < node->nfilhos; i++) {
        int filho_id = *contador;
        gerar_dot_recursivo(fp, node->filhos[i], contador);
        fprintf(fp, "  node%d -> node%d;\n", node_id, filho_id);
    }
}

void liberar_no(no* node) {
    if (node == NULL) return;
    
    for (int i = 0; i < node->nfilhos; i++) {
        liberar_no(node->filhos[i]);
    }
    
    free(node->nome);
    if (node->filhos != NULL) {
        free(node->filhos);
    }
    free(node);
}

int main(int argc, char **argv) {
    if (argc > 1) {
        yyin = fopen(argv[1], "r");
        if (yyin == NULL) {
            fprintf(stderr, "Não foi possível abrir o arquivo %s\n", argv[1]);
            return 1;
        }
    } else {
        yyin = stdin;
    }
    
    if (yyparse() == 0) {
        printf("Análise sintática concluída com sucesso!\n");
        
        if (raiz_ast != NULL) {
            gerar_dot(raiz_ast);
            liberar_no(raiz_ast);
        } else {
            printf("Aviso: Árvore sintática vazia!\n");
        }
    } else {
        printf("Erro na análise sintática.\n");
    }
    
    if (yyin != stdin) {
        fclose(yyin);
    }
    
    return 0;
}
