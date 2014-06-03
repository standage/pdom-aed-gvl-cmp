#!/usr/bin/env perl
use strict;

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
