#!/usr/bin/perl

use strict;
use warnings;

use WWW::PIDS;
use Data::Dumper;

my $p = WWW::PIDS->new;

#my @r = $p->GetDestinationsForAllRoutes();

#print Dumper( @r );

#my @r = $p->GetDestinationsForAllRoutes();
my @r = $p->GetDestinationsForRoute({ routeNo => 19 });

print Dumper( @r );
