TARGET = thesis
SRC = $(TARGET).tex
PDF = $(TARGET).pdf
STY = $(TARGET).sty

# 定义章节和图片目录
CHAPTERS_DIR = chapters
CHAPTERS = $(wildcard $(CHAPTERS_DIR)/*/main.tex)
FIGURES_DIRS = $(wildcard $(CHAPTERS_DIR)/*/figures)

.PHONY: all clean init renew help $(CHAPTERS_TARGETS) remove%

all: $(PDF)

$(PDF): $(SRC) $(CHAPTERS) $(STY)
	TEXINPUTS=.:$(CHAPTERS_DIR): xelatex -interaction=nonstopmode $(SRC)
	TEXINPUTS=.:$(CHAPTERS_DIR): xelatex -interaction=nonstopmode $(SRC)
	bibtex $(TARGET)
	TEXINPUTS=.:$(CHAPTERS_DIR): xelatex -interaction=nonstopmode $(SRC)

# 删除指定章节
remove%:
	@if [ -d "$(CHAPTERS_DIR)/chapter$*" ]; then \
		echo "Removing chapter $*..."; \
		rm -rf $(CHAPTERS_DIR)/chapter$*; \
		echo "Chapter $* has been removed."; \
		echo "Don't forget to remove \\subfile{chapters/chapter$*/main.tex} from $(SRC)"; \
	else \
		echo "Chapter $* not found"; \
	fi

# 编译单个章节的简化命令
chap%:
	@if [ -f "$(CHAPTERS_DIR)/chapter$*/main.tex" ]; then \
		echo "Compiling chapter $*..."; \
		TEXINPUTS=.:..: cd $(CHAPTERS_DIR)/chapter$* && xelatex -interaction=nonstopmode main.tex; \
	else \
		echo "Chapter $* not found"; \
		echo "Use 'make new $*' to create chapter $*"; \
	fi

# 编译所有章节
chaps:
	@for dir in $(CHAPTERS_DIR)/*/ ; do \
		if [ -f "$$dir/main.tex" ]; then \
			echo "Compiling $${dir}main.tex..."; \
			TEXINPUTS=.:..: cd $$dir && xelatex -interaction=nonstopmode main.tex; \
		fi \
	done

# 创建新章节的简化命令
new%:
	@mkdir -p $(CHAPTERS_DIR)/chapter$*/figures
	@if [ ! -f "$(CHAPTERS_DIR)/chapter$*/main.tex" ]; then \
		echo "\\documentclass[../../$(TARGET).tex]{subfiles}" > $(CHAPTERS_DIR)/chapter$*/main.tex; \
		echo "\\graphicspath{{./figures/}}" >> $(CHAPTERS_DIR)/chapter$*/main.tex; \
		echo "" >> $(CHAPTERS_DIR)/chapter$*/main.tex; \
		echo "" >> $(CHAPTERS_DIR)/chapter$*/main.tex; \
		echo "\\\\begin{document}" >> $(CHAPTERS_DIR)/chapter$*/main.tex; \
		echo " " >> $(CHAPTERS_DIR)/chapter$*/main.tex; \
		echo "\\\\chapter{第$*章}" >> $(CHAPTERS_DIR)/chapter$*/main.tex; \
		echo "\\section{第一节}" >> $(CHAPTERS_DIR)/chapter$*/main.tex; \
		echo "这里是第$*章的内容。" >> $(CHAPTERS_DIR)/chapter$*/main.tex; \
		echo "" >> $(CHAPTERS_DIR)/chapter$*/main.tex; \
		echo "\\end{document}" >> $(CHAPTERS_DIR)/chapter$*/main.tex; \
		if [ -f "figures/example.tex" ]; then \
			cp figures/example.tex $(CHAPTERS_DIR)/chapter$*/figures/; \
			echo "Copied example.tex to $(CHAPTERS_DIR)/chapter$*/figures/"; \
		else \
			echo "Warning: figures/example.tex not found, not copied." >&2; \
		fi; \
		echo "Created new chapter $* in $(CHAPTERS_DIR)/chapter$*/"; \
	else \
		echo "Chapter $* already exists" >&2; \
	fi
init: renew clean

# 清理不需要的图片，保留指定的图片
renew: 
	@for dir in $(FIGURES_DIRS); do \
		echo "Cleaning $$dir..."; \
		find $$dir -type f -not \( -name 'char.png' -o -name 'example.png' -o -name 'logo.png' \) -delete; \
	done

# 清理编译生成的文件
clean:
	rm -f $(TARGET).aux $(TARGET).log $(TARGET).out $(TARGET).toc $(TARGET).synctex.gz $(TARGET).bbl $(TARGET).blg
	rm -f *.pdf
	find $(CHAPTERS_DIR) -type f \( \
		-name "*.aux" -o \
		-name "*.log" -o \
		-name "*.out" -o \
		-name "*.toc" -o \
		-name "*.synctex.gz" -o \
		-name "*.pdf" \) -delete

help:
	@echo "简单示例"
	@echo "  make         - 编译完整文档"
	@echo "  make chap4   - 编译第4章"
	@echo "  make chaps   - 编译所有章节"
	@echo "  make new4    - 创建第4章"
	@echo "  make remove4 - 删除第4章"
	@echo "  make clean   - 清理所有生成的文件"
	@echo ""
	@echo "其他命令："
	@echo "  make renew   - 清理不需要的图片文件"
	@echo "  make help    - 显示本帮助信息"
