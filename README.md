MPI Latex Templates
=========================

This package generates LaTeX class and style files to create documents in the 
format needed for MPI science reports.

## Building the package

1. Checkout the branch corresponding to the version of Ubuntu that you are using (this makes sure that the right
       version of biber and biblatex are used).
2. Run `make` (you will need to be on the dragonfly VPN, so that you have access to docker.dragonfly.co.nz)

## Installing the package

1. Run `sudo dpkg -i ../mpi-latex-templates_XXX_all.deb`, where `XXX` is the version number of the package

## Using the package

At this point the following latex classes will be available for you to use:

 - mpi-aebr
 - mpi-far


## Documentation

General documentation is generated in the file `mpi.pdf`. Tthere is an example 
far.tex file in the examples directory showing how teh package can be used. 

## Incompatible Packages

The MPI package will not work correctly with the following packages:

 - subfig (use subcaption instead)

