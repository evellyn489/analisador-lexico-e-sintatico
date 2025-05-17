echo "Compilando o analisador sintático..."

rm -f parser.tab.c parser.tab.h lex.yy.c analisador arvore_sintatica.dot arvore_sintatica.png

bison -d parser.y
if [ $? -ne 0 ]; then
    echo "Erro ao compilar o parser com bison."
    exit 1
fi

flex lexer2.l
if [ $? -ne 0 ]; then
    echo "Erro ao compilar o lexer com flex."
    exit 1
fi

gcc -g parser.tab.c lex.yy.c -o analisador -lfl
if [ $? -ne 0 ]; then
    echo "Erro ao compilar o analisador com gcc."
    exit 1
fi

echo "Compilação bem-sucedida!"

if [ "$1" != "" ]; then
    echo "Analisando o arquivo $1..."
    ./analisador "$1"
else
    echo "Analisando entrada padrão..."
    ./analisador < entrada.py
fi

if [ -f "arvore_sintatica.dot" ]; then
    echo "Gerando imagem da árvore sintática..."
    dot -Tpng arvore_sintatica.dot -o arvore_sintatica.png
    
    if [ $? -eq 0 ]; then
        echo "Imagem PNG gerada com sucesso: arvore_sintatica.png"
        
        if grep -qi microsoft /proc/version; then
            explorer.exe "$(wslpath -w "$(pwd)/arvore_sintatica.png")"
        else
            if command -v display &> /dev/null; then
                display arvore_sintatica.png
            elif command -v eog &> /dev/null; then
                eog arvore_sintatica.png
            elif command -v open &> /dev/null; then
                open arvore_sintatica.png
            elif command -v xdg-open &> /dev/null; then
                xdg-open arvore_sintatica.png
            else
                echo "Visualizador de imagem não encontrado. Por favor, abra arvore_sintatica.png manualmente."
            fi
        fi

    else
        echo "Erro ao gerar a imagem PNG."
    fi
else
    echo "O arquivo DOT não foi gerado. Verifique se houve erros na análise."
fi
