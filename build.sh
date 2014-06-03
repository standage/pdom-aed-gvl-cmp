#!/usr/bin/env bash

# Copyright (c) 2014
# Daniel Standage <daniel.standage@gmail.com>

check_prereqs()
{
  which parseval > /dev/null 2>&1
  if [ "$?" -ne "0" ]; then
    echo "ParsEval not found; cannot continue"
    exit 1
  fi
}

md5_check()
{
  local filename=$1
  local filemd5=$2

  local checksum=$(md5sum $filename | sed 's/ \+/\t/'| cut -f 1)
  if [ "$checksum" != "$filemd5" ]; then
    echo "error: file $filename is incorrect (MD5 mismatch)"
    echo "    expected=$filemd5"
    echo "         got=$checksum"
    exit 1
  fi
}

get_file()
{
  local baseurl="http://gremlin2.soic.indiana.edu/pdom/annot"
  local md5=$1
  local filename=$2

  echo -n "Getting file $filename..."
  curl --silent --remote-name "$baseurl/$filename.bz2"
  bunzip2 ${filename}.bz2
  md5_check $filename $md5
  echo 'done!'
}

get_annot_files()
{
  mkdir -p scratch
  cd scratch

  get_file 963f501b27a0bc1444406c1f0ee3cbcd pdom-annot-p1.2-makeralign.gff3
  get_file 7bea6d65d9d6f0de79d942eff2a09717 pdom-annot-p1.2-prealign.gff3
  get_file b3f138e76d828f652d7c58c6a81ebdf4 pdom-annot-r1.1.gff3

  cd ..

  ln -s scratch/pdom-annot-p1.2-makeralign.gff3 p12b.gff3
  ln -s scratch/pdom-annot-p1.2-prealign.gff3   p12a.gff3
  ln -s scratch/pdom-annot-r1.1.gff3            r11.gff3
}

get_gaeval_files()
{
  # MySQL query used on the xGDBvm instances to create the *.gaeval.txt files:
  # SELECT locus_id,transcript_ids,coverage,integrity FROM gseg_locus_annotation
  
  mkdir -p scratch
  cd scratch

  get_file 53ca951a85b9b337347e937e966c0919 p1.2.makeralign.gaeval.txt
  get_file 75c1de85e40ac986980cf07d1a756bf7 p1.2.prealign.gaeval.txt
  get_file 3e231398e5181d70a549ccd80a85a7a2 r1.1.gaeval.txt

  cd ..

  # Rename for brevity's sake
  ln -s scratch/p1.2.makeralign.gaeval.txt p12b.gaeval.txt
  ln -s scratch/p1.2.prealign.gaeval.txt   p12a.gaeval.txt
  ln -s scratch/r1.1.gaeval.txt            r11.gaeval.txt
}

get_info()
{
  local annot=$1
  local uniq=$2
  local source=$3

  bin/unique-info.py \
      <(egrep "^$source" ${uniq} | cut -f 2)        \
      <(bin/maker-info.py ${annot} < ${annot}.gff3) \
      | sort -k2,2 \
      > scratch/${annot}.maker.txt
  bin/gaeval-info.py < ${annot}.gaeval.txt \
      | sort -k1,1 \
      > scratch/${annot}.gvl.txt
}

combine_data()
{
  local refr=$1
  local pred=$2
  local outmd5=$3
  local cmp=${refr}-v-${pred}
  local outfile=pdom-${cmp}.aed-gaeval.txt
  
  # Determine loci unique to each annotation
  echo -n "Determining unique loci ($cmp)..."
  parseval -o scratch/${cmp}.psvl -w    \
      <(grep -v $'UTR\t' ${refr}.gff3)  \
      <(grep -v $'UTR\t' ${pred}.gff3) \
      2> scratch/${cmp}.psvl.log
  if [ ! -s scratch/${cmp}.psvl ]; then
    echo "ParsEval failed for ${cmp}.psvl"
    tail -n 15 scratch/${cmp}.psvl.log
    exit 1
  fi
  bin/uniq.pl < scratch/${cmp}.psvl > scratch/${cmp}.uniq.txt
  echo 'done!'

  echo -n "Combining data ($cmp)..."
  get_info ${refr} scratch/${cmp}.uniq.txt refr
  get_info ${pred} scratch/${cmp}.uniq.txt pred

  echo $'Version\tID\tParent\tAbInit\tAED\tCoverage\tIntegrity\tUnique' \
      > $outfile
  paste scratch/${refr}.maker.txt scratch/${refr}.gvl.txt \
      |  awk '{ print $1,$2,$3,$4,$5,$8,$9,$6 }' \
      |  tr ' ' '\t' \
      >> $outfile
  paste scratch/${pred}.maker.txt scratch/${pred}.gvl.txt \
      |  awk '{ print $1,$2,$3,$4,$5,$8,$9,$6 }' \
      |  tr ' ' '\t' | sed $'s/\tPd\t/\tVIGA\t/' \
      >> $outfile

  md5_check $outfile $outmd5
  echo 'done!'
}

# Define the main procedure
main()
{
  check_prereqs
  get_annot_files
  get_gaeval_files

  combine_data r11 p12a "20e62162c1acc35a31d1337ccf6ecb74"
  combine_data r11 p12b "250434c21a8fd760d8080cc2e57cc4c9"
}

# Actually run the main procedure
main
