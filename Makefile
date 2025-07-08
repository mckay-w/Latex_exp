TARGET = thesis
SRC = $(TARGET).tex
PDF = $(TARGET).pdf

.PHONY: all clean

all: $(PDF)

$(PDF): $(SRC)
	xelatex -interaction=nonstopmode $(SRC)
	xelatex -interaction=nonstopmode $(SRC)
	bibtex $(TARGET)
	xelatex -interaction=nonstopmode $(SRC)

init: renew clean

renew: 
	find figures/ -type f ! -name 'char.png' ! -name 'example.png' ! -name 'logo.png' -delete


clean:
	rm -f $(TARGET).aux $(TARGET).log $(TARGET).out $(TARGET).toc $(TARGET).synctex.gz $(TARGET).bbl $(TARGET).blg
	rm -f *.pdf
	
help:
	@echo "Makefile Help:"
	@echo "  all    - Build the PDF document using xelatex."
	@echo "  clean  - Remove auxiliary files generated during the build process."
	@echo "  help   - Display this help message."
