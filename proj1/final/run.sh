#!/bin/bash

mkdir -p compiled images

for i in sources/*.txt tests/*.txt; do
	echo "Compiling: $i"
    fstcompile --isymbols=syms.txt --osymbols=syms.txt $i | fstarcsort > compiled/$(basename $i ".txt").fst
done

# echo "Creating the transducer 'A2R'"

fstinvert compiled/R2A.fst > compiled/A2R.fst

# echo "Creating the transducer 'birthR2A'"

# This is the first part which converts Roman birthdates to 7/9/313
fstconcat compiled/R2A.fst compiled/copy.fst > compiled/auxJ1.fst
fstconcat compiled/auxJ1.fst compiled/R2A.fst > compiled/auxJ2.fst
fstconcat compiled/auxJ2.fst compiled/copy.fst > compiled/auxJ3.fst
fstconcat compiled/auxJ3.fst compiled/R2A.fst > compiled/auxFirstPart.fst
# This is the second part which converts 7/9/13 to 07/09/0313
fstconcat compiled/d2dd.fst compiled/copy.fst > compiled/auxJ4.fst
fstconcat compiled/auxJ4.fst compiled/d2dd.fst > compiled/auxJ5.fst
fstconcat compiled/auxJ5.fst compiled/copy.fst > compiled/auxJ6.fst

fstconcat compiled/auxJ6.fst compiled/d2dddd.fst > compiled/auxSecondPart.fst
# Here we combine first part with second part resulting in birthR2A
fstcompose compiled/auxFirstPart.fst compiled/auxSecondPart.fst > compiled/birthR2A.fst

# echo "Creating the transducer 'birthA2T'"

# Copy all symbols except the ones in the middle, the middle ones are converted to month name
fstconcat compiled/copy.fst compiled/copy.fst > compiled/auxK1.fst
fstconcat compiled/auxK1.fst compiled/copy.fst > compiled/auxK2.fst
fstconcat compiled/auxK2.fst compiled/mm2mmm.fst > compiled/auxK3.fst
fstconcat compiled/auxK3.fst compiled/copy.fst > compiled/auxK4.fst
fstconcat compiled/auxK4.fst compiled/copy.fst > compiled/auxK5.fst
fstconcat compiled/auxK5.fst compiled/copy.fst > compiled/auxK6.fst
fstconcat compiled/auxK6.fst compiled/copy.fst > compiled/auxK7.fst
fstconcat compiled/auxK7.fst compiled/copy.fst > compiled/birthA2T.fst


# echo "Creating the transducer 'birthT2R'"

fstinvert compiled/birthA2T.fst > compiled/birthT2A.fst
fstinvert compiled/birthR2A.fst > compiled/birthA2R.fst
fstcompose compiled/birthT2A.fst compiled/birthA2R.fst > compiled/birthT2R.fst




# echo "Creating the transducer 'birthR2L'"

fstcompose compiled/birthR2A.fst compiled/date2year.fst > compiled/auxM1.fst
fstcompose compiled/auxM1.fst compiled/leap.fst > compiled/birthR2L.fst

# echo "Testing 'birthR2A', 'birthA2T', 'birthT2R', 'birthR2L' with each group member birthday date: "
fstcompose compiled/86392.fst  compiled/birthA2T.fst > compiled/86392birthA2T.fst
fstcompose compiled/86392T.fst compiled/birthT2R.fst > compiled/86392birthT2R.fst
fstcompose compiled/86392R.fst compiled/birthR2A.fst > compiled/86392birthR2A.fst
fstcompose compiled/86392R.fst compiled/birthR2L.fst > compiled/86392birthR2L.fst


fstcompose compiled/102313.fst  compiled/birthA2T.fst > compiled/102313birthA2T.fst
fstcompose compiled/102313T.fst compiled/birthT2R.fst > compiled/102313birthT2R.fst
fstcompose compiled/102313R.fst compiled/birthR2A.fst > compiled/102313birthR2A.fst
fstcompose compiled/102313R.fst compiled/birthR2L.fst > compiled/102313birthR2L.fst



for i in compiled/*.fst; do
	echo "Creating image: images/$(basename $i '.fst').pdf"
    fstdraw --portrait --isymbols=syms.txt --osymbols=syms.txt $i | dot -Tpdf > images/$(basename $i '.fst').pdf
done
