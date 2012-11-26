#!/usr/bin/perl -w

print <DATA>;

print "\n##Please input your primer\n";
my $primer;
while (<STDIN>) {
chomp;
$primer = $_;
	unless ($primer) {
		print "No input, Quit as you wish\n";
	last;
	}
	unless ($primer =~ /a|t|g|c/i){
		print "Warning: Ambiguous nucleotide is not allowed here, only A/T/G/C, retry\n";
	next;
	}
	if ($primer =~ /a|t|g|c/i){
		my $tm = 0 ;
		print "\n##Begin\n";
		print "##Your input: $primer\n";
		print "##length: ". length $primer;
		if (length $primer <= 14){
			$tm = &seq2tm($primer);
		}
		elsif (length $primer > 14) {
			$tm = 41 * &gcpercent($primer) - 672.4 / (length $primer) + 64.9;
		}
		print "nt\n##Tm: ". $tm . "\n";
		print "##END\n";
		print "##Keep inputing, otherwise press <ENTER> to quit\n------\n";
	}

}

sub gcpercent{
	my $seq = $_;
	my $gc = 0;
	my @seq = (split //, $seq);
	$gc = grep /g|c/i,@seq;
	$gc = $gc / (length $seq);
	return $gc;
}
sub seq2tm {
my $seq;
my $tm = 0;
my $letter = undef;
my @seq = (split//, $_[0]);
	foreach $seq (@seq){
	$tm = $tm + &nt2tm($seq);
	}
$tm;
}

sub nt2tm{
my $nt2tm = 
($_[0] =~ /g/i) ? "4":
($_[0] =~ /c/i) ? "4":
($_[0] =~ /a/i) ? "2":
($_[0] =~ /t/i) ? "2":
	"0";
$nt2tm;
}

__DATA__

Goal: Calculate primer's Tm. Two algorithems will be employed: 

1. Length <= 14
   Tm = 4 * (G+C) + 2 * (A+T)
2. Length > 14
	Tm = 41 * (GC contents) - 672.4/Length + 64.9

Note: 
When conducting point-mutation, 
	1) Overall length of primer is suggested to be 25~45 nt. 
	2) Each flanking length is suggested to be larger than 15 nt. 
	3) Each flanking primer' Tm is suggested to be larger than 45. 
	4) Overall GC conent is suggested to be 40%~60%. 
