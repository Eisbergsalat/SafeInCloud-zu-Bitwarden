# SafeInCloud-zu-Bitwarden


In Safe in Cloud werden die Apps standardmäßig mit einem Feld "Anwendung" gespeichert.
Beim Importieren der Datei in Bitwarden bzw. Vaultwarden wird aus diesen Feldern je ein "benutzerdefiniertes Feld" (Text) mit dem Namen "Anwendung".

Dadurch kann in diesen Apps nicht mehr automatisch asugefüllt werden.

Ich habe dann mit Copilot das Skript hier entwickelt, um automatisch den Inhalt aller Felder mit dem Namen "Anwendung" in eine URL zu packen und gleichzeitig den Text "androidapp://" davor zu packen.

Möglichkeiten zur Erweiterung:
- Inhalt eines beliebigen Feldnamen in einen beliebeigen anderen Feldnamen (oder URL) zu packen
- beliebige Textveränderung
- Erkennen, wenn der Inhalt des Feldes leer ist und es einfach löschen (Aktuell kommt noch die Fehlermeldung: "jq: error (at <stdin>:0): Cannot iterate over null (null)")
- Keine Ahnung wie man evtl. Timeouts durch Bitwarden in den Griff bekommen könnte. (>> Bei mir gab es keinen Timeout und ich habe 300 Einträge, bei denen es 83 App-Verweise gibt.)

Zum groben Abschätzen wie lange es dauert:
- Das Auslesen der Datenbank geht schnell. Meine 83 aus 300 Einträge konnten in wenigen Sekunden alle angezeigt werden.
- Das Speichern dauert etwas länger, da die Änderung an jedem Eintrag so ~2-5s dauert


Wer auch immer hier landet, ihr könnt mit dem Code machen was ihr wollt. Evtl. kann eine KI beim Modifizieren helfen ;)
