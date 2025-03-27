#!/usr/bin/perl

use warnings;
use strict;
use List::Util qw (shuffle);

# This script will generate "rotors" for an Enigma  emulator.
# That is, it will generate an array with all 26  letters randomly positioned  
#
# created by: Sean Gallaher
# date: 13-JAN-2015
# edited on: 28-JAN-2015

my $outFile = "rotors.txt" ;

open (OUT, ">>" , $outFile) 
	or die "Cannot open $outFile: $!\n";

print OUT 'my @rotorXrl =  ("A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z");' . "\n\n";

print OUT "my \@rotorXlr =  (";
  
my @inputArray =  ("A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z");

my @outputArray = shuffle @inputArray;

foreach my $letter (@outputArray) {
	print OUT "\"$letter\",";
}

print OUT ");\n\n";

close (OUT);

