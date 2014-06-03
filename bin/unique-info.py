#!/usr/bin/env python
import sys

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
