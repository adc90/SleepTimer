use strict;
use warnings;
use Proc::Simple;

sub main
{
	$| = 1; #Flush the STD input
	
my $hdr = << "EOF"; 
//----------------------------------
//  Sleep Timer
//----------------------------------
EOF

	print $hdr;
	print "Please enter the command you want to put on a timer: \n";
	my $proc = <STDIN>;

	my $status = system($proc);

	print $status;

	print "Set sleep mode ('T'imer or 'A'larm): ";
	my $input = lc(<STDIN>);
	chomp $input;
	
	my $p = Proc::Simple->new();
	$p->start("gvim");
	sleep(4);
	$p->kill();

	if($input eq "a")
	{
		sleep_alarm();
	}elsif($input eq "t"){
		sleep_timer();	
	}else{
		return 0; #Should ask again really
	}
}

sub sleep_timer
{
	print "Please enter the amount of time you'd like your program to run (hh:mm): ";
	my $input = <STDIN>;

	my @time = split(/:/, $input);

	my $hrs = $time[0] * 3600;
	my $min = $time[1] * 60;

	my @time = localtime();
	
	sleep($hrs + $min);

	print "End of Sleep Timer";
}

sub sleep_alarm
{
	print "Please enter the time you'd like the program to shut off (hh::mm) ";
	my $input = <STDIN>;

	$input = $input;
	my @time = split(/:/, $input);

	my $hrs = $time[0];
	my $min = $time[1];
	chomp($hrs);
	chomp($min);
	my $alarm_time = join(':',$hrs,$min);

	my $end = 1;
	while($end != 0){
		sleep(1);
		my @time = localtime();
		my $current_time = join(':',$time[2],$time[1]);	
		if($alarm_time eq $current_time){
			$end = 0;
		}
	}
	print "End";
	
}

main();
