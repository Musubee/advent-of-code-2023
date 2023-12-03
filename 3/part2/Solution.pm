#!/usr/bin/perl

# TODO: refactor this at some point
# TODO: figure out why load_data loads in an extra row and column
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
            if (length(@adj_part_nums) == 2) {
                $sum += @adj_part_nums[0] * @adj_part_nums[1];
            }
        }
        my ($left, $right);
        my @digits = ();
        while ($col < $num_cols && $schematic[$row][$col] =~ /(\d)/) {
            $left = $col unless defined $left;
            $right = $col;
            push(@digits, $schematic[$row][$col]);
            $col++;
        }
        if (@digits && ! is_part_number($row, $left, $right)) {
            # print "@digits\n";
            # $sum += join "", @digits;
        }
        if (@digits && is_part_number($row, $left, $right)) {
            # print "@digits\n";
            $sum += join "", @digits;
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


}

sub is_part_number {
    my ($row, $left, $right) = @_;
    # check above and below
    my $left_bound = $left > 0 ? $left - 1 : $left;
    my $right_bound = $right < $num_cols - 1 ? $right + 1 : $right;
    if ($row > 0) {
        my $above_row = join "", @{$schematic[$row-1]}[$left_bound..$right_bound];
        if ($above_row =~ /[^\d.]/) {
            # print "above:$above_row";
            return 1;
        }
    }
    if ($row < $num_rows - 1) {
        my $below_row = join "", @{$schematic[$row+1]}[$left_bound..$right_bound];
        if ($below_row =~ /[^\d.]/) {
            # print "below:$below_row";
            return 1;
        }
    }
    # check left and right
    if ($left > 0 && $schematic[$row][$left-1] =~ /[^\d.]/) {
        # print "left:$schematic[$row][$left-1]";
        return 1;
    }
    if ($right < $num_cols - 1 && $schematic[$row][$right+1] =~ /[^\d.]/) {
        # print "right:$schematic[$row][$right+1]";
        return 1;
    }
    return 0;
}
