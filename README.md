# shwebp

**shwebp** is a powerful and easy-to-use Bash script that converts images to the modern and efficient WebP format. It supports multiple input formats, allows recursive directory traversal, logging, dry-run previews, adjustable output quality, silent mode, flexible source and target path definitions and exit codes. The script is ideal for batch-processing large image collections on Linux systems.

---

## Features

- Converts PNG, JPG, JPEG, TIFF, HEIC and HEIF to WebP
- Handles multiple source directories (comma-separated list)
- Supports recursive conversion (`-R`)
- Supports dry-run mode (`--dry-run`)
- Allows quality specification (`-q [1-100]`)
- Silent mode (`-S`, `--silent`) suppresses terminal output and enables automatic logging
- Custom source (`-s`) and target (`-t`) directories
- Generates detailed log files with timestamps (`-l`)
- Displays help (`-h`, `--help`) and version (`-v`, `--version`)
- Includes English and German manpages

---

## Requirements

- Bash (v4+ recommended)
- `cwebp` – WebP encoder from the `webp` package
- `heif-convert` – for converting HEIC/HEIF to JPEG (from `libheif-examples`)

---

## Installation

You can find the installation packages in the `dist` directory.

### Option 1: Using the .deb package

```bash
sudo dpkg -i shwebp_0.1.0.deb
```

### Option 2: Using the Makefile (.tar.gz archive)

```bash
tar -xzf shwebp_0.1.0.tar.gz
cd shwebp_0.1.0
sudo make install
```

### Option 3: Manual installation

```bash
sudo mkdir -p /usr/local/shwebp
sudo cp shwebp_0.1.0.sh /usr/local/shwebp/shwebp
sudo chmod +x /usr/local/shwebp/shwebp
sudo ln -s /usr/local/shwebp/shwebp /usr/local/bin/shwebp
```

You can also install the manpages in english and german language from the .tar.gz file (manual installation).
If you install the script with the .deb package or Makefile, both manpages will be installed  automatically (DE and EN).

---

## Usage

### Basic conversion

```bash
shwebp -s "~/Pictures" -t "~/Pictures/webp"
```

### Convert recursively with custom quality

```bash
shwebp -s "~/Pictures,~/Downloads" -t "~/webp-output" -R -q 80
```

### Silent mode with logging

```bash
shwebp -s "~/Pictures" -t "~/webp-output" -S
```

### Dry-run to preview actions

```bash
shwebp -s "~/Pictures" -t "~/webp-output" --dry-run
```

- `-s` expects a comma-separated list in double quotes, the list can also consist of only one element (directory), paths are allowed.
- `-t` expects only one element (directory), also in double quotes. paths are allowed too. If the directory doesn't exist, it will be ceated.

---

## Output

- Converted images are saved in the defined target directory
- Log files (when enabled or in silent mode) are stored in `~/.shscripts/shwebp` with timestamped filenames and other informations

---

## Uninstallation

### With apt

```bash
sudo apt remove shwebp
-or-
sudo apt purge shwebp
```

### Via Makefile

```bash
sudo make uninstall
```

### Manual

```bash
sudo rm /usr/local/bin/shwebp
sudo rm -rf /usr/local/shwebp
```

If the manpages also installed, don't forget to remove them too.
To remove the .log files, delete the `~/.shscripts/shwebp` directory in your Home-directory.

---

## Version

Run the following to check the installed version:

```bash
shwebp -v
-or-
shwebp --version
```

## Help

If you need help run this command the see the help page:

```bash
shwebp -h
-or-
shwebp --help
-or-
man shwebp
```

---

## Project structure

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

## License

This project is licensed under the GNU General Public License v3.0. See the LICENSE file for details.

## Author

(c) 2025 by **Heiko**  
<kontakt@schnitzler-heiko.de>  
https://www.schnitzler-heiko.de

## Changelog

See [CHANGELOG.md](./CHANGELOG.md) for version history and updates.
