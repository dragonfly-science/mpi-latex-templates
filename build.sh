#!/bin/bash
set -ex
export RUN=
export TEXINPUTS=.///:..//latex//:..//graphics//:
make
cp mpi-latex-templates*.deb /output/
cp latex/mpi.pdf /output/
cp examples/mpi-far.pdf /output/
cp examples/mpi-plenary.pdf /output/
cp examples/mpi-aebr.pdf /output/