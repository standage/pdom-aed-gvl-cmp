#!/usr/bin/env perl
use strict;

# Input: ParsEval output (text format)
# Output: For each gene that belongs to an unmatched locus, two tab-delimited
#         values: source (reference or prediction; see ParsEval), gene ID
#
# Here, 'unmatched locus' means a locus that contains only reference genes or
# only prediction genes.

while(my $line = <STDIN>)
{
  next unless($line =~ m/\|---- Locus:/);
  $line = <STDIN>;
  $line = <STDIN>;
  $line = <STDIN>;
  
  my @refr;
  my @pred;

  my $refrnone = 0;  
  while($line = <STDIN>)
  {
    chomp($line);
    if($line =~ m/^\|    None!/)
    {
      $refrnone = 1;
    }
    last if($line =~ m/^\|\s*$/);
    $line =~ s/\|    (\S+)/$1/;
    push(@refr, $line);
  }

  $line = <STDIN>;
  my $prednone = 0;  
  while($line = <STDIN>)
  {
    chomp($line);
    if($line =~ m/^\|    None!/)
    {
      $prednone = 1;
    }
    last if($line =~ m/^\|\s*$/);
    $line =~ s/\|    (\S+)/$1/;
    push(@pred, $line);
  }

  if($prednone)
  {
    for my $gene(@refr)
    {
      printf("refr\t%s\n", $gene);
    }
  }
  if($refrnone)
  {
    for my $gene(@pred)
    {
      printf("pred\t%s\n", $gene);
    }
  }
}
