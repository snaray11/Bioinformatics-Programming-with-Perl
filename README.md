# Bioinformatics-Programming-with-Perl
Assignments that were given for the course - Bioinformatics Programming with Perl.

This contains all the assignments done for the course

The following are the questions for all the assignments.

Programming Assignment 1: cpg.pl

Background
This program will analyze the nucleotide composition of DNA sequences.
We will also include one dinucleotide.  A dinucleotide is a sequence of
two nucleotides in DNA or RNA.  For example, the dinucleotide CpG occurs
in "islands" of 300-30,000 base pairs in and near approximately 40% of
promoters of mammalian genes (and about 70% in human promoters). The "p"
in CpG notation refers to the phosphodiester bond between the cytosine
and the guanine.

CG suppression is a term for the phenomenon that CpG dinucleotides are
very uncommon in most portions of vertebrate genomes. In human and
mouse, CpGs are the least frequent dinucleotide, making up less than 1%
of all dinucleotides, so the CpG islands are actually pretty strong
signals for a nearby gene.

Assignment

Use the file fasta.pl discussed in class as the starting point for a new
perl program called cpg.pl that reports on the nucleotide and CpG
composition of a set of DNA sequences.

INPUT: The program will take one command line argument: the name of a
DNA sequence file in FASTA format.  The command line to run the program
will be:

% cpg.pl sequence_file

OUTPUT: The program should print its output to the terminal.

First, print a report on the entire set of sequences consisting of:
- the number of sequences in the input file
- the total length of all sequences
- the maximum sequence length
- the minimum sequence length
- the average length of the sequences

For each sequence, print:
- the header line
- the length of the sequence
- the count and the fraction of the nucleotides A, C, G, T in the
sequence. Use 2 decimal places for these fractions.
- the count and fraction of the CpG dinucleotide for the sequence.

See test data files on the course web page for sample inputs and
outputs.  Your output should exactly match the sample output formats.
Notice that I used 4 digits for the counts and two decimal places for
all fractions.

The output file on the web page was generated by the command:

% cpg.pl genes.fsa > cpg_out.txt


If the argument list does not contain a filename then the program should
print a message about usage and terminate.

FASTA Format:
- A line beginning with a ">" is the header line for the next sequence
- All other lines contain sequence data.
- There may be any number of sequences per file.
- A sequence may be split over several lines.
- Sequence data may be upper or lower case.  Ignore the case of the
sequence data for this program.
- Sequence data may contain white space, which should be ignored.

Make sure your program includes a header containing:

#!/usr/bin/perl
use warnings;
use strict;
# Name of file
# Your name
# Date

Make sure you:
- Declare all variables
- Provide good comments to explain the program
- Use indentation and blank lines to make it readable

ADMINISTRATIVE:

This assignment is due on Monday, Sept 28, 2015 at 7:00 pm.  No late
programs will be accepted.  Turn in whatever portion of your program is
working by the due date.  Do not turn in programs with compiler errors.
(That is, the program should run, even if it only computes part of the
required output.) 

Submit your perl scripts to Blackboard.
Do NOT submit any input files.  I will examine your program
and may run it on other inputs, so do not hard code the answers.

This is an individual assignment, so the program must be your own work
according to the Honor Code guidelines discussed in the first lecture.
You may any use code from the text books or from the lectures but you
may not include code from other sources or from other people.  If you
use fasta.pl, add comment a comment such as:

# Based in part on fasta.pl by Jeff Solka

If you have any questions be sure to discuss them with me during office
hours or during class.  My advice is to start right away.

Programming Assignment 2

The purpose of this assignment is to functionalize your software from program 1 and to extend its capabilities. You will be testing your new program on the same test cases that we used in program 1. In order to make this assignment a little less daunting let’s break it down into a set of requisite steps.

1 – Write a function, read_fasta, that is passed the name of a FASTA file and will open it and read the headers into an array @header and the sequences into an array @sequence. This function will use references to “send” the @header and @sequence array back to the user’s main program.
2 – Write a function, write_fasta, which given a filename ($filename), @header, and @sequence will write this information out to the file $filename.
3- Write a function, stat_fasta, which given @sequence, @header, $filename will use references to send the arrays @acounts, @ccounts, @gcounts, @tcounts, @cgcounts, @aprops, @cprops, @gprops, @tpropos, @cgprops back to the user. This function will also write out the same report file as in program1 to the file $filename.ot. Notice that you will have to be a little careful in that in 1 the user might give you the file name genes.fsa but in 3 when you write the report you want to write this to genes.ot.
4 -  Write a function, permute_fasta, that given your array of sequences @sequence will return a new sequences array where each entry in the array is a string that is merely a random permutation of the original string. In this case it might be helpful if you actually just wrote a function that acted on a single string at a time but this is not necessary.
5 – The test program program2_lastname.pl should do the following
Read in a filename from the command line.
Call read_fasta (let’s assume the  name is genes.fsa)
Call stat_fasta (this will write genes.ot)
Call permute_fasta
Call write_fasta with a name like this assuming the original name was genes.fsa, genes_permute.fsa.
Call stat_fasta with this new file to write out genes_permute.fsa.
6 – If your program is correctly configured then the a,c,g, and t couts and proportions should be identical. What about the cg counts and proportions?
7 - I expect you to test all of the program 1 test sequences and I will test on those and potentially other ones. 
8 – Think about how you might modify your program to preserve the cg counts/proportions
9 – Think about how you might modify your program so that it actually generated a sequence of a somewhat arbitrary length that had the same proportions (not counts) as the original sequence.

