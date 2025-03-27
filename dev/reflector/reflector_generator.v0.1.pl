#!/usr/bin/perl
#
use warnings;
use strict;
# This script will generate the "reflector" for an Enigma  emulator.
# That is, it will generate table of 26 numbers aligned to 26 numbers
# randomly.
# created by: Sean Gallaher
# date: 13-Dec-2015
#
my $outFile = "reflector.txt" ;

open (OUT, ">>" , $outFile) 
	or die "Cannot open $outFile: $!\n";
  

my %reflector;

my $i = 0;
my $j;

while ($i < 1000) {
	$j = $i%26 ;
	my $outnum = int(rand(26));
	if ($outnum != $j) {
		if (!defined $reflector{$j}) {
			if (!defined $reflector{$outnum}) {
				$reflector{$j} = $outnum;
				$reflector{$outnum} = $j;
				print OUT "$j   $outnum\n";
			}
		}
	}
	$i++;
}

print OUT "my %reflector = ( ";

foreach my $num (sort keys %reflector) {
	my $outnum = $reflector{$num};
	print OUT " \"$num\" => \"$outnum\" , ";
}

print OUT " );";
close (OUT);

