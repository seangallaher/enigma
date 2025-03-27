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
	if ($line !~ m/^#/) {
		$line =~ tr/a-z/A-Z/;
		$line =~ s/[[:punct:]]//g;
		$line =~ s/ //g;
		$inString = $inString . $line;
	}
}

print OUT  "#input string:\n$inString\n\n";

close (IN);
my @inputText = split (//, $inString);


# The SwitchBoard
# This part transposes 10 of 26 letters (e.g all Ts become Gs, and all Gs become Ts).

my %switchBoard;

%switchBoard = ("key1" => {"T" => "Y", "Y" => "T" , "R" => "N", "N" => "R" , "I" => "E", "E" => "I" , "P" => "A", "A" => "P" , "J" => "C", "C" => "J" , "K" => "M", "M" => "K" , "D" => "W", "W" => "D" , "F" => "O", "O" => "F" , "X" => "L", "L" => "X" , "U" => "Z", "Z" => "U" } , "key2" => { "W" => "F", "F" => "W" , "N" => "X", "X" => "N" , "Z" => "T", "T" => "Z" , "R" => "C", "C" => "R" , "M" => "L", "L" => "M" , "U" => "K", "K" => "U" , "V" => "O", "O" => "V" , "A" => "Y", "Y" => "A" , "Q" => "E", "E" => "Q" , "P" => "J", "J" => "P" } , "key3" => { "L" => "A", "A" => "L" , "Z" => "G", "G" => "Z" , "U" => "Y", "Y" => "U" , "N" => "M", "M" => "N" , "V" => "S", "S" => "V" , "D" => "O", "O" => "D" , "X" => "E", "E" => "X" , "K" => "Q", "Q" => "K" , "H" => "F", "F" => "H" , "J" => "P", "P" => "J" } , "key4" => { "F" => "N", "N" => "F" , "J" => "I", "I" => "J" , "A" => "G", "G" => "A" , "Q" => "B", "B" => "Q" , "S" => "P", "P" => "S" , "O" => "V", "V" => "O" , "C" => "W", "W" => "C" , "T" => "K", "K" => "T" , "E" => "H", "H" => "E" , "D" => "M", "M" => "D" } , "key5" => { "G" => "U", "U" => "G" , "F" => "A", "A" => "F" , "H" => "Y", "Y" => "H" , "W" => "P", "P" => "W" , "E" => "T", "T" => "E" , "M" => "C", "C" => "M" , "S" => "I", "I" => "S" , "V" => "R", "R" => "V" , "K" => "J", "J" => "K" , "B" => "O", "O" => "B" } );

my @postSBtext;

print OUT "#post switchboard text:\n";

foreach my $inLetter (@inputText) {
	my $outLetter;
	if (defined $switchBoard{$key}{$inLetter}) {
		$outLetter = $switchBoard{$key}{$inLetter};
	}
	else {
		$outLetter = $inLetter;
	}
	print OUT "$outLetter";	
	push (@postSBtext , $outLetter);
}



# Convert letters to numbers.
my @numInput;

my %letterToNumber = ( 'A' => '0','B' => '1', 'C' => '2', 'D' => '3', 'E' => '4','F'=>'5','G'=>'6', 'H'=>'7','I'=>'8','J'=>'9','K'=>'10','L'=>'11','M'=>'12','N'=>'13','O'=>'14','P'=>'15','Q'=>'16','R'=>'17','S'=>'18','T'=>'19','U'=>'20','V'=>'21','W'=>'22','X'=>'23','Y'=>'24','Z'=>'25', '0'=>'A', '1'=>'B','2'=>'C','3'=>'D','4'=>'E','5'=>'F','6'=>'G','7'=>'H','8'=>'I','9'=>'J','10'=>'K','11'=>'L','12'=>'M','13'=>'N','14'=>'O','15'=>'P','16'=>'Q','17'=>'R','18'=>'S','19'=>'T','20'=>'U','21'=>'V','22'=>'W','23'=>'X','24'=>'Y','25'=>'Z' );

print OUT "\n\n#post letter to number conversion:\n";

foreach my $abc (@postSBtext) {
	my $num = $letterToNumber{$abc};
	print OUT "$num ";
	push (@numInput, $num);	
}


# There are 5 possible rotors (I - V) and a reflector. Three are selected to rearrange the letters. 

my @rotorI = (24, 10, 23, 16, 25, 12, 2, 11, 8, 3, 22, 4, 1, 19, 0, 13, 18, 15, 5, 17, 14, 21, 6, 20, 7, 9 );

my @rotorI_rev = (14, 12, 6, 9, 11, 18, 22, 24, 8, 25, 1, 7, 5, 15, 20, 17, 3, 19, 16, 13, 23, 21, 10, 2, 0, 4 );


my @rotorII = (17, 11, 3, 12, 15, 0, 19, 2, 23, 1, 16, 18, 9, 6, 24, 8, 4, 21, 5, 14, 13, 10, 7, 20, 22, 25 );

my @rotorII_rev = (5, 9, 7, 2, 16, 18, 13, 22, 15, 12, 21, 1, 3, 20, 19, 4, 10, 0, 11, 6, 23, 17, 24, 8, 14, 25 );


my @rotorIII = (13, 16, 2, 7, 9, 0, 25, 5, 20, 24, 15, 3, 21, 18, 10, 1, 8, 6, 22, 4, 11, 14, 23, 12, 17, 19 );

my @rotorIII_rev = (5, 15, 2, 11, 19, 7, 17, 3, 16, 4, 14, 20, 23, 0, 21, 10, 1, 24, 13, 25, 8, 12, 18, 22, 9, 6 );


my @rotorIV = (18, 4, 2, 10, 17, 24, 11, 19, 12, 14, 13, 25, 9, 6, 22, 1, 7, 20, 5, 0, 23, 15, 21, 16, 8, 3 );

my @rotorIV_rev = (19, 15, 2, 25, 1, 18, 13, 16, 24, 12, 3, 6, 8, 10, 9, 21, 23, 4, 0, 7, 17, 22, 14, 20, 5, 11 );


my @rotorV = (10, 20, 11, 17, 19, 12, 18, 14, 21, 0, 6, 16, 1, 4, 3, 8, 24, 2, 23, 25, 15, 7, 9, 5, 13, 22 );

my @rotorV_rev = (9, 12, 17, 14, 13, 23, 10, 21, 15, 22, 0, 2, 5, 24, 7, 20, 11, 3, 6, 4, 1, 8, 25, 18, 16, 19 );


my %reflector = (  "0" => "22" ,  "1" => "24" ,  "10" => "4" ,  "11" => "5" ,  "12" => "14" ,  "13" => "15" ,  "14" => "12" ,  "15" => "13" ,  "16" => "20" ,  "17" => "7" ,  "18" => "9" ,  "19" => "21" ,  "2" => "23" ,  "20" => "16" ,  "21" => "19" ,  "22" => "0" ,  "23" => "2" ,  "24" => "1" ,  "25" => "6" ,  "3" => "8" ,  "4" => "10" ,  "5" => "11" ,  "6" => "25" ,  "7" => "17" ,  "8" => "3" ,  "9" => "18"  );

my %rotorArrangement = ('key1' => {'right' => 'rotorV', 'middle' => 'rotorIII', 'left' => 'rotorIV'  }, 'key2' => {'right' => 'rotorIII','middle' => 'rotorV', 'left' => 'rotorI'  }, 'key3' => { 'right' => 'rotorI','middle' => 'rotorV','left' => 'rotorII' }, 'key4' => { 'right'=> 'rotorIV','middle'=>'rotorIII','left'=> 'rotorI'  }, 'key5' => {'right' => 'rotorV', 'middle' => 'rotorIII', 'left' => 'rotorII'  }, );



# Each letter goes through right, middle, left, reflector, left, middle, right. 

# Right Rotor A
my @stepRa;


foreach my $num (@numInput) {
	my $postRa = $rotorI[$num];
	push (@stepRa, $postRa);	

}

# Middle Rotor A
my @stepMa;

foreach my $num (@stepRa) {
	my $postMa = $rotorII[$num];
	push (@stepMa, $postMa);

}

# Left Rotor A

my @stepLa;

foreach my $num (@stepMa) {
	my $postLa = $rotorIII[$num];
	push (@stepLa, $postLa);
}

# Reflector

my @stepReflector;
	
foreach my $num (@stepLa) {
	my $postReflector = $reflector{$num};
	push (@stepReflector, $postReflector);
}

# Left Rotor B

my @stepLb;

foreach my $num (@stepReflector) {
	my $postLb = $rotorIII_rev[$num];
	push (@stepLb, $postLb);

}

# Middle Rotor B

my @stepMb;

foreach my $num (@stepLb) {
	my $postMb = $rotorII_rev[$num];
	push (@stepMb, $postMb);
}

# Right Rotor B

my @stepRb;

foreach my $num (@stepMb) {
	my $postRb = $rotorI_rev[$num];
	push (@stepRb, $postRb);
}


# Convert number to letter
print OUT "\n\n#post all rotors and back to letters\n";

my @postLetter;

foreach my $num (@stepRb) {
	my $letter = $letterToNumber{$num};
	push (@postLetter, $letter);
	print OUT "$letter";	
}

# and back through the switchboard

my @final;

print OUT "\n\n#Final Output:\n";

foreach my $inLetter (@postLetter) {
	my $outLetter;
	if (defined $switchBoard{$key}{$inLetter}) {
		$outLetter = $switchBoard{$key}{$inLetter};
	}
	else {
		$outLetter = $inLetter;
	}
	print OUT "$outLetter";
	push (@final , $outLetter);
}



close (OUT);


