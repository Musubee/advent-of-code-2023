#!/usr/bin/perl
use strict;
use warnings;

my $time_start = time();
my $sum = 0;
my @digits = split('', '0123456789');
my @digit_words = split(' ', 'zero one two three four five six seven eight nine');
my %words_to_digits = map { $digit_words[$_] => $digits[$_] } 0..$#digit_words;

while (my $line = <>) {
    chomp($line);
    print $line . "\n";
    my ($first_number_str, $last_number_str);
    for (my $i = 0; $i < length($line); $i++) {
        for (@digits) {
            if ($_ eq substr($line, $i, 1)) {
                $first_number_str = $_ unless defined $first_number_str;
                $last_number_str = $_;
                last;
            }
        }

        for (@digit_words) {
            if ($_ eq substr($line, $i, length($_))) {
                my $digit = $words_to_digits{$_};
                $first_number_str = $digit unless defined $first_number_str;
                $last_number_str = $digit;
                last;
            }
        }
    }
    print "$first_number_str". "$last_number_str\n";
    $sum += "$first_number_str". "$last_number_str";
}

print $sum . "\n";
my $time_end = time();
my $run_time = $time_end - $time_start;
print "Took: " . $run_time . " seconds\n";

