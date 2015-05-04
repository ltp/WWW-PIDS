#!/usr/bin/perl

use strict;
use warnings;

use SOAP::Lite;
use Data::Dumper;

my $service = SOAP::Lite->service('http://ws.tramtracker.com.au/pidsservice/pids.asmx?WSDL')
			->proxy('http://www.yarratrams.com.au/pidsservice/');

#$service->endpoint('http://www.yarratrams.com.au/pidsservice/');
my $r = $service->TestGetRouteSummaries;

print Dumper( $r );
