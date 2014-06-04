rm *.txt *.gff3
if [ "$1" == "all" ]; then
  rm -r scratch viz
fi
