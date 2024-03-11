This repository was created to hold various calculators used in the Edwards
Accelerator Lab at Ohio University in Athens, Ohio.

`findenergy` is a perl CGI program that allows users to select the particle and
charge state, and then enter the NMR value read from the HP 53131a frequency
counter.  

`energy_equation.png` and `frequench_equation.png` are PNGs of the equations used
to calculate the beam energy or NMR frequench given the following parameters:

 - the particle mass, `m`
 - the magnet constant, `k` or `K`
 - the charge state, `z` or `Z`
 - the NMR Frequency, `f`
 - the rest mass, `m0`
 - the particle frequency, `Ec`

 `NMR_Equations.docx` is a document using Microsoft Word's equation editor to
 format the formulas for energy and frequency.

 `findenergy_test.pl` is the tests for `findenergy`.  The test program reads in
 the output of the fortran program from the file `fort.3`, extracts the
 frequencies, and compares the energy <=> frequency mapping with the calculation
 used in findenergy.  Originally I had thought to do this by calling the CGI
 script from the tests, but there are approximately 2M energies, and I didn't
 think the added HTTP traffic made sense.  

 `fort.3` is the comprehensive output of the the original fortran code, running
 on a set of input parameters that covers everything we've used to date.  

`nmrtable.f` is a set of fortran code originally used on some IBM 370 and other
machines that generates lookup tables that can be used to convert from NMR
frequency to beam energy and vice-versa.  It also has it's own README.fortran,
which also documents some other programs that might get published eventually.
