#!/usr/bin/env python
import re, sys

def abinit_check(id):
  for abinit in ["augustus", "snap", "genemark", "Pd"]:
    if abinit in id:
      return abinit 
  return "unknown"

if __name__ == "__main__":
  for line in sys.stdin:
    if not "\tmRNA\t" in line:
      continue

    aed_match = re.search("_AED=([^;]+)", line)
    assert aed_match, "mRNA annotated edit distance not found"

    id_match  = re.search("ID=([^;]+)", line)
    assert id_match, "mRNA ID not found"

    parent_match  = re.search("Parent=([^;]+)", line)
    assert parent_match, "mRNA Parent not found"

    db_match  = re.search("Dbxref=MAKER:([^;]+)", line)
    if db_match:
      abinit = abinit_check(db_match.group(1))
    else:
      abinit = abinit_check(id_match.group(1))
    assert abinit, "Ab initio source not found"

    print "%s\t%s\t%s\t%s\t%s" % (sys.argv[1], id_match.group(1), parent_match.group(1), abinit, aed_match.group(1))
