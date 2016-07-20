#!/usr/bin/perl 
use strict;
use warnings;
#Name of file - cpg.pl
#Name         - Sithalechumi Narayanan
#Date         - September 22nd 2014

#Based in part on fasta.pl by Dr. Jeff Solka

# Purpose: Read sequences from a FASTA format file

# the argument list should contain the file name
if (scalar @ARGV < 1)
{
die "usage: cpg.pl filename\n" 
}

# get the filename from the argument list
my ($filename) = @ARGV;
$filename = $ARGV[0];


# Open the file given as the first argument on the command line
open(INFILE, $filename) or die "Can't open $filename\n";

# variable declarations:
my @header = ();		    # array of headers
my @sequence = ();		    # array of sequences
my $count = 0;	           # number of sequences

# read FASTA file
my $n = -1;			    # index of current sequence
while (my $line = <INFILE>) {
    chomp $line;		    # remove training \n from line
    if ($line =~ /^>/) { 	    # line starts with a ">"
	$n++;			    # this starts a new header
	$header[$n] = $line;	    # save header line
	$sequence[$n] = "";	    # start a new (empty) sequence
    }
    else {
	next if not @header;	    # ignore data before first header
	$sequence[$n] .= $line     # append to end of current sequence
    }
}
$count = $n+1;			  # set count to the number of sequences
close INFILE;

# remove white space from all sequences
for (my $i = 0; $i < $count; $i++) 
    {
     $sequence[$i] =~ s/\s//g;
    }

#########to count the number of sequences in the input file
print ("There are $count sequences in the file\n");       

my $total_length = 0;
my $max_length = 0; 
my $min_length = 0;
my $avg_length = 0;
my $seq_length = 0;
for (my $i = 0; $i < $count; $i++)
    {
	 $seq_length = length($sequence[$i]);                # to find the total length of all sequences
     $total_length = $total_length + $seq_length;    
      if ($i == 0) 
	  {
	  $max_length = $seq_length;                            # to find the Maximum sequence length
      $min_length = $seq_length;                       # to find the Minimum sequence length   
	  }
	  else
	  { 
	    if ($max_length < $seq_length)
		{
		  $max_length = $seq_length; 
	    }
		
		if ($min_length > $seq_length)
		{
		   $min_length = $seq_length;
		}
	  }
	  
    }
	 print ("Total sequence length = $total_length\n");
	 print ("Maximum sequence length = $max_length\n");
	 print ("Minimum sequence length = $min_length\n");
	 
$avg_length = $total_length / $count;                          # to find the Average sequence length
print ("Ave sequence length = $avg_length\n");

## For each sequence

for (my $i = 0; $i < $count; $i++) 
    {
	  my $count_of_A = 0;
      my $count_of_G = 0;
      my $count_of_C = 0;
      my $count_of_T = 0;
	  my $count_of_CpG = 0;
	  $seq_length = length($sequence[$i]);
	  
      print ("$header[$i]\n");                    # to print the header line
	  print ("Length:", length $sequence[$i],"\n");   	# to find out the length of each sequence
	  for (my $position = 0; $position < length $sequence[$i]; $position++)
	  {
	       my $base = substr ($sequence[$i], $position, 1);           #to find out the count of each nucleotide in the sequence
		   my $bases = substr ($sequence[$i], $position, 2);           #to find out the count of CpG dinucleotides in the sequence
	       if ($base =~ /a/ig) {$count_of_A++;}
           elsif ($base =~ /g/ig) {$count_of_G++;}
           elsif ($base =~ /c/ig) {$count_of_C++;}
           elsif ($base =~ /t/ig) {$count_of_T++;}
           if ($bases =~ /cg/ig) {$count_of_CpG++;}              ###the variable $bases will consider two values and check if its CpG 
	  }                                           ###if(condition) is yes then counts CpG, if(condition) is false goes to the start of for loop 
	  
	  my $fraction_A = 0;                            #to find out the fraction of nucleotide in sequence
	  my $fraction_G = 0;
	  my $fraction_C = 0;
	  my $fraction_T = 0;
	  my $fraction_CpG = 0;                          
	 
	  $fraction_A = ($count_of_A / $seq_length);
	  $fraction_C = ($count_of_C / $seq_length);
	  $fraction_G = ($count_of_G / $seq_length);
	  $fraction_T = ($count_of_T / $seq_length);
	  $fraction_CpG = ($count_of_CpG / $seq_length );
	 
      printf ("A:%4d %1.2f\n", $count_of_A, $fraction_A);
      printf ("C:%4d %1.2f\n", $count_of_C, $fraction_C);
      printf ("G:%4d %1.2f\n", $count_of_G, $fraction_G);
      printf ("T:%4d %1.2f\n", $count_of_T, $fraction_T);
      printf ("CpG:%4d %1.2f\n", $count_of_CpG, $fraction_CpG);        
	}
exit;