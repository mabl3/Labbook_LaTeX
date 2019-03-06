#!/usr/bin/perl

use strict;
use warnings;
use File::Copy;
use File::Basename;

# set wd to the directory where the script resides in
# --> the labbook file tree must also begin there, i.e.
#     _addNewDay.pl lies in the same dir as Labbook.tex
my $wd = dirname(__FILE__);
chdir($wd) or die "[ERROR] -- Cannot set working dir to $wd: $!\n";

# get current local time
my @loctime = localtime(time);
my $year = 1900+$loctime[5];
my $mon = 1+$loctime[4];
my $day = $loctime[3];

my @monTxt = qw(January February March April May June July August September October November December);
my $monthText = $monTxt[($mon-1)];

if (length($mon) < 2) { $mon = "0$mon"; }	# 1 --> 01
if (length($day) < 2) { $day = "0$day"; }

print "Adding $year-$mon-$day to labbook\n";

my ($yearDirH, $monDirH, $yearFH, $monFH, $newFH);

# try to open year dir and create it if not yet present
if (not opendir($yearDirH, $year)) {
	mkdir $year or die "Could not create directory '$year': $!\n";
	print "Directory '$year' created.\n";
	
	opendir($yearDirH, $year) or die "Could not open directory '$year': $!\n";
	
	# create new year file
	open($yearFH, ">", "$year/$year.tex") or die "Could not create file '$year/$year.tex': $!\n";
	print {$yearFH} "\\part{$year}\n";
	close($yearFH) or die "Could not close file '$year/$year.tex': $!\n";
	print "File '$year/$year.tex' created.\n";
	
	# insert new \input directive in labbook.tex at the line "%[PERL INPUT TAG]"
	copy("Labbook.tex", "Labbook.tex.bak") or die "Could not make backup of 'Labbook.tex': $!\n";	# security backup
	open(my $bookFH, "<", "Labbook.tex") or die "Cannot open 'Labbook.tex': $!\n";					# read file
	my @bookLines = <$bookFH>;
	my $book = join("", @bookLines);
	$book =~ s/%\[PERL INPUT TAG\]/\\input\{$year\/$year\}\n%\[PERL INPUT TAG\]/g;					# add new input
	close($bookFH) or die "Could not close 'Labbook.tex': $!\n";
	
#	print $book;
	
	open($bookFH, ">", "Labbook.tex") or die "Cannot open 'Labbook.tex': $!\n";						# write file
	print {$bookFH} $book;
	close($bookFH) or die "Cannot close 'Labbook.tex': $!\n";
	print "Labbook.tex updated.\n";
	
}
closedir($yearDirH) or die "Could not close directory '$year': $!\n";

# try to open month dir and create it if not yet present
if (not opendir($monDirH, "$year/$mon")) {
	mkdir "$year/$mon" or die "Could not create directory '$year/$mon': $!\n";
	print "Directory '$year/$mon' created.\n";
	
	opendir($monDirH, "$year/$mon") or die "Could not open directory '$year/$mon': $!\n";
	
	# create new month file
	open($monFH, ">", "$year/$mon/$year$mon.tex") or die "Could not create file '$year/$mon/$year$mon.tex': $!\n";
	print {$monFH} "\\chapter{$monthText}\n";
	close($monFH) or die "Could not close file '$year/$mon/$year$mon.tex': $!\n";
	print "File '$year/$mon/$year$mon.tex' created.\n";
	
	# append month input in year/year.tex
	open(my $monFH, ">>", "$year/$year.tex") or die "Could not open '$year/$year.tex': $!\n";
	print {$monFH} "\\input{$year/$mon/$year$mon}\n";
	close($monFH) or die "Could not close '$year/$year.tex': $!\n";
	print "$year/$year.tex updated.\n";
	
}
closedir($monDirH) or die "Could not close directory '$year/$mon': $!\n";

# create new entry file with date section and label entry
if (open($newFH, "$year/$mon/$year$mon$day.tex")) {
	die "$year/$mon/$year$mon$day.tex already exists.\n";
} else {
	open($newFH, ">", "$year/$mon/$year$mon$day.tex") or die "Could not create file '$year/$mon/$year$mon$day.tex': $!\n";
	print {$newFH} "\\section{$year-$mon-$day} \\label{sec:$year$mon$day}\n";
	close($newFH) or die "Could not close file '$year/$mon/$year$mon$day.tex': $!\n";
	print "File '$year/$mon/$year$mon$day.tex' created.\n";
	
	# append day input in year/month/yearmonth.tex
	open($monFH, ">>", "$year/$mon/$year$mon.tex") or die "Could not open file '$year/$mon/$year$mon.tex': $!\n";
	print {$monFH} "\\input{$year/$mon/$year$mon$day}\n";
	close($monFH) or die "Could not close file '$year/$mon/$year$mon.tex': $!\n";
	print "File '$year/$mon/$year$mon.tex' updated.\n";
	
}
