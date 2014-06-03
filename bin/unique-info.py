#!/usr/bin/env python
import sys
"""
Input:  A list of genes corresponding to unique loci (first argument), and the
        output of 'maker_info.py' (second argument).
Ouptut: To each line of the input, this script adds a single field: a yes/no
        value indicating whether that mRNA corresponds to a unique locus.
Usage:  ./unique-info.py                      \
            v1-unique-genes.txt               \
            <(bin/maker-info.py v1 < v1.gff3) \
            > v1-info.txt
"""

def parse_list(fp):
  uniq = {}
  for line in fp:
    uniq[line.rstrip()] = 1
  return uniq

if __name__ == "__main__":
  uniq = parse_list(open(sys.argv[1]))
  for line in open(sys.argv[2]):
    values = line.rstrip().split("\t")
    isuniq = "no"
    if values[2] in uniq:
      isuniq = "yes"
    values.append(isuniq)
    print "\t".join(values)
