IMAGE := docker.dragonfly.co.nz/texlive-16.04:2017-06-16

TEXINPUTS := .///:..//latex//:..//graphics//:..//biblatex-mpi//:
RUN ?= docker run -it --rm --net=host --user=$$(id -u):$$(id -g) -e RUN= -e TEXINPUTS=$(TEXINPUTS) -v$$(pwd):/work -w /work $(IMAGE)

#SHELL := /bin/bash
#LATEXMK_VERSION=$(strip $(patsubst Version,,$(shell latexmk -v | grep -oi "version.*")))
#ifeq ($(LATEXMK_VERSION),4.24)
#	LATEXMK_OPTIONS=-pdflatex=xelatex -latex=xelatex -pdf
#else
#	LATEXMK_OPTIONS=-xelatex
#endif
#
all: package/.build

examples/mpi-far.pdf: examples/mpi-far.tex examples/test.bib latex/mpi.sty graphics/FAR.jpg
	$(RUN) bash -c "cd examples && xelatex mpi-far && biber mpi-far && xelatex mpi-far"

latex/mpi.sty: latex/mpi.ins
	$(RUN) bash -c "cd latex && latex mpi.ins"

latex/mpi.pdf: latex/mpi.dtx latex/mpi.sty
	$(RUN) bash -c "cd latex && xelatex mpi.dtx"

.PRECIOUS: package/.build
package/.build: latex/mpi.pdf \
	examples/mpi-far.pdf 
	$(RUN) bash -c "cd package && debuild -us -uc && mv ../mpi-latex*{.dsc,.changes,.build,tar.xz} . && touch .build"

.PHONY: clean
clean:
	rm -f  examples/*{.log,.aux,.out,.bbl,.pdf,.blg,.bcf,.run.xml,.toc,-self.bib] && \
	rm -f latex/*{.cls,.idx,.sty,.fdb_latexmk,.log,.fls,.ind,.out,.aux,.glo,.pdf,.toc} && \
	rm -rf package/debian/mpi-latex-templates/ && \
	rm -f package/dragonfly-mpi* && \
	rm -f package/debian/debhelper-build-stamp 
