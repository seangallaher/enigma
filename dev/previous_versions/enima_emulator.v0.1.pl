#!/usr/bin/perl

# This is a perl script to emulate the workings
# of the Enigma machine used by the Germans during 
# WWII. It takes as input a plaintext file (designatd
# with -i|--input and a key designated with -k|--key.
# It spits out an encrypted version of the plaintext
# file, that should appear as a random string of letters.
# If you use that file as input to the Enigma emulator
# with the same key, you should get back the original 
# plaintext. 
# created by: Sean Gallaher
# date: 14-DEC-2015
#

use warnings;
use strict;

my $helpText = "\nThis is an emulator or the Enigma machine used to encode\nmessages by the Germans during World War II. You give it a text\nfile and specify one of several keys, and it spits out a text file of\nseemingly random letters. Repeating the process on the cyphertext\nwith the same key will return the plaintext.\n\n  Options:\n    -i|--input\t\tYour input text file (input.txt)\n    -k|--key\t\tA key (1|2|3|4|5)\n    -h|--help\t\tThis help file\n\n";

# check the user inputs and print help file if needed

my $inputFile = "input.txt";
my $key = "key1";

my $argLength = scalar @ARGV;
my $i = 0;

while ($i < $argLength)   {
	my $flag = $ARGV[$i];
	if ($flag =~ m/^(-h|--help)$/) {
		die "$helpText";
	}
	elsif ($flag =~ m/^(-i|--input)$/) {
		$i++;
		$inputFile = $ARGV[$i];
		$i++;
		next;
	}
	elsif ($flag =~ m/^(-k|--key)$/) {
		$i++;
		$key = "key" . $ARGV[$i];
		$i++;
		next;
	}
	else {
		$i++;
	}
}

# Validate the user inputs:

if (!defined $inputFile) {
	print "$helpText";
	exit;
}

unless ( $key =~ m/key[1-5]/) {
	print "$helpText";
	exit;
}


print "The input is: $inputFile\nThe key is: $key\n";


# open input file, condition the text, and put it in an array
#


open ( IN , '<' , $inputFile )
	or die "Cannot open $inputFile: $!\n";

open ( OUT , '>', 'outfile.txt')
	or die "Cannot open outfile.txt: $!\n";


my   $inString ;

while (my $line = <IN>) {
	chomp $line;
	$line =~ tr/a-z/A-Z/;
	$line =~ s/[[:punct:]]//g;
	$line =~ s/ //g;
	$inString = $inString . $line;
}

print OUT  "$inString\n";

close (IN);
my @inputText = split (//, $inString);


# The SwitchBoard
# This part transposes 10 of 26 letters (e.g all Ts become Gs, and all Gs become Ts).

my %switchBoard;

%switchBoard = ("key1" => {"T" => "Y", "Y" => "T" , "R" => "N", "N" => "R" , "I" => "E", "E" => "I" , "P" => "A", "A" => "P" , "J" => "C", "C" => "J" , "K" => "M", "M" => "K" , "D" => "W", "W" => "D" , "F" => "O", "O" => "F" , "X" => "L", "L" => "X" , "U" => "Z", "Z" => "U" } , "key2" => { "W" => "F", "F" => "W" , "N" => "X", "X" => "N" , "Z" => "T", "T" => "Z" , "R" => "C", "C" => "R" , "M" => "L", "L" => "M" , "U" => "K", "K" => "U" , "V" => "O", "O" => "V" , "A" => "Y", "Y" => "A" , "Q" => "E", "E" => "Q" , "P" => "J", "J" => "P" } , "key3" => { "L" => "A", "A" => "L" , "Z" => "G", "G" => "Z" , "U" => "Y", "Y" => "U" , "N" => "M", "M" => "N" , "V" => "S", "S" => "V" , "D" => "O", "O" => "D" , "X" => "E", "E" => "X" , "K" => "Q", "Q" => "K" , "H" => "F", "F" => "H" , "J" => "P", "P" => "J" } , "key4" => { "F" => "N", "N" => "F" , "J" => "I", "I" => "J" , "A" => "G", "G" => "A" , "Q" => "B", "B" => "Q" , "S" => "P", "P" => "S" , "O" => "V", "V" => "O" , "C" => "W", "W" => "C" , "T" => "K", "K" => "T" , "E" => "H", "H" => "E" , "D" => "M", "M" => "D" } , "key5" => { "G" => "U", "U" => "G" , "F" => "A", "A" => "F" , "H" => "Y", "Y" => "H" , "W" => "P", "P" => "W" , "E" => "T", "T" => "E" , "M" => "C", "C" => "M" , "S" => "I", "I" => "S" , "V" => "R", "R" => "V" , "K" => "J", "J" => "K" , "B" => "O", "O" => "B" } );

my @postSBtext;

foreach my $inLetter (@inputText) {
	my $outLetter;
	if (defined $switchBoard{$key}{$inLetter}) {
		$outLetter = $switchBoard{$key}{$inLetter};
	}
	else {
		$outLetter = $inLetter;
	}
	print OUT "$outLetter";	
	unshift (@postSBtext , $outLetter);
}



close (OUT);


