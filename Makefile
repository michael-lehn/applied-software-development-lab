# Build the English teaching materials with LuaLaTeX.
#
#   make            build all documents and copy the PDFs to pdf/
#   make handouts   build the lab handouts only
#   make clean      remove intermediate build files

LATEXMK  ?= latexmk
LMKFLAGS := -lualatex -interaction=nonstopmode -halt-on-error -file-line-error -quiet

BUILD    := build
HANDOUTS := $(sort $(wildcard handouts/handout*.tex))
SUPPL    := $(sort $(wildcard supplementary/*.tex))

HANDOUT_PDFS := $(patsubst handouts/%.tex,pdf/%.pdf,$(HANDOUTS))
SUPPL_PDFS   := $(patsubst supplementary/%.tex,pdf/%.pdf,$(SUPPL))

export TEXINPUTS := $(CURDIR)/tex//:$(CURDIR)/figures//:$(TEXINPUTS)

.PHONY: all handouts supplementary clean distclean

all: handouts supplementary

handouts: $(HANDOUT_PDFS)

supplementary: $(SUPPL_PDFS)

pdf/%.pdf: handouts/%.tex tex/aslab.cls $(wildcard figures/shared/*) $(wildcard figures/%/*)
	@mkdir -p $(BUILD) pdf
	cd handouts && $(LATEXMK) $(LMKFLAGS) -outdir=../$(BUILD) $*.tex
	cp $(BUILD)/$*.pdf $@

pdf/%.pdf: supplementary/%.tex $(wildcard supplementary/figures/*)
	@mkdir -p $(BUILD) pdf
	cd supplementary && $(LATEXMK) $(LMKFLAGS) -outdir=../$(BUILD) $*.tex
	cp $(BUILD)/$*.pdf $@

clean:
	$(RM) -r $(BUILD)

distclean: clean
	$(RM) $(HANDOUT_PDFS) $(SUPPL_PDFS)
