=pod
Author: Aaron Clevenger
Desc: Simple sleep timer for linux using perl.
=cut

use strict;
use warnings;
use Proc::Simple;

my $hdr = << "EOF"; 
//----------------------------------
//  Sleep Timer
//----------------------------------
EOF

sub main
{
	$| = 1; #Flush the STD input

	print $hdr;
	print "Please enter the command you want to put on a timer: ";
	my $proc = <STDIN>;

	print "Set sleep mode ('T'imer or 'A'larm): ";
	my $input = lc(<STDIN>);
	chomp $input;
	

	if($input eq "a"){
		sleep_alarm($proc);
	}elsif($input eq "t"){
		sleep_timer($proc);	
	}else{
		main();	
	}
}

sub sleep_timer
{
	my $proc = $_[0];
	print "Please enter the amount of time you'd like your program to run (hh:mm): ";
	my $input = <STDIN>;

	my @time = split(/:/, $input);

	my $hrs = $time[0] * 3600;
	my $min = $time[1] * 60;

	my $p = Proc::Simple->new();
	$p->start($proc);
	sleep($hrs + $min);
	$p->kill();
}

sub sleep_alarm
{
	my ($proc) = @_;
	print "Please enter the time you'd like the program to shut off (hh::mm) ";
	my $input = <STDIN>;

	$input = $input;
	my @time = split(/:/, $input);

	my $hrs = $time[0];
	my $min = $time[1];
	chomp($hrs);
	chomp($min);
	my $alarm_time = join(':',$hrs,$min);
	
	my $p = Proc::Simple->new();
	$p->start($proc);

	my $end = 1;
	while($end != 0){
		sleep(1);
		my @time = localtime();
		my $current_time = join(':',$time[2],$time[1]);	
		if($alarm_time eq $current_time){
			$end = 0;
		}
	}
	$p->kill();
	
}

main();
