#!/usr/bin/perl

use strict;
use warnings;

use WWW::PIDS;
use Data::Dumper;

my $p = WWW::PIDS->new;

#my @r = $p->GetDestinationsForAllRoutes();

#print Dumper( @r );

#my @r = $p->GetDestinationsForAllRoutes();
#my @r = $p->GetDestinationsForRoute( routeNo => 64 );
#my @r = $p->GetMainRoutes( );
my @r = $p->GetMainRoutesForStop( stopNo => 3101 );
#my @r = $p->GetRouteStopsByRoute( routeNo => 109, isUpDirection => 1);
#my @r = $p->GetListOfStopsByRouteNoAndDirection( routeNo => 3, isUpDirection => 0);
#my @r = $p->GetNextPredictedArrivalTimeAtStopsForTramNo( tramNo => 64 );
#my @r = $p->GetNextPredictedRoutesCollection( stopNo => 3101, routeNo => '3a', lowFloor => 0 );
#my @r = $p->GetPlatformStopsByRouteAndDirection( routeNo => '3', isUpDirection => 0 );
#my @r = $p->GetRouteSummaries();
#my @r = $p->GetSchedulesCollection( stopNo => 3101, routeNo => '3a', lowFloor => 0, clientRequestDateTime => '2015-05-08T09:15:00' );
#my @r = $p->GetSchedulesForTrip( tripID => 44652446, scheduledDateTime => '2015-05-08T09:15:00' );
print Dumper( @r );
exit;
my $r = $p->GetStopsAndRoutesUpdatesSince( dateSince => '2014-05-11T08:45:00' );
print Dumper( $r );
#map { print Dumper( $_ ) } $r->RouteChanges;
#print Dumper( $r );
#map { print $_ }  @r ;
