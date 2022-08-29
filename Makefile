
# The key files that make up the index
TEXFILES = vegetariano.tex \
	sections/seealso.tex \
	sections/soups.tex \
	sections/salads.tex \
	sections/crostini.tex \
	sections/pasta.tex \
	sections/rice.tex \
	sections/polenta.tex \
	sections/legumes.tex \
	sections/eggs.tex \
	sections/pancakes.tex \
	sections/pizzas.tex \
	sections/casseroles.tex \
	sections/sautes.tex \
	sections/desserts.tex

# By default generate the scratch index pdf file
all: vegetariano.dvi vegetariano.pdf index.pdf

# 'make printable' will generate the double sided booklet printable pdf
printable:	index_booklet.pdf

# The scratch first stage build
vegetariano.dvi:	$(TEXFILES)
	latex vegetariano.tex
	latex vegetariano.tex
	makeindex vegetariano.idx
	latex vegetariano.tex

vegetariano.pdf:	vegetariano.dvi
	dvipdf vegetariano.dvi
	@echo -n ">>> Recipe count: "
	@grep '\italianrecipe{' $(TEXFILES) | wc -l

# The second stage plain A4 index
index.dvi:	vegetariano.dvi index.tex
	latex index.tex
	splitindex index.idx
	#cp vegetariano.idx index.idx
	#cp vegetariano.aux index.aux
	cp vegetariano.ind index-index.ind
	latex index.tex

index.pdf:	index.dvi
	dvipdf index.dvi

index.ps:	index.dvi
	dvips index.dvi

# The (optional) third stage, a booklet form index
# Generate us a booklet printable PDF. This will generate a5 pages to print on a double sided
# a4 printer.
index_booklet.pdf:	index.ps
	# psbook to get the pages in the right book signature order
	psbook index.ps index_booklet1.ps
	# psnup to shrink the pages down two-per-side so we can then fold
	# the booklet.
	psnup -2 index_booklet1.ps index_booklet2.ps
	# And then convert it back to a PDF
	ps2pdf index_booklet2.ps index_booklet.pdf

clean:
	-rm -f vegetariano.aux
	-rm -f vegetariano.dvi
	-rm -f vegetariano.idx
	-rm -f vegetariano.ilg
	-rm -f vegetariano.ind
	-rm -f vegetariano.log
	-rm -f vegetariano.pdf
	-rm -f index.aux
	-rm -f index.dvi
	-rm -f index.idx
	-rm -f index.ilg
	-rm -f index.ind
	-rm -f index.log
	-rm -f index.pdf
	-rm -f index.ps
	-rm -f index-index.idx
	-rm -f index-index.ilg
	-rm -f index-index.ind
	-rm -f index_booklet1.ps
	-rm -f index_booklet2.ps
	-rm -f index_booklet.pdf

