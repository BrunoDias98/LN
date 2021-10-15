#!/bin/bash

mkdir -p compiled images

for i in sources/*.txt tests/*.txt; do
	echo "Compiling: $i"
    fstcompile --isymbols=syms.txt --osymbols=syms.txt $i | fstarcsort > compiled/$(basename $i ".txt").fst
done

echo "Creating the transducer 'A2R' by inverting it and trying the input 'tests/Anumber1.txt' (stdout)"
fstinvert compiled/R2A.fst > compiled/A2R.fst
fstcompose compiled/Anumber1.fst compiled/A2R.fst | fstshortestpath | fstproject --project_output=true | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt

echo "Creating the transducer 'birthR2A' and trying with the input tests/romanBirthDate"
# This is the first part which converts Roman birthdates to 7/9/313
fstconcat compiled/R2A.fst compiled/copy.fst > compiled/auxJ1.fst
fstconcat compiled/auxJ1.fst compiled/R2A.fst > compiled/auxJ2.fst
fstconcat compiled/auxJ2.fst compiled/copy.fst > compiled/auxJ3.fst
fstconcat compiled/auxJ3.fst compiled/R2A.fst > compiled/auxFirstPart.fst
# This is the second part which converts 7/9/13 to 07/09/0313
fstconcat compiled/d2dd.fst compiled/copy.fst > compiled/auxJ4.fst
fstconcat compiled/auxJ4.fst compiled/d2dd.fst > compiled/auxJ5.fst
fstconcat compiled/auxJ5.fst compiled/copy.fst > compiled/auxJ6.fst
# CRUCIAL change d2dd to dd2dddd < --------------------------------------------------------- WATCH OUT
fstconcat compiled/auxJ6.fst compiled/d2dd.fst > compiled/auxSecondPart.fst
# Here we combine first part with second part resulting in birthR2A
fstcompose compiled/auxFirstPart.fst compiled/auxSecondPart.fst > compiled/birthR2A.fst
# Test with roman birth date
fstcompose compiled/romanBirthDate.fst compiled/birthR2A.fst > compiled/birthR2ATestResult.fst

echo "Creating the transducer 'birthA2T' and trying with the input tests/arabicBirthDate"
# copy all symbols except the ones in the middle, the middle ones are converted to month name
fstconcat compiled/copy.fst compiled/copy.fst > compiled/auxK1.fst
fstconcat compiled/auxK1.fst compiled/copy.fst > compiled/auxK2.fst
fstconcat compiled/auxK2.fst compiled/mm2mmm.fst > compiled/auxK3.fst
fstconcat compiled/auxK3.fst compiled/copy.fst > compiled/auxK4.fst
fstconcat compiled/auxK4.fst compiled/copy.fst > compiled/auxK5.fst
fstconcat compiled/auxK5.fst compiled/copy.fst > compiled/auxK6.fst
fstconcat compiled/auxK6.fst compiled/copy.fst > compiled/auxK7.fst
fstconcat compiled/auxK7.fst compiled/copy.fst > compiled/birthA2T.fst
#Test with Arabic birth date
fstcompose compiled/arabicBirthDate.fst compiled/birthA2T.fst > compiled/birthA2TTestResult.fst



echo "Creating the transducer 'birthT2R' and trying with the input tests/arabicTextBirthDate"
# ir ate ao meio e converter para digito, depois a partir do inicio percorer convertendo A2R SKIP A2R SKIP A2R
# inversion mm2mmm (month name -> number)
fstinvert compiled/mm2mmm.fst > compiled/mmm2mm.fst
# ir ate ao meio 
fstconcat compiled/copy.fst compiled/copy.fst > compiled/auxL1.fst
fstconcat compiled/auxL1.fst compiled/copy.fst > compiled/auxL2.fst
# 09/Sep/2013 to 09/09/2013
fstconcat compiled/auxL2.fst compiled/mmm2mm.fst > compiled/auxL3.fst
fstconcat compiled/auxL3.fst compiled/copy.fst > compiled/auxL4.fst
fstconcat compiled/auxL4.fst compiled/copy.fst > compiled/auxL5.fst
fstconcat compiled/auxL5.fst compiled/copy.fst > compiled/auxL6.fst
fstconcat compiled/auxL6.fst compiled/copy.fst > compiled/auxL7.fst
fstconcat compiled/auxL7.fst compiled/copy.fst > compiled/auxLFirstPart.fst
# FIRST PART WORKING
#A2R SKIP A2R SKIP A2R (inversion of birthR2A)
fstinvert compiled/birthR2A.fst > compiled/birthA2R.fst
# composition of mm2mmm and A2R
fstcompose compiled/auxLFirstPart.fst compiled/birthA2R.fst > compiled/birthT2R.fst
# WHY IS NOT GENERATING?
# TEST
fstcompose compiled/arabicTextBirthDate.fst compiled/birthA2R.fst > compiled/birthT2RTestResult.fst


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
