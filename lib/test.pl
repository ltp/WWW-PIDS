#!/usr/bin/perl

use strict;
use warnings;

use WWW::PIDS;
use Data::Dumper;

my $p = WWW::PIDS->new;

my @r = $p->GetDestinationsForAllRoutes();

print Dumper( @r );

@r = $p->GetDestinationForRoute( { routeNo => 19 } );

print Dumper( @r );
