#!/usr/bin/perl
use strict;
use warnings;


my @num_matches;
while (my $line = <>) {
    push(@num_matches, get_num_matches($line));
}

# dp[i] = 1 + sum([dp[j] for j in (i+1..min(i+1+num_matches[i], scalar @num_matches)])
my @dp = (0) x scalar @num_matches;
for (my $i = scalar @num_matches - 1; $i > -1; $i--) {
    my $copies = 0;
    my $end_j = min($i+1+$num_matches[$i], scalar @num_matches) - 1;
    for my $j ($i+1..$end_j) {
        $copies += $dp[$j];
    }
    $dp[$i] = 1 + $copies;
}

my $sum = 0;
for my $num_cards (@dp) {
    $sum += $num_cards;
}
print "$sum\n";

sub get_num_matches {
    my ($line) = @_;

    my $num_matches = 0;
    my $delimiter_i = index($line, "|");
    my $colon_i = index($line, ":");
    my $given_numbers_str = substr($line, $colon_i + 1, $delimiter_i - $colon_i - 1);
    my @given_numbers = get_list_of_nums($given_numbers_str);
    my @winning_numbers = get_list_of_nums(substr($line, $delimiter_i + 1));
    my %winning_numbers_set;
    for my $num (@winning_numbers) {
        $winning_numbers_set{$num} = 1;
    }
    for my $num (@given_numbers) {
        if (exists($winning_numbers_set{$num})) {
            $num_matches++;
        }
    }
    return $num_matches;
}

sub get_list_of_nums {
    my ($nums_str) = @_;
    my @matches = $nums_str =~ /(\d+)/g;
    return @matches;
}

sub min {
    my ($num1, $num2) = @_;
    return $num1 < $num2 ? $num1 : $num2;
}
