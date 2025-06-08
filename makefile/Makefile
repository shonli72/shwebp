# Makefile für shwebp
INSTALL_DIR = /usr/local/shwebp
BIN_DIR     = /usr/local/bin
MAN1_DIR    = /usr/local/share/man/man1
MAN1_DE_DIR = /usr/local/share/man/de/man1
SCRIPT_NAME = shwebp
SCRIPT_SRC  = shwebp_0.1.0.sh

.PHONY: install uninstall

install:
	@echo "🔧 Erstelle Installationsverzeichnis: $(INSTALL_DIR)"
	mkdir -p $(INSTALL_DIR)
	@echo "📄 Kopiere Skript nach $(INSTALL_DIR)/$(SCRIPT_NAME)"
	cp $(SCRIPT_SRC) $(INSTALL_DIR)/$(SCRIPT_NAME)
	chmod +x $(INSTALL_DIR)/$(SCRIPT_NAME)

	@echo "🔗 Erstelle symbolischen Link in $(BIN_DIR)"
	ln -sf $(INSTALL_DIR)/$(SCRIPT_NAME) $(BIN_DIR)/$(SCRIPT_NAME)

	@echo "📚 Installiere Manpages"
	mkdir -p $(MAN1_DIR)
	mkdir -p $(MAN1_DE_DIR)
	cp shwebp.1.gz $(MAN1_DIR)/
	cp shwebp.1.de.gz $(MAN1_DE_DIR)/

	@echo "🔄 Aktualisiere man-Datenbank"
	mandb

	@echo "✅ Installation abgeschlossen."

uninstall:
	@echo "🧹 Entferne Skriptverzeichnis: $(INSTALL_DIR)"
	rm -rf $(INSTALL_DIR)

	@echo "🧹 Entferne Symlink: $(BIN_DIR)/$(SCRIPT_NAME)"
	rm -f $(BIN_DIR)/$(SCRIPT_NAME)

	@echo "🧹 Entferne Manpages"
	rm -f $(MAN1_DIR)/shwebp.1.gz
	rm -f $(MAN1_DE_DIR)/shwebp.1.de.gz

	@echo "🔄 Aktualisiere man-Datenbank"
	mandb

	@echo "✅ Deinstallation abgeschlossen."
	