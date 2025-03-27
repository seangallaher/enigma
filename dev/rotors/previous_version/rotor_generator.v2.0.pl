#!/usr/bin/perl
#
use warnings;
use strict;
use List::Util qw (shuffle);
# This script will generate "rotors" for an Enigma  emulator.
# That is, it will generate table of 26 numbers aligned to 26 numbers
# randomly.
# created by: Sean Gallaher
# date: 13-Dec-2015
#
my $outFile = "rotors.txt" ;

open (OUT, ">>" , $outFile) 
	or die "Cannot open $outFile: $!\n";

print OUT 'my @rotorX = qw (';
  
my @inputArray =  ("0","1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25");

my @outputArray = shuffle @inputArray;

my $i = 0;
while ($i < 26) {
	my $input = $inputArray[$i];
	my $output = $outputArray[$i];
	print OUT "$output, ";
	$i++;
}

print OUT ");\n";

close (OUT);

