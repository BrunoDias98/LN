# LN

Notas sobre formato da entrega: 

Submit in Fenix, project MP1, a zip file with, and only with:
-> a shell script [the name has to be "run.sh"] with all the commands used to generate all transducers, either in binary and in graphical format (PDF, PS or PNG) from the ".txt" files;
-> a folder "sources" containing all the text files used to define the transducers (extension ".txt");
-> a folder "tests" with all the source test files (extensions ".txt");
-> a folder "compiled" containing all the compiled version of all the transducers used, including the tests (extension ".fst");
-> a folder "images" containing the graphical versions of all the transducers, including the tests (extension ".pdf", ".ps" or ".png");
-> a short report, whose file name should be "report.txt" or "report.pdf", with a maximum of 1 page, containing the identification of the members of the group, the
description of the options taken and comments on the solution developed. The report MUST provide an estimate of each element's contribution to the work. For
example: Peter: 60%, John: 40%, along with a short justification.
-> You can make several submissions: a new submission replaces the previous one. Attention:
developed transducers must have exactly the same names as above;
the 4 folders "sources", "tests", "compiled" and "images" should not contain sub-folders.


Algumas notas para os próximos exercicios:

A2R -> reverse R2A

birthR2A -> RSA | Skip | R2A | Skip | RSA

birthT2R -> reverse birthA2T | reverse birthR2A

birthR2L -> birthR2A | date2year | leap

d2dd (incompleto)

d2dddd (não feito)

date2year skip * 6 | copy * 4

