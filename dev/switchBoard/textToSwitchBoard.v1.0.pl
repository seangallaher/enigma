#!/usr/bin/perl
#
#
use strict;
use warnings;


my $input = shift @ARGV;

open (IN, '<', $input)
	or die "Cannot open $input: $!\n";

$input =~ m/(.+)\.txt/;
my $key = $1;

my $output = "allKeys.txt";

open (OUT, '>>', $output)
	or die "Cannot open $output: $!\n";

print OUT "\$switchBoard{$key} = \(";

my @array;
my @lineArray;
 
foreach my $line (<IN>) {
	chomp $line;
	@lineArray = split (/\t/, $line);
	my $randNum = $lineArray[1];
	push @array , $randNum;
}

my $letterSeq = join ("\t", @array);

my @letterArray = ('A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z');
my $allLetters = join ("\t", @letterArray);

my $i = 0;

while ($i < 10) {
	my $j = $i + 15;
	my $inputNum = $array[$i];
	my $outputNum = $array[$j];
	my $inputLetter = $letterArray[$inputNum];
	my $outputLetter = $letterArray[$outputNum];
	print OUT "\"$inputLetter\" -> \"$outputLetter\", \"$outputLetter\" -> \"$inputLetter\" , ";	
	$i++;
}
	
print OUT "\)\;\n";

close (IN);
close (OUT);


