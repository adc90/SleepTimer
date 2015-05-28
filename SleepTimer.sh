#!/usr/bin/perl

# Author: Aaron Clevenger
# Desc: Simple sleep timer for linux using perl.

use strict;
use warnings;
use Proc::Simple;

sub main
{
	$| = 1; #Flush the STD input

        if(!defined $ARGV[0]){
            print "./SleepTimer.sh -[a|t] hh:mm <cmd>";
        }else{
            if($ARGV[0] eq "-a") {
                    sleep_alarm($ARGV[1],$ARGV[2]);
            }elsif($ARGV[0] eq "-t"){
                    sleep_timer($ARGV[1],$ARGV[2]);	
            }else{
                    print "See (non-existant 7/2/14) man page";
            }
        }

}

sub sleep_timer
{
	my ($p1, $p2) = @_;
        
	my @time = split(/:/, $p1);
	my $hrs = $time[0] * 3600;
	my $min = $time[1] * 60;

	my $p = Proc::Simple->new();
	$p->start($p2);
	sleep($hrs + $min);
	$p->kill();
}

sub sleep_alarm
{
	my ($p1, $p2) = @_;
	my @time = split(/:/, $p1);
        
	my $alarm_time = join(':',$time[0],$time[1]);

	my $p = Proc::Simple->new();
	$p->start($p2);

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
