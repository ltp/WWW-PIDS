#!/usr/bin/perl

use strict;
use warnings;

use Data::Dumper;
use tramTRACKER_x0020_PIDS_x0020_Web_x0020_Service;

my $t = tramTRACKER_x0020_PIDS_x0020_Web_x0020_Service->new();

my $foo = $t->GetMainRoutes;
#my $foo = $t->TestGetDestinationsForAllRoutes;

print Dumper( $foo );
