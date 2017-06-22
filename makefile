IMAGE := docker.dragonfly.co.nz/texlive-16.04:2017-06-16

TEXINPUTS := .///:..//latex//:..//graphics//:..//biblatex-mpi//:
RUN ?= docker run -it --rm --net=host --user=$$(id -u):$$(id -g) -e RUN= -e TEXINPUTS=$(TEXINPUTS) -v$$(pwd):/work -w /work $(IMAGE)

all: package/.build

examples/mpi-far.pdf: examples/mpi-far.tex examples/test.bib latex/mpi.pdf graphics/FAR.jpg clean_examples
	$(RUN) bash -c "cd examples && xelatex mpi-far && biber mpi-far && xelatex mpi-far"

latex/mpi.pdf: latex/mpi.dtx latex/mpi.ins clean
	$(RUN) bash -c "cd latex && latex mpi.ins"
	$(RUN) bash -c "cd latex && xelatex mpi.dtx"

.PRECIOUS: package/.build
package/.build: examples/mpi-far.pdf 
	$(RUN) bash -c "cd package && debuild -us -uc && mv ../mpi-latex*{.dsc,.changes,.build,tar.xz} . && touch .build"

.PHONY: clean
clean: clean_examples clean_latex
	rm -rf package/debian/mpi-latex-templates/ 
	rm -f package/mpi-latex* package/debian/mpi-latex-templates.substvars package/debian/files
	rm -f package/debian/debhelper-build-stamp package/debian/mpi-latex-templates.debhelper.log 
	rm -f mpi-latex-templates_*

.PHONY: clean_examples
clean_examples:	
	rm -f  examples/*.log examples/*.aux examples/*.out examples/*.bbl examples/*.pdf examples/*.blg \
		examples/*.bcf examples/*.run.xml examples/*.toc examples/*-self.bib  examples/*.nav examples/*.snm \
		examples/*.fdb_latexmk  examples/*.fls
	
.PHONY: clean_latex
clean_latex:	
	rm -f latex/*.cls latex/*.idx latex/*.sty  latex/*.fdb_latexmk latex/*.log latex/*.fls latex/*.ind \
		latex/*.out latex/*.aux latex/*.glo latex/*.pdf latex/*.toc latex/*.ilg
