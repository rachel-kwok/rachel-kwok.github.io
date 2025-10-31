# Makefile for LaTeX PDF Blog
# Usage: make all, make clean, make serve

# Compiler
LATEX = pdflatex

# Find all LaTeX files
TEX_FILES = $(shell find src -name "*.tex")
PDF_FILES = $(TEX_FILES:.tex=.pdf)

# Output directory
OUTPUT_DIR = output

# Default target
all: $(OUTPUT_DIR) compile copy

# Create output directory
$(OUTPUT_DIR):
	mkdir -p $(OUTPUT_DIR)

# Compile all LaTeX files to PDF
compile:
	@echo "Compiling LaTeX files to PDF..."
	@for tex_file in $(TEX_FILES); do \
		echo "Compiling $$tex_file..."; \
		(cd $$(dirname $$tex_file) && $(LATEX) -interaction=nonstopmode $$(basename $$tex_file)); \
	done

# Copy PDFs to output directory
copy: compile
	@echo "Copying PDFs to output directory..."
	@find src -name "*.pdf" -exec cp {} $(OUTPUT_DIR)/ \;

# Clean up auxiliary files
clean:
	@echo "Cleaning up auxiliary files..."
	@find src -name "*.aux" -delete
	@find src -name "*.log" -delete
	@find src -name "*.out" -delete
	@find src -name "*.toc" -delete
	@find src -name "*.bbl" -delete
	@find src -name "*.blg" -delete

# Clean up everything including PDFs
distclean: clean
	@echo "Removing all generated PDFs..."
	@rm -rf $(OUTPUT_DIR)/*.pdf
	@find src -name "*.pdf" -delete

# Serve PDFs locally
serve:
	@echo "Starting local server for PDF viewing..."
	@echo "Visit http://localhost:8000 to view your LaTeX PDFs"
	@python3 -m http.server 8000

# Help target
help:
	@echo "Available targets:"
	@echo "  all      - Compile all LaTeX files and copy PDFs to output"
	@echo "  compile  - Compile all LaTeX files to PDF"
	@echo "  copy     - Copy PDFs to output directory"
	@echo "  clean    - Remove auxiliary files"
	@echo "  distclean- Remove all generated files"
	@echo "  serve    - Start local web server to view PDFs"
	@echo "  help     - Show this help message"

.PHONY: all compile copy clean distclean serve help