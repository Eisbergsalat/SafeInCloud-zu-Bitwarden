#!/bin/bash

# Synchronisiere den Tresor
bw sync

# Setze deinen BW_SESSION Key
BW_SESSION=$(bw unlock --raw)

# Überprüfe, ob der BW_SESSION erfolgreich extrahiert wurde
if [ -z "$BW_SESSION" ]; then
    echo "Kein Session-Token erhalten."
    exit 1
fi

# Melde dich bei Bitwarden an
export BW_SESSION

# Hole alle Einträge
entries=$(bw list items --raw --session $BW_SESSION)

if [ -z "$entries" ]; then
    echo "Keine Einträge gefunden."
    exit 1
fi

# Temporäre Datei erstellen
temp_file=$(mktemp)

# Ausgabe des temporären Dateipfads
echo "Temporäre Datei: $temp_file"

# Iteriere über die ersten 25 Einträge
counter=0
for entry in $(echo "${entries}" | jq -r '.[] | @base64'); do
#	Debugging-Limiter:
#    if [ "$counter" -ge 25 ]; then
#        break
#    fi

    _jq() {
        echo ${entry} | base64 --decode | jq -r ${1}
    }

    id=$(_jq '.id')
    name=$(_jq '.name')
    applications=$(echo ${entry} | base64 --decode | jq -r '.fields[] | select(.name == "Anwendung") | .value' 2> /dev/null)

    if [ ! -z "$applications" ]; then
        for application in $applications; do
            new_url="androidapp://$application"
            echo -e "$id\t$name\t$application\t$new_url" >> $temp_file
        done
    fi

    counter=$((counter + 1))
done

echo "Alle Änderungen gesammelt. Hier sind sie:"
while IFS=$'\t' read -r id name old_app new_url; do
    if [ -n "$name" ] && [ -n "$old_app" ] && [ -n "$new_url" ]; then
        echo "Eintrag: $name"
        echo "Altes Anwendungsfeld: $old_app"
        echo "Neues URL-Feld: $new_url"
        echo ""
    fi
done < $temp_file

read -p "Möchtest du alle Änderungen übernehmen? (J/n): " confirm

if [[ $confirm == "J" || $confirm == "j" || -z $confirm ]]; then
    while IFS=$'\t' read -r id name old_app new_url; do
        if [ -n "$id" ] && [ -n "$new_url" ]; then
            # Füge die neue URL hinzu
            updated_entry=$(bw get item $id --session $BW_SESSION | jq --arg url "$new_url" '.login.uris += [{"uri":$url}]' | bw encode)
            echo "$updated_entry" | bw edit item $id --session $BW_SESSION > /dev/null 2>&1

            # Lösche das alte Anwendungsfeld
            cleaned_entry=$(bw get item $id --session $BW_SESSION | jq 'del(.fields[] | select(.name == "Anwendung"))' | bw encode)
            echo "$cleaned_entry" | bw edit item $id --session $BW_SESSION > /dev/null 2>&1

            echo "Änderungen übernommen für Eintrag: $name"
        fi
    done < $temp_file
else
    echo "Änderungen wurden nicht übernommen."
fi

# Temporäre Datei löschen
rm -f $temp_file

echo "Fertig!"
