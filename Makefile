# Makefile for Topological Field-Theoretic Semantics Whitepaper
# Compiles LaTeX document with bibliography support

# Main document name (without .tex extension)
MAIN = main
TEX = $(MAIN).tex
PDF = $(MAIN).pdf

# LaTeX compiler
LATEX = pdflatex
BIBTEX = biber

# Compilation flags
LATEX_FLAGS = -interaction=nonstopmode -file-line-error -synctex=1

# Directories
SECTIONS_DIR = sections
FIGURES_DIR = figures
ALGORITHMS_DIR = algorithms

# Source files
TEX_SOURCES = $(TEX) $(wildcard $(SECTIONS_DIR)/*.tex)
BIB_SOURCE = references.bib

# Output files
AUX_FILES = $(MAIN).aux $(MAIN).bbl $(MAIN).bcf $(MAIN).blg $(MAIN).log \
            $(MAIN).out $(MAIN).run.xml $(MAIN).synctex.gz $(MAIN).toc

.PHONY: all clean pdf view help

# Default target
all: pdf

# Compile PDF
pdf: $(PDF)

$(PDF): $(TEX_SOURCES) $(BIB_SOURCE)
	@echo "=== First LaTeX pass ==="
	$(LATEX) $(LATEX_FLAGS) $(TEX)
	@echo "=== Biber pass ==="
	$(BIBTEX) $(MAIN)
	@echo "=== Second LaTeX pass ==="
	$(LATEX) $(LATEX_FLAGS) $(TEX)
	@echo "=== Third LaTeX pass (for cross-references) ==="
	$(LATEX) $(LATEX_FLAGS) $(TEX)
	@echo "=== Compilation complete ==="

# Quick compile (no bibliography)
quick: $(TEX_SOURCES)
	$(LATEX) $(LATEX_FLAGS) $(TEX)

# Clean auxiliary files
clean:
	@echo "Cleaning auxiliary files..."
	rm -f $(AUX_FILES)
	@echo "Done."

# Deep clean (including PDF)
distclean: clean
	@echo "Removing PDF..."
	rm -f $(PDF)
	@echo "Done."

# View PDF (requires evince or system default PDF viewer)
view: pdf
	@if command -v evince > /dev/null; then \
		evince $(PDF) & \
	elif command -v xdg-open > /dev/null; then \
		xdg-open $(PDF) & \
	else \
		echo "Please open $(PDF) manually"; \
	fi

# Help message
help:
	@echo "Topological Field-Theoretic Semantics Whitepaper Makefile"
	@echo ""
	@echo "Targets:"
	@echo "  all       - Compile PDF with bibliography (default)"
	@echo "  pdf       - Compile PDF with bibliography"
	@echo "  quick     - Quick compile without bibliography"
	@echo "  clean     - Remove auxiliary files"
	@echo "  distclean - Remove auxiliary files and PDF"
	@echo "  view      - Compile and open PDF"
	@echo "  help      - Show this help message"
	@echo ""
	@echo "Usage:"
	@echo "  make        - Compile the document"
	@echo "  make clean  - Clean up auxiliary files"
	@echo "  make view   - Compile and view the document"

