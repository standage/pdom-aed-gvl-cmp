#!/usr/bin/env python
import sys
"""
Input:  GAEVAL coverage and integrity scores, retrieved from an xGDBvm
        database using the query below
Output: For each transcript, 3 tab-delimited values: the transcript ID, the
        coverage, and the integrity score
Usage:  echo "SELECT locus_id,transcript_ids,coverage,integrity FROM gseg_locus_annotation" \
            | mysql -u $user -p$pass $DB | ./gaeval-info.py > $DB.gaeval.txt
"""

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
