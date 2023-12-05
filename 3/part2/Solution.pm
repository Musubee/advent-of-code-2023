#!/usr/bin/perl

use strict;
use warnings;

our @schematic = load_data();
our $num_rows = scalar @schematic;
our $num_cols = scalar @{$schematic[0]};

my $sum = 0;
for (my $row = 0; $row < $num_rows; $row++) {
    for (my $col = 0; $col < $num_cols; $col++) {
        if ($schematic[$row][$col] eq '*') {
            my @adj_part_nums = get_adj_part_nums($row, $col);
            if (scalar @adj_part_nums == 2) {
                print "@adj_part_nums\n";
                $sum += $adj_part_nums[0] * $adj_part_nums[1];
            }
        }
    }
}

print $sum . "\n";

sub load_data {
    my @schematic = ();
    while (my $line = <>) {
        chomp($line);
        push(@schematic, [split('', $line)]);
    }
    return @schematic;
}

sub get_adj_part_nums {
    my ($row, $col) = @_;

    my @adj_part_nums = ();
    if ($row > 0) {
        push(@adj_part_nums, horizontal_check($col, $row-1));
    }
    if ($row < $num_rows - 1) {
        push(@adj_part_nums, horizontal_check($col, $row+1));
    }
    if ($col > 0) {
        my $j = $col - 1;
        my @digits_reversed = ();
        while ($j > 0 && $schematic[$row][$j] =~ /(\d)/) {
            push(@digits_reversed, $schematic[$row][$j]);
            $j--;
        }
        if (@digits_reversed) {
            my $digits_reversed_str = join "", @digits_reversed;
            my $digits_str = substr($digits_reversed_str, 0, -1);
            print "digits: " . (join "", reverse @digits_reversed) . "\n";
            push(@adj_part_nums, join "", reverse @digits_reversed);
        }
    }
    if ($col < $num_cols - 1) {
        my $j = $col + 1;
        my @digits = ();
        while ($j < $num_cols && $schematic[$row][$j] =~ /(\d)/) {
            push(@digits, $schematic[$row][$j]);
            $j++;
        }
        if (@digits) {
            push(@adj_part_nums, join "", @digits);
        }
    }

    return @adj_part_nums;
}

# not super efficient but simplest logic imo
sub horizontal_check {
    my ($col, $row_to_check) = @_;
    my @adj_part_nums = ();
    for (my $j = 0; $j < $num_cols; $j++) {
        my ($left, $right);
        my @digits = ();
        while ($j < $num_cols && $schematic[$row_to_check][$j] =~ /(\d)/) {
            $left = $j unless defined $left;
            $right = $j;
            push(@digits, $schematic[$row_to_check][$j]);
            $j++;
        }
        # Check if number this is adjacent to gear
        my $collides_left = defined $left && abs($col - $left) <= 1;
        my $collides_right = defined $right && abs($col - $right) <= 1;
        my $collides_mid =
            (defined $left && defined $right &&
                $col - $left >= 1 && $right - $col >= 1);
        if (@digits && ($collides_left || $collides_right || $collides_mid)) {
            push(@adj_part_nums, join "", @digits);
        }
    }
    return @adj_part_nums;
}

sub abs {
    my $x = @_;
    if ($x < 0) {
        $x = -$x;
    }
    return $x
}

