## Analisador Léxico e Sintático
Este projeto consiste em um analisador léxico e sintático desenvolvido em C utilizando Flex e Bison. Ele é capaz de ler um código-fonte de entrada (por exemplo, um arquivo `.py`) e identificar seus tokens e sua estrutura gramatical.

## ⚙️ Requisitos

Para compilar e executar este projeto, você precisará das seguintes ferramentas instaladas no seu sistema:

- **Flex**: gerador de analisador léxico
- **Bison**: gerador de analisador sintático
- **GCC**: compilador C/C++

### Instalando no Ubuntu/Debian

```bash
sudo apt update
sudo apt install flex bison gcc build-essential graphviz
```

### Instalando no Windows
- Instale o GnuWin32 ou o MSYS2 para obter ferramentas como gcc, flex, bison.

- Instale o Graphviz para Windows: https://graphviz.org/download/

- Nota: Recomenda-se usar WSL para maior compatibilidade.

### Instalando no MacOS
Se você usa Homebrew, abra o terminal e execute:
```bash
brew update
brew install flex bison gcc graphviz
```
Dica: Pode ser necessário ajustar o PATH para priorizar as versões do Flex e Bison instaladas pelo Homebrew, pois o macOS vem com versões antigas por padrão.

## 🚀 Como executar

### Analisador Léxico
Gere o analisador léxico com flex:

```bash
flex lexer.l
```
Compile o código gerado:

``` bash
gcc -o lexer lex.yy.c -lfl
```

Execute o lexer com o arquivo de entrada:
```bash
./lexer < entrada.py
```

Obs.: Substitua entrada.py pelo nome do arquivo que deseja analisar.

### Analisador Sintático
Primeiramente, certifique-se de garantir a permissão de execução com esse comando :

```bash
chmod +x build.sh
```
Execute o script para compilar o analisador sintático:

```bash
./build.sh
```

Visualize a imagem gerada intitulada "arvore_sintatica.png"

## 📁 Estrutura do Projeto
- lexer.l – Definições do analisador léxico (tokens)

- lexer2.l - Definições do analisador léxico adaptado ao uso com o Bison

- parser.y – Definições do analisador sintático (gramática)

- build.sh – Script de compilação

- entrada.py – Exemplo de arquivo para teste

### Arquivos gerados pelo Analisador Léxico
- Analisador
- lex.yy.c

### Arquivos gerados pelo Analisador Sintático
- parser.tab.c
- parser.tab.h
- arvore_sintatica.dot
- arvore_sintatica.png

##  🎥 Videos
### Análise Léxica
https://www.youtube.com/watch?v=H8mXYfDN57o

### Análise Sintática
https://www.youtube.com/watch?v=qDKBI2abvHw
