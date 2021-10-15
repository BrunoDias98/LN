#!/bin/bash

mkdir -p compiled images

for i in sources/*.txt tests/*.txt; do
	echo "Compiling: $i"
    fstcompile --isymbols=syms.txt --osymbols=syms.txt $i | fstarcsort > compiled/$(basename $i ".txt").fst
done

echo "Creating the transducer 'A2R' by inverting R2A"

fstinvert compiled/R2A.fst > compiled/A2R.fst
#fstcompose compiled/Anumber1.fst compiled/A2R.fst | fstshortestpath | fstproject --project_output=true | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt

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
fstconcat compiled/auxJ6.fst compiled/d2dddd_1_2_4_more.fst > compiled/auxSecondPart.fst

# Here we combine first part with second part resulting in birthR2A
fstcompose compiled/auxFirstPart.fst compiled/auxSecondPart.fst > compiled/birthR2A.fst

# Test with roman birth date
fstcompose compiled/romanBirthDate.fst compiled/birthR2A.fst | fstshortestpath | fstproject --project_output=true | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt


echo "Creating the transducer 'birthA2T' and trying with the input tests/arabicBirthDate"

# Copy all symbols except the ones in the middle, the middle ones are converted to month name
fstconcat compiled/copy.fst compiled/copy.fst > compiled/auxK1.fst
fstconcat compiled/auxK1.fst compiled/copy.fst > compiled/auxK2.fst
fstconcat compiled/auxK2.fst compiled/mm2mmm.fst > compiled/auxK3.fst
fstconcat compiled/auxK3.fst compiled/copy.fst > compiled/auxK4.fst
fstconcat compiled/auxK4.fst compiled/copy.fst > compiled/auxK5.fst
fstconcat compiled/auxK5.fst compiled/copy.fst > compiled/auxK6.fst
fstconcat compiled/auxK6.fst compiled/copy.fst > compiled/auxK7.fst
fstconcat compiled/auxK7.fst compiled/copy.fst > compiled/birthA2T.fst

# Test with Arabic birth date
fstcompose compiled/arabicBirthDate.fst compiled/birthA2T.fst | fstshortestpath | fstproject --project_output=true | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt



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
#fstcompose compiled/arabicTextBirthDate.fst compiled/auxLFirstPart.fst | fstshortestpath | fstproject --project_output=true | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt
#A2R SKIP A2R SKIP A2R (inversion of birthR2A)
fstinvert compiled/birthR2A.fst > compiled/birthA2R.fst
#fstcompose compiled/arabicBirthDate.fst compiled/birthA2R.fst | fstshortestpath | fstproject --project_output=true | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt
# composition of mm2mmm and A2R
fstcompose compiled/auxLFirstPart.fst compiled/birthA2R.fst > compiled/birthT2R.fst
fstcompose compiled/arabicTextBirthDate.fst compiled/birthT2R.fst | fstshortestpath | fstproject --project_output=true | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt

echo "Creating the transducer 'birthR2L' and trying with the input tests/romanBirthDate"
fstcompose compiled/birthR2A.fst compiled/date2year.fst > compiled/auxM1.fst
fstcompose compiled/auxM1.fst compiled/leap.fst > compiled/birthR2L.fst
fstcompose compiled/romanBirthDate2.fst compiled/birthR2L.fst | fstshortestpath | fstproject --project_output=true | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt

#echo "Testing the transducer 'd2dddd' with the input 'tests/month1.txt' (stdout)"
#fstcompose compiled/dat2.fst compiled/d2dddd.fst | fstshortestpath | fstproject --project_output=true | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt

for i in compiled/*.fst; do
	echo "Creating image: images/$(basename $i '.fst').pdf"
    fstdraw --portrait --isymbols=syms.txt --osymbols=syms.txt $i | dot -Tpdf > images/$(basename $i '.fst').pdf
done
