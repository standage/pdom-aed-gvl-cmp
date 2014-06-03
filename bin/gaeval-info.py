#!/usr/bin/env python
import sys

if __name__ == "__main__":
  for line in sys.stdin:
    if line.startswith("locus_id"):
      continue

    locus_id, transcripts, coverage, integrity = line.rstrip().split("\t")
    if coverage == "NULL":
      coverage = "0"
    if integrity == "NULL":
      integrity = "0"
    for trans in transcripts.split(","):
      print "%s\t%s\t%s" % (trans, coverage, integrity)
