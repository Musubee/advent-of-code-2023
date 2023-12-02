#!/usr/bin/perl
use strict;
use warnings;

my $sum = 0;

while (my $line = <>) {
    my $game_id;
    if ($line =~ /Game (\d+):/) {
        $game_id = $1;
    } else {
        die "Error: Line doesn't have game id";
    }
    my %maxes = (
        red => 0,
        green => 0,
        blue => 0,
    );
    my @sets = split(';', $line);
    # split sets of cubes in each game
    for my $set (@sets) {
        for my $color ('red', 'green', 'blue') {
            my $num_cubes = get_num_cubes($color, $set);
            if ($num_cubes > $maxes{$color}) {
                $maxes{$color} = $num_cubes;
            }
        }
    }
    $sum += $maxes{red} * $maxes{green} * $maxes{blue};
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
