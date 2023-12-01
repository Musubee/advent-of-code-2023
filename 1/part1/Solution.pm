#!/usr/bin/perl
use strict;
use warnings;
use Benchmark;

my $sum = 0;
my $numbers = '0123456789';

while (my $line = <>) {
    chomp($line);
    my ($first_number_str, $last_number_str);
    for my $char (split('', $line)) {
        if ($char =~ /[$numbers]/) {
            $first_number_str = $char unless defined $first_number_str;
            $last_number_str = $char;
        }
    }
    $sum += "$first_number_str". "$last_number_str";
}

print $sum . "\n";

