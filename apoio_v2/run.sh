#!/bin/bash

mkdir -p compiled images

for i in sources/*.txt tests/*.txt; do
	echo "Compiling: $i"
    fstcompile --isymbols=syms.txt --osymbols=syms.txt $i | fstarcsort > compiled/$(basename $i ".txt").fst
done

echo "Creating the transducer 'A2R' by inverting it and trying the input 'tests/Anumber1.txt' (stdout)"
fstinvert compiled/R2A.fst > compiled/A2R.fst
fstcompose compiled/Anumber1.fst compiled/A2R.fst | fstshortestpath | fstproject --project_output=true | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt


# echo "Testing the transducer 'R2A' with the input 'tests/Rnumber1.txt' (stdout)"
# fstcompose compiled/Rnumber1.fst compiled/R2A.fst | fstshortestpath | fstproject --project_output=true | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt

# echo "Testing the transducer 'R2A' with the input 'tests/Rnumber2.txt' (stdout)"
# fstcompose compiled/Rnumber2.fst compiled/R2A.fst | fstshortestpath | fstproject --project_output=true | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt

# echo "Testing the transducer 'R2A' with the input 'tests/Rnumber3.txt' (stdout)"
# fstcompose compiled/Rnumber3.fst compiled/R2A.fst | fstshortestpath | fstproject --project_output=true | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt

# echo "Testing the transducer 'R2A' with the input 'tests/Rnumber4.txt' (stdout)"
# fstcompose compiled/Rnumber4.fst compiled/R2A.fst | fstshortestpath | fstproject --project_output=true | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt

# echo "Testing the transducer 'R2A' with the input 'tests/Rnumber5.txt' (stdout)"
# fstcompose compiled/Rnumber5.fst compiled/R2A.fst | fstshortestpath | fstproject --project_output=true | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt

# echo "Testing the transducer 'R2A' with the input 'tests/Rnumber6.txt' (stdout)"
# fstcompose compiled/Rnumber6.fst compiled/R2A.fst | fstshortestpath | fstproject --project_output=true | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt

# echo "Testing the transducer 'R2A' with the input 'tests/Rnumber7.txt' (stdout)"
# fstcompose compiled/Rnumber7.fst compiled/R2A.fst | fstshortestpath | fstproject --project_output=true | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt

# echo "Testing the transducer 'R2A' with the input 'tests/Rnumber8.txt' (stdout)"
# fstcompose compiled/Rnumber8.fst compiled/R2A.fst | fstshortestpath | fstproject --project_output=true | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt

# echo "Testing the transducer 'R2A' with the input 'tests/Rnumber9.txt' (stdout)"
# fstcompose compiled/Rnumber9.fst compiled/R2A.fst | fstshortestpath | fstproject --project_output=true | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt

# echo "Testing the transducer 'R2A' with the input 'tests/Rnumber10.txt' (stdout)"
# fstcompose compiled/Rnumber10.fst compiled/R2A.fst | fstshortestpath | fstproject --project_output=true | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt

# echo "Testing the transducer 'R2A' with the input 'tests/Rnumbe11.txt' (stdout)"
# fstcompose compiled/Rnumber11.fst compiled/R2A.fst | fstshortestpath | fstproject --project_output=true | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt

# echo "Testing the transducer 'R2A' with the input 'tests/Rnumber12.txt' (stdout)"
# fstcompose compiled/Rnumber12.fst compiled/R2A.fst | fstshortestpath | fstproject --project_output=true | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt

# echo "Testing the transducer 'R2A' with the input 'tests/Rnumber13.txt' (stdout)"
# fstcompose compiled/Rnumber13.fst compiled/R2A.fst | fstshortestpath | fstproject --project_output=true | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt

# echo "Testing the transducer 'R2A' with the input 'tests/Rnumber14.txt' (stdout)"
# fstcompose compiled/Rnumber14.fst compiled/R2A.fst | fstshortestpath | fstproject --project_output=true | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt

# echo "Testing the transducer 'R2A' with the input 'tests/Rnumber15.txt' (stdout)"
# fstcompose compiled/Rnumber15.fst compiled/R2A.fst | fstshortestpath | fstproject --project_output=true | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt

# TODO


#echo "Testing the transducer 'mm2mmm' with the input 'tests/month1.txt' (stdout)"
#fstcompose compiled/month1.fst compiled/mm2mmm.fst | fstshortestpath | fstproject --project_output=true | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt
echo "Testing the transducer 'd2dd' with the input 'tests/day1.txt' (stdout)"
fstcompose compiled/day1.fst compiled/d2dd.fst | fstshortestpath | fstproject --project_output=true | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt
#echo "Testing the transducer 'd2dddd' with the input 'tests/month1.txt' (stdout)"
#fstcompose compiled/dat2.fst compiled/d2dddd.fst | fstshortestpath | fstproject --project_output=true | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt
#echo "Testing the transducer 'copy' with the input 'tests/copy1.txt' (stdout)"
#fstcompose compiled/copy1.fst compiled/copy.fst | fstshortestpath | fstproject --project_output=true | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt
#echo "Testing the transducer 'skip' with the input 'tests/skip1.txt' (stdout)"
#fstcompose compiled/skip1.fst compiled/skip.fst | fstshortestpath | fstproject --project_output=true | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt
#echo "Testing the transducer 'date2year' with the input 'tests/date12.txt' (stdout)"
#fstcompose compiled/date12.fst compiled/date2year.fst | fstshortestpath | fstproject --project_output=true | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt
#echo "Testing the transducer 'leap' with the input 'tests/leap.txt' (stdout)"
#fstcompose compiled/leap2.fst compiled/leap.fst | fstshortestpath | fstproject --project_output=true | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt
#echo "Testing the transducer 'leap' with the input 'tests/leap.txt' (stdout)"
#fstcompose compiled/leap1.fst compiled/leap.fst | fstshortestpath | fstproject --project_output=true | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt
#echo "Testing the transducer 'leap' with the input 'tests/leap.txt' (stdout)"
#fstcompose compiled/leap3.fst compiled/leap.fst | fstshortestpath | fstproject --project_output=true | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt
#echo "Testing the transducer 'converter' with the input 'tests/numeroR.txt' (generating pdf)"
#fstcompose compiled/numeroR.fst compiled/converter.fst | fstshortestpath > compiled/numeroA.fst

for i in compiled/*.fst; do
	echo "Creating image: images/$(basename $i '.fst').pdf"
    fstdraw --portrait --isymbols=syms.txt --osymbols=syms.txt $i | dot -Tpdf > images/$(basename $i '.fst').pdf
done

#echo "Testing the transducer 'converter' with the input 'tests/numeroR.txt' (stdout)"
#fstcompose compiled/numeroR.fst compiled/converter.fst | fstshortestpath | fstproject --project_output=true | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt
