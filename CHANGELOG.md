# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [0.1.0] - 2025-06-08

### Added

- Initial public release of `shwebp`
- Supports image conversion from JPG, PNG, TIFF, HEIF/HEIC to WebP
- Recursive directory processing with `-R` option
- Logging feature with `-l` option (saved in `~/.shscripts/shwebp`)
- Dry-run support with `--dry-run`
- WebP quality control with `-q <1–100>`
- Silent mode with `-s`, target output directory with `-o`
- Version output with `-v` or `--version`
- Help page shown with `-h` or `--help`
- Manual pages: `shwebp.1` and `shwebp.1.de`
- Debian package with `postinst` and `postrm` scripts
- Makefile for install/uninstall
- `.tar.gz` source archive with complete file structure

---

## [Planned for 0.2.0]

### Possible Additions

- Extended file format support (e.g., AVIF, JPEG XL, RAW)
- Unit tests for image detection and argument parsing