Programming Assignment 3

In this programming assignment we will explore parsing a small set of PubMed records. We will use the file paraneuroplastic_syndrome_result.txt. Here is the first record in the file.


PMID- 19840554
OWN - NLM
STAT- In-Process
DA  - 20091020
IS  - 1097-4199 (Electronic)
VI  - 64
IP  - 1
DP  - 2009 Oct 15
TI  - Innate and adaptive autoimmunity directed to the central nervous system.
PG  - 123-32
AB  - The immune system has two major components, an innate arm and an adaptive arm.
      Certain autoimmune diseases of the brain represent examples of disorders where
      one of these constituents plays a major role. Some rare autoimmune diseases
      involve activation of the innate arm and include chronic infantile neurologic,
      cutaneous, articular (CINCA) syndrome. In contrast, adaptive immunity is
      prominent in multiple sclerosis, neuromyelitis optica, and the paraneoplastic
      syndromes where highly specific T cell responses and antibodies mediate these
      diseases. Studies of autoimmune brain disorders have aided in the elucidation of 
      distinct neuronal roles played by key molecules already well known to
      immunologists (e.g., complement and components of the major histocompatibility
      complex). In parallel, molecules known to neurobiology and sensory physiology,
      including toll-like receptors, gamma amino butyric acid and the lens protein
      alpha B crystallin, have intriguing and distinct functions in the immune system, 
      where they modulate autoimmunity directed to the brain.
AD  - Beckman Center for Molecular Medicine, B002, Stanford University, Stanford, CA
      94305, USA.
FAU - Bhat, Roopa
AU  - Bhat R
FAU - Steinman, Lawrence
AU  - Steinman L
LA  - eng
PT  - Journal Article
PL  - United States
TA  - Neuron
JT  - Neuron
JID - 8809320
SB  - IM
EDAT- 2009/10/21 06:00
MHDA- 2009/10/21 06:00
CRDT- 2009/10/21 06:00
PHST- 2009/09/09 [accepted]
AID - S0896-6273(09)00697-7 [pii]
AID - 10.1016/j.neuron.2009.09.015 [doi]
PST - ppublish
SO  - Neuron. 2009 Oct 15;64(1):123-32.

I want you to write Perl code which will extract the title, TI field, and abstract, AB field from each record in the file. Your program should then compute word counts on each abstract field. Each abstract will have its own set of word counts. Write these word counts out to a file called word_counts.txt. Here are the example word counts for the first abstract.

(CINCA) 1
(e.g., 1
B 1
Certain 1
In 2
Some 1
Studies 1
T 1
The 1
a 1
acid 1
activation 1
adaptive 2
aided 1
alpha 1
already 1
amino 1
an 2
and 8
antibodies 1
arm 2
arm. 1
articular 1
autoimmune 3
autoimmunity 1
brain 2
brain. 1
butyric 1
by 1
cell 1
chronic 1
complement 1
complex). 1
components 1
components, 1
constituents 1
contrast, 1
crystallin, 1
cutaneous, 1
directed 1
diseases 2
diseases. 1
disorders 2
distinct 2
elucidation 1
examples 1
functions 1
gamma 1
has 1
have 2
highly 1
histocompatibility 1
immune 2
immunity 1
immunologists 1
in 3
include 1
including 1
infantile 1
innate 2
intriguing 1
involve 1
is 1
key 1
known 2
lens 1
major 3
mediate 1
modulate 1
molecules 2
multiple 1
neurobiology 1
neurologic, 1
neuromyelitis 1
neuronal 1
of 7
one 1
optica, 1
parallel, 1
paraneoplastic 1
physiology, 1
played 1
plays 1
prominent 1
protein 1
rare 1
receptors, 1
represent 1
responses 1
role. 1
roles 1
sclerosis, 1
sensory 1
specific 1
syndrome. 1
syndromes 1
system 1
system, 1
the 8
these 2
they 1
to 3
toll-like 1
two 1
well 1
where 3

Programming Assignment 4

Currently I don't have the question that was given. 


