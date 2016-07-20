#!/usr/bin/perl
use strict;
use warnings;
use BeginPerlBioinfo;

#Name of file - program3_Narayanan.pl
#Name         - Sithalechumi Narayanan
#Date         - November 10th 2014
#Based in part of example10.1 found in Beginning Perl for Bioinformatics - James Tisdall 
#and also based in part of Dr. Jeff Solka's lecture BINF634_Lec04 - slide #21  

my @annotation = ( );
my @title = '';
my @abstract = '';

my $num_args = $#ARGV + 1; 
if ($num_args != 1) 
{ 
print "\nUsage: Perl program3_Narayanan.pl InputFile\n";     
exit; 
}
my $filename = $ARGV[0];              #input file as command line argument
my $outputFile = 'word_counts.txt';

open (my $fh, '>', $outputFile) or die "Could not open file '$outputFile' $!";

#Subroutine call to extract AB field-abstract and TI field-title 
parse_pub_med (\@annotation, \@title, \@abstract, $filename);
for (my $i = 0; $i<scalar @abstract; $i++)                         #prints title 
{
	print $fh ("\nTitle: \n", $title[$i]); 
	if ($abstract[$i])
    {
	    print $fh ("\nWord Count For Abstract ",$i+1," is\n");#prints abstract's word count only when abstract AB field isn't empty
        print $fh (compute_word_count($abstract[$i]),"\n");  
    }
    else
    {
	    print $fh ("Word count for Abstract ", $i+1, " is 0\n"); #prints word count as 0 when AB field is empty
    }
}
close $fh;

#Subroutine definition
sub parse_pub_med
{
my ($annotation, $ti_field, $ab_field, $filename) = @_;                                
my $title_flag = 0;
my $abstract_flag = 0;
my $i = 0;
my @pubmed = ( );
@pubmed = get_file_data ($filename);
foreach my $line (@pubmed)
  {
    if($title_flag)
	{
	  if ($line =~ /^PG/)
	  {                         #if $line is reading PG field, then the $title_flag becomes 0       
	    $title_flag = 0;
	  }
	  else
	  {
	     @$ti_field[$i] .= $line;                 #otherwise concatenates
	  }
	}
  
  
  if ($line =~ /^TI/)
     {
	   $line=~s/^TI//;                        #$title_flag becomes 1 when $line reads TI field
	   $line=~s/-//;
       @$ti_field[$i] .= $line;
	   $title_flag = 1
     }
  elsif ($line =~ /^AD/)                                        
	{
	   push (@$annotation, $line);                   #Checks if $line starts with AD, if so then $abstract_flag becomes 0
	   $abstract_flag = 0;
	   $i++;
	}
  elsif ($abstract_flag)                              #otherwise concatenates, elsif $abstract_flag becomes 1
	{
	   @$ab_field[$i] .= $line;
	}
  elsif ($line =~ /^AB/)
     {
	   $line =~ s/^AB//;
	   $line =~ s/-//;
	   @$ab_field[$i] .= $line;
	   $abstract_flag = 1;                     #$abstract_flag is 1, when $line reads AB field
     }
  else
     {
       push (@$annotation, $line);                   #now, everything else that is not required, gets stored in @annotation
	 }
  } 
}

#In order to find out word count 
sub compute_word_count
	{
	my ($abstract_value) = @_;
	my %count = ();
		for my $word (split " ",$abstract_value)
			{
				if (not exists $count{$word})   #checks every line for a repetition of word
				{                                                     
				  # initialize the count for a new word
				  $count{$word} = 1;
				}
				else                                       
				{
				  # update the count for an existing word
				  $count{$word}++;
				}
			}
		for my $key (sort keys %count) 
		{
		print $fh ("$key $count{$key}\n");         #prints keys and values
		}
	}	

