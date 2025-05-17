## Como executar

### Analisador Léxico

```bash
flex lexer.l
gcc lex.yy.c -o analisador -lfl
./analisador < entrada.py
```
### Analisador Sintático
Certifique-se de garantir a permissão de execução com esse comando 

```bash
chmod +x build.sh
```
```bash
./build.sh
```