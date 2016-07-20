#!/usr/bin/perl -w
use DBI;
use CGI qw(:standard);
use CGI::Carp qw/fatalsToBrowser/;

my $user='snaray11';
my $password='snaray112624';
my $dbh = DBI->connect("DBI:mysql:database=snaray11", $user, $password, {RaiseError => 1});
$dbh->do("drop table IF EXISTS DNA_SIMPLE_STATS");    # in case it already exists
my $url = "/snaray11/cgi-bin/program4_Narayanan_part2.pl";

#Based in part of Dr. Jeff Solka's lectures BINF634_lec09_CGI slide #30, BINF634_lec10_MySQL slide #33 #34 and also 
#based in part of programming assignment 1 - cpg.pl

print header;
print start_html('CGI for a FASTA file'),
    h3('FASTA file - Statistics'),                          #to print the form's header
    start_multipart_form, p,
    "Click the button to choose a FASTA file:",                  #lets you choose the file 
    br, filefield(-name=>'filename'), p,
    reset, submit('submit','Submit File'), hr, endform; 

if (param()) 
{                # this part is executed after user clicks SUBMIT button
     my $filehandle = upload('filename');    
                                                    #column titles followed by their corresponding column types
     my $create_table = "CREATE TABLE DNA_SIMPLE_STATS (            
     ID INT UNSIGNED NOT NULL AUTO_INCREMENT,
     SEQUENCE LONGTEXT NOT NULL,
     NUMBER_OF_SEQUENCES INT UNSIGNED,
     TOTAL_SEQUENCE_LENGTH INT UNSIGNED,
     MAXIMUM_SEQUENCE_LENGTH INT UNSIGNED,
     MINIMUM_SEQUENCE_LENGTH INT UNSIGNED,
     AVERAGE_SEQUENCE_LENGTH INT UNSIGNED,
     HEADER LONGTEXT NOT NULL,
     LENGTH INT UNSIGNED,
     COUNT_OF_A INT UNSIGNED, 
     PROPORTION_OF_A FLOAT UNSIGNED,
     COUNT_OF_G INT UNSIGNED, 
     PROPORTION_OF_G FLOAT UNSIGNED,
     COUNT_OF_C INT UNSIGNED, 
     PROPORTION_OF_C FLOAT UNSIGNED,
     COUNT_OF_T INT UNSIGNED, 
     PROPORTION_OF_T FLOAT UNSIGNED,
	 COUNT_OF_CG INT UNSIGNED,
	 PROPORTION_OF_CG FLOAT UNSIGNED,
     PRIMARY KEY (ID))";
     $dbh->do($create_table);
    

   # variable declarations:
   my @header = ();		    # array of headers
   my @sequence = ();		    # array of sequences
   my $count = 0;	           # number of sequences

   # read FASTA file
   my $n = -1;			    # index of current sequence
   while (my $line = <$filehandle>) 
   {
    chomp $line;		    # remove training \n from line
    if ($line =~ /^>/) 
	   { 	    # line starts with a ">"
	     $n++;			    # this starts a new header
	     $header[$n] = $line;	    # save header line
	     $sequence[$n] = "";	    # start a new (empty) sequence
       }
    else 
	   {
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
   print ("There are $count sequences in the file<br>");       #<br> is used instead of \n, it simply provides a new line

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
	 print ("Total sequence length = $total_length<br>");
	 print ("Maximum sequence length = $max_length<br>");
	 print ("Minimum sequence length = $min_length<br>");
	 
     $avg_length = $total_length / $count;                          # to find the Average sequence length
     print ("Ave sequence length = $avg_length<br>");

     ## For each sequence

     for (my $i = 0; $i < $count; $i++) 
       {
	      my $count_of_A = 0;
          my $count_of_G = 0;
          my $count_of_C = 0;
          my $count_of_T = 0;
	      my $count_of_CpG = 0;
	      $seq_length = length($sequence[$i]);
	  
          print ("$header[$i]<br>");                    # to print the header line
	      print ("Length:", length $sequence[$i],"<br>");   	# to find out the length of each sequence
	      for (my $position = 0; $position < length $sequence[$i]; $position++)
	      {
	         my $base = substr ($sequence[$i], $position, 1);       #to find out the count of each nucleotide in the sequence
		     my $bases = substr ($sequence[$i], $position, 2);    #to find out the count of CpG dinucleotides in the sequence
	         if ($base =~ /a/ig) {$count_of_A++;}
             elsif ($base =~ /g/ig) {$count_of_G++;}
             elsif ($base =~ /c/ig) {$count_of_C++;}
             elsif ($base =~ /t/ig) {$count_of_T++;}
             if ($bases =~ /cg/ig) {$count_of_CpG++;}   ###the variable $bases will consider two values and check if its CpG 
	      }                                           ###if(condition) is yes then counts CpG, 
	                                                 #if(condition) is false goes to the start of for loop 
	  
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
	 
         printf ("A:%4d %1.2f<br>", $count_of_A, $fraction_A);
         printf ("C:%4d %1.2f<br>", $count_of_C, $fraction_C);
         printf ("G:%4d %1.2f<br>", $count_of_G, $fraction_G);
         printf ("T:%4d %1.2f<br>", $count_of_T, $fraction_T);
         printf ("CpG:%4d %1.2f<br>", $count_of_CpG, $fraction_CpG);  
         my $insert = "INSERT INTO DNA_SIMPLE_STATS (SEQUENCE,NUMBER_OF_SEQUENCES,TOTAL_SEQUENCE_LENGTH,MAXIMUM_SEQUENCE_LENGTH,
              MINIMUM_SEQUENCE_LENGTH,AVERAGE_SEQUENCE_LENGTH,HEADER,LENGTH,COUNT_OF_A,PROPORTION_OF_A,COUNT_OF_C,
			  PROPORTION_OF_C,COUNT_OF_G,PROPORTION_OF_G,COUNT_OF_T,PROPORTION_OF_T,COUNT_OF_CG,PROPORTION_OF_CG)
					VALUES ( ?, ?, ? , ? , ? , ? , ? , ? , ? , ? , ? , ? , ? , ? , ? , ? , ? , ?)";

		# Prepare the query (for efficiency), getting a statement handle
		my $sth = $dbh->prepare($insert);   
		#values for all the fields
		$sth->execute($sequence[$i],$count,$total_length,$max_length,$min_length,$avg_length,
			$header[$i],length $sequence[$i],$count_of_A,$fraction_A,$count_of_C,$fraction_C,$count_of_G,$fraction_G,
							  $count_of_T, $fraction_T, $count_of_CpG, $fraction_CpG);	 
	   }        
	   $dbh->disconnect();		 
	print address( a({href=>$url},"Click here to submit another file."));
}
print end_html;
exit;

