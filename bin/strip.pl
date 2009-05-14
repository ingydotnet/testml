#!/usr/bin/perl

use strict;

my $flag = 0;

while (my $line = <>) {
    if ($flag) {
        if ($line =~ /body>/) {
            print "[% END %]\n";
            last;
        }
        print $line;
    }
    else {
        if ($line =~ /<body/) {
            print "[% WRAPPER html.tt2 %]\n";
            $flag = 1;
        }
    }
}
