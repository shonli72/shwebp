# shwebp

**shwebp** ist ein leistungsstarkes und benutzerfreundliches Bash-Skript zur Konvertierung von Bildern in das moderne und effiziente WebP-Format. Es unterstützt mehrere Eingabeformate, erlaubt die rekursive Verzeichnisverarbeitung, Logging, eine Trockenlauf-Vorschau, anpassbare Ausgabequalität, Stiller Modus ohne Ausgabe im Terminal sowie flexible Angabe von Quell- und Zielverzeichnissen. Ideal für die Stapelverarbeitung großer Bildsammlungen auf Linux-Systemen.

---

## Funktionen

- Konvertiert PNG, JPG, JPEG, TIFF, HEIC und HEIF nach WebP
- Verarbeitet mehrere Quellverzeichnisse (kommagetrennte Liste)
- Unterstützt rekursive Verarbeitung (`-R`)
- Trockenlauf-Modus (`--dry-run`)
- Qualitätsangabe möglich (`-q [1-100]`)
- Silent-Modus (`-S`, `--silent`) unterdrückt Terminalausgabe und aktiviert automatisches Logging
- Benutzerdefinierte Quell- (`-s`) und Zielverzeichnisse (`-t`)
- Ausführliches Logging mit Zeitstempel (`-l`)
- Hilfe anzeigen (`-h`, `--help`) und Version ausgeben (`-v`, `--version`)
- Enthält englische und deutsche Manpages

---

## Voraussetzungen

- Bash (v4+ empfohlen)
- `cwebp` – WebP-Encoder aus dem Paket `webp`
- `heif-convert` – zur Konvertierung von HEIC/HEIF nach JPEG (aus `libheif-examples`)

---

## Installation

Die Installationspakete finden Sie im *install* Verzeichnis.

### Option 1: Mit dem .deb-Paket

```bash
sudo dpkg -i shwebp_0.1.0.deb
```

### Option 2: Mit Makefile aus dem .tar.gz-Archiv

```bash
tar -xzf shwebp_0.1.0.tar.gz
cd shwebp_0.1.0
sudo make install
```

### Option 3: Manuelle Installation

```bash
sudo mkdir -p /usr/local/shwebp
sudo cp shwebp_0.1.0.sh /usr/local/shwebp/shwebp
sudo chmod +x /usr/local/shwebp/shwebp
sudo ln -s /usr/local/shwebp/shwebp /usr/local/bin/shwebp
```

Sie können die Manpages in englischer und deutscher Sprache aus der .tar.gz Datei manuell installieren.
Wenn Sie das Script mit dem .deb Paket oder mit Makefile installieren, werden die Manpages (DE und EN) automatisch mit installiert.

---

## Verwendung

### Einfache Konvertierung

```bash
shwebp -s "~/Bilder" -t "~/Bilder/webp"
```

### Rekursive Konvertierung mit Qualitätsangabe

```bash
shwebp -s "~/Bilder,~/Downloads" -t "~/webp-output" -R -q 80
```

### Silent-Modus mit Logging

```bash
shwebp -s "~/Bilder" -t "~/webp-output" -S
```

### Trockenlauf (Dry-Run)

```bash
shwebp -s "~/Bilder" -t "~/webp-output" --dry-run
```

- `-s` erwartet eine kommagetrennte Liste in doppelten Anführungszeichen. Die Liste kann auch aus nur einem Element bestehen (Verzeichnis). Pfade sind erlaubt.
- `-t` erwartet nur ein Element (Verzeichnis), auch in doppelten Anführungszeichen. Pfade sind erlaubt. Wenn das Zielverzeichnis nicht existiert wird es erzeugt.

---

## Ausgabe

- Konvertierte Bilder werden im definierten Zielverzeichnis gespeichert.
- Log-Dateien (bei Logging oder Silent-Modus) werden unter `~/.shscripts/shwebp` mit Zeitstempel und weiteren Informationen abgelegt.

---

## Deinstallation

### Mit apt

```bash
sudo apt remove shwebp
-oder-
sudo apt purge shwebp
```

### Mit Makefile

```bash
sudo make uninstall
```

### Manuell

```bash
sudo rm /usr/local/bin/shwebp
sudo rm -rf /usr/local/shwebp
```

Wenn die Manpages auch installiert sind, vergessen Sie nicht diese auch zu entfernen.
Um die .log Dateien zu löschen, löschen Sie das Verzeichnis `~/.shscripts/shwebp` in Ihrem Home-Verzeichnis.

---

## Version anzeigen

```bash
shwebp -v
-oder-
shwebp --version
```

## Hilfe anzeigen

```bash
shwebp -h
-oder-
shwebp --help
-oder-
man shwebp
```

---

## Projekt Struktur

```bash
shwebp/
├── deb/
│   └── shwebp_0.1.0_deb/
│       ├── DEBIAN/
│       │   ├── control
│       │   ├── postinst
│       │   └── postrm
│       └── usr/
│           └── local/
│               ├── share/
│               │   ├── man/
│               │   │   └── man1/
│               │   │       └── shwebp.1.gz
│               │   └── de/
│               │       └── man/
│               │           └── man1/
│               │               └── shwebp.1.de.gz
│               └── shwebp/
│                   └── shwebp
├── dist/
│   ├── shwebp_0.1.0.deb
│   └── shwebp_0.1.0.tar.gz
├── doc/
│   └── man/
│       ├── shwebp.1
│       └── shwebp.1.de
├── makefile/
│   └── Makefile
├── shLogo/
│   └── sh-logo_2025-srgb.webp
├── src/
│   └── shwebp_0.1.0.sh
├── .gitignore
├── CHANGELOG.md
├── LICENSE
├── README.md
└── README_de.md
```

---

## Lizenz

Dieses Projekt steht unter der GNU General Public License v3.0. Details siehe in der beiliegenden LICENSE-Datei.

## Autor

(c) 2025 by **Heiko**  
<kontakt@schnitzler-heiko.de>  
https://www.schnitzler-heiko.de

## Changelog

Siehe [CHANGELOG.md](./CHANGELOG.md) für Versionshinweise und Änderungen.
