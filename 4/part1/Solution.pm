#!/usr/bin/perl
use strict;
use warnings;


my $sum = 0;
while (my $line = <>) {
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
    if ($num_matches > 0) {
        $sum += 2 ** ($num_matches - 1);
    }
}

print "$sum\n";

sub get_list_of_nums {
    my ($nums_str) = @_;
    my @matches = $nums_str =~ /(\d+)/g;
    return @matches;
}
