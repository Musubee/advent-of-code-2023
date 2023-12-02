#!/usr/bin/perl
use strict;
use warnings;

my $sum = 0;
my %maxes = (
    red => 12,
    green => 13,
    blue => 14,
);

while (my $line = <>) {
    my $game_id;
    if ($line =~ /Game (\d+):/) {
        $game_id = $1;
    } else {
        die "Error: Line doesn't have game id";
    }
    # split sets of cubes in each game
    my @sets = split(';', $line);
    my $valid_game = 1;
    for my $set (@sets) {
        for my $color ('red', 'green', 'blue') {
            if (get_num_cubes($color, $set) > $maxes{$color}) {
                $valid_game = 0;
            }
        }
    }
    # add to sum where appropriate
    if ($valid_game) {
        $sum += $game_id;
    }
}

print $sum . "\n";

sub get_num_cubes {
    my ($color, $set) = @_;
    if ($set =~ /(\d+) $color/) {
        return $1;
    } else {
        return 0;
    }
}
