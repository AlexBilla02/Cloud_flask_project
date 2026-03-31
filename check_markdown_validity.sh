#!/bin/bash

# Cartella dei post
POSTS_DIR="posts/en"
EXIT_CODE=0

echo "🔍 Avvio controllo validità post Markdown..."

for file in "$POSTS_DIR"/*.md; do
    echo "--------------------------------------"
    echo "Controllo: $file"

    # Il template richiede: title, subtitle, author, author_image, date, image, permalink, tags, shortcontent
    for field in "title:" "subtitle:" "author:" "author_image:" "date:" "image:" "permalink:" "tags:" "shortcontent:"; do
        if ! grep -q "^$field" "$file"; then
            echo "❌ Errore: Campo mancante -> $field"
            EXIT_CODE=1
        fi
    done

    # Cerchiamo una riga che inizia con date: seguita da NomeMese Giorno, Anno
    DATE_VAL=$(grep "^date:" "$file" | cut -d':' -f2- | xargs)
    if [[ ! "$DATE_VAL" =~ ^(January|February|March|April|May|June|July|August|September|October|November|December)\ [0-9]{1,2},\ [0-9]{4}$ ]]; then
        echo "❌ Errore: Formato data errato -> '$DATE_VAL'. Deve essere 'Month Day, Year'."
        EXIT_CODE=1
    fi

    # 3. Verifica presenza separatore '---'
    if ! grep -q "^---" "$file"; then
        echo "❌ Errore: Separatore '---' mancante tra metadati e contenuto."
        EXIT_CODE=1
    fi
done

if [ $EXIT_CODE -eq 0 ]; then
    echo "Tutti i post sono validi!"
else
    echo "Alcuni post presentano errori. Correggili prima del commit."
fi

exit $EXIT_CODE
