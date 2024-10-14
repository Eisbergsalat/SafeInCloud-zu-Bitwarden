# SafeInCloud-zu-Bitwarden


In Safe in Cloud werden die Apps standardmäßig mit einem Feld "Anwendung" gespeichert.
Beim Importieren der Datei in Bitwarden bzw. Vaultwarden wird aus diesen Feldern je ein "benutzerdefiniertes Feld" (Text) mit dem Namen "Anwendung".

Dadurch kann in diesen Apps nicht mehr automatisch asugefüllt werden.

Ich habe dann mit Microsoft Copilot das Skript hier entwickelt, um automatisch den Inhalt aller Felder mit dem Namen "Anwendung" in eine URL zu packen und gleichzeitig den Text "androidapp://" davor zu packen.
Ich denke es sollte in Ordnung sein, das hier zu teilen, falls irgendwann mal jmd auch so ein Skript braucht.
Wer auch immer hier landet, ihr könnt mit dem Code machen was ihr wollt. Evtl. kann eine KI beim Modifizieren helfen ;)


Möglichkeiten zur Erweiterung:
- Inhalt eines beliebigen Feldnamen in einen beliebeigen anderen Feldnamen (oder URL) zu packen
- beliebige Textveränderung
- Erkennen, wenn der Inhalt des Feldes leer ist und es einfach löschen (Aktuell kommt noch die Fehlermeldung: "jq: error (at <stdin>:0): Cannot iterate over null (null)")
- Keine Ahnung wie man evtl. Timeouts durch Bitwarden in den Griff bekommen könnte. Es ist durchaus möglich, dass bei größeren Datensätzen die BW_SESSION Key abläuft
  (>> Bei mir gab es keinen Timeout und ich habe 300 Einträge, bei denen es 83 App-Verweise gibt.)
- evtl. gibt es eine schnellere Methode alles zu speichern

Zum groben Abschätzen wie lange es dauert:
- Das Auslesen der Datenbank geht schnell. Meine 83 aus 300 Einträge konnten in wenigen Sekunden alle angezeigt werden.
- Das Speichern dauert etwas länger, da die Änderung an jedem Eintrag so ~2-5s dauert





## Voraussetzungen

Bevor du mit dem Skript beginnst, stelle sicher, dass du folgende Software installiert hast:
0. Unix-Umgebung mit bash erforderlich
    ```bash
    sudo apt-get install bash
    ```
1. **snap**: (https://snapcraft.io/docs/installing-snapd)
2. **Bitwarden CLI**:
    ```bash
    sudo snap install bw
    ```
    oder irgendwie halt Bitwarden CLI installieren: https://bitwarden.com/help/cli/
3. **curl**: Falls noch nicht installiert:
    ```bash
    sudo apt-get install curl
    ```
4. **jq**: Falls noch nicht installiert:
    ```bash
    sudo apt-get install jq
    ```

## Konfiguration

1. **Bitwarden Server-Adresse konfigurieren**:
    ```bash
    bw config server <Server-Adresse>
    ```
2. **Bei Bitwarden einloggen**:
    ```bash
    bw login
    ```

    Folge den Anweisungen zur Authentifizierung.

## Skript
1. update_bw.sh Skript herunterladen bzw. erstellen und von dem Skript dort rein kopieren
2. Ausführberechtigungen nicht vergessen
    ```bash
    chmod +x update_bw.sh
    ```
3. Ausführen
    ```bash
    ./update_bw.sh
    ```
    oder
    ```bash
    /bin/bash update_bw.sh
    ```
