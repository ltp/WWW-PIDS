package WWW::PIDS;

use strict;
use warnings;

use SOAP::Lite;
use Data::Dumper;
use WWW::PIDS::CoreDataChanges;
use WWW::PIDS::Destination;
use WWW::PIDS::ListedStop;
use WWW::PIDS::NextPredictedStopDetail;
use WWW::PIDS::PredictedTime;
use WWW::PIDS::PredictedArrivalTimeData;
use WWW::PIDS::RouteChange;
use WWW::PIDS::RouteDestination;
use WWW::PIDS::RouteNo;
use WWW::PIDS::ScheduledTime;
use WWW::PIDS::StopChange;
use WWW::PIDS::StopInformation;
use WWW::PIDS::TripSchedule;

our $VERSION	= '0.01';
our %ATTR	= (
			ClientGuid		=> undef,
			ClientType		=> 'WEBPID',
			ClientVersion		=> $VERSION,
			ClientWebServiceVersion	=> '6.4.0.0',
		);

our $ENDPOINT	= 'http://ws.tramtracker.com.au/pidsservice/pids.asmx';
our $NS		= 'http://www.yarratrams.com.au/pidsservice/';
our $PROXY	= 'http://ws.tramtracker.com.au/pidsservice/pids.asmx';

our %METHODS = (
	GetDestinationsForAllRoutes => {
		result		=> sub { return map { WWW::PIDS::Destination->new( $_ ) } 
						@{ shift->{diffgram}->{DocumentElement}->{ListOfDestinationsForAllRoutes} } 
					}
	},
	GetDestinationsForRoute => {
		parameters	=> [ { param => 'routeNo',	format => qr/^\d{1,3}$/,	type => 'string' } ],
		result		=> sub { return WWW::PIDS::RouteDestination->new( 
						%{ shift->{diffgram}->{DocumentElement}->{RouteDestinations} } 
					 ) 
					}
	},
	GetListOfStopsByRouteNoAndDirection => {
		parameters	=> [ { param => 'routeNo',	format => qr/^\d{1,3}\w{0,2}$/,	type => 'string' }, 
				     { param => 'isUpDirection',format => qr/^(0|1)$/,		type => 'boolean' } ],
		result		=> sub { return map { WWW::PIDS::ListedStop->new( $_ ) } 
						@{ shift->{diffgram}->{DocumentElement}->{S} } 
					}
	},
	GetMainRoutes => {
		result		=> sub { return map { WWW::PIDS::RouteNo->new( $_ ) } 
						@{ shift->{diffgram}->{DocumentElement}->{ListOfNonSubRoutes} } 
					}
	},
	GetMainRoutesForStop => {
		parameters	=> [ { param => 'stopNo',	format => qr/^\d{4}$/,		type => 'short' } ],
		result		=> sub { return map { WWW::PIDS::RouteNo->new( $_ ) } 
						@{ shift->{diffgram}->{DocumentElement}->{ListOfMainRoutesAtStop} } 
					}
	},
	GetNextPredictedArrivalTimeAtStopsForTramNo => {
		parameters	=> [ { param => 'tramNo',	format => qr/^\d{1,4}$/,	type => 'short' } ],
		result		=> sub {	my $n = shift;
						return unless defined $n;
						return ( defined $n->{diffgram}->{NewDataSet}
							? WWW::PIDS::PredictedArrivalTimeData->new( $n->{diffgram}->{NewDataSet} )
							: undef
						)
					}
	},
	GetNextPredictedRoutesCollection => {
		parameters	=> [ { param => 'stopNo',	format => qr/^\d{4}$/,		type => 'short' },
				     { param => 'routeNo',	format => qr/^\d{1,3}[a-z]?$/,	type => 'string' },
				     { param => 'lowFloor',	format => qr/^(0|1)$/,		type => 'boolean' } ],
		result		=> sub { return map { WWW::PIDS::ScheduledTime->new( $_ ) } 
						@{ shift->{diffgram}->{DocumentElement}->{ToReturn} } 
					}
	},
	GetNewClientGuid  => {
		result		=> sub { return shift }
	},	
	'GetPlatformStopsByRouteAndDirection' => {
		parameters	=> [ { param => 'routeNo',	format => qr/^\d{1,3}[a-z]?$/,	type => 'string' },
				     { param => 'isUpDirection',format => qr/^(0|1)$/,		type => 'boolean' } ],
		result		=> sub { return @_ }
		#result		=> sub { return map { WWW::PIDS::RoutesCollection->new( $_ ) } @{ shift->{diffgram}->{DocumentElement}->{ToReturn} } }
	},
	GetRouteStopsByRoute => {
		parameters	=> [ { param => 'routeNo',	format => qr/^\d{1,3}[a-z]?$/,	type => 'string' },
				     { param => 'isUpDirection',format => qr/^(0|1)$/,		type => 'boolean' } ],
		result		=> sub { my $s = shift; print Dumper( $s ) }
	},
	GetRouteSummaries => {
		result		=> sub { return @_ }
	},
	GetSchedulesCollection  => {
		parameters	=> [ { param => 'stopNo',	format => qr/^\d{4}$/,		type => 'short' },
				     { param => 'routeNo',	format => qr/^\d{1,3}[a-z]?$/,	type => 'string' },
				     { param => 'lowFloor',	format => qr/^(0|1)$/,		type => 'boolean' },
				     { param => 'clientRequestDateTime', format => qr/\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}$/, type => 'dateTime' } ],
		result		=> sub { return map { WWW::PIDS::PredictedTime->new( $_ ) } 
						@{ shift->{diffgram}->{DocumentElement}->{SchedulesResultsTable} } 
					}
	},
	GetSchedulesForTrip  => {
		parameters	=> [ { param => 'tripID',	format => qr/^\d{1,}$/,		type => 'int' },
				     { param => 'scheduledDateTime', format => qr/\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}$/, type => 'dateTime' } ],
		result		=> sub { return map { WWW::PIDS::TripSchedule->new( $_ ) }
						@{ shift->{diffgram}->{DocumentElement}->{Table} }
					}
	},
	GetStopInformation  => {
		parameters	=> [ { param => 'stopNo',	format => qr/^\d{4}$/,		type => 'short' } ],
		result		=> sub { return WWW::PIDS::StopInformation->new( shift->{diffgram}->{DocumentElement}->{StopInformation} ) }
	},
	GetStopsAndRoutesUpdatesSince  => {
		parameters	=> [ { param => 'dateSince', format => qr/\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}$/, type => 'dateTime' } ],
		result		=> sub { my $d = shift; 
					my @r = map { WWW::PIDS::RouteChange->new( $_ ) } 
						@{ $d->{diffgram}->{dsCoreDataChanges}->{dtRoutesChanges} }; 
					my @s = map { WWW::PIDS::StopChange->new( $_ ) } 
						@{ $d->{diffgram}->{dsCoreDataChanges}->{dtStopsChanges} };
					my $t = $d->{diffgram}->{dsCoreDataChanges}->{dtServerTime}->{ServerTime};
					return WWW::PIDS::CoreDataChanges->new( ServerTime => $t, RouteChanges => \@r, StopChanges => \@s ) 
					}
	}
);

for my $method ( keys %METHODS ) {
	{
	no strict 'refs';

	*$method = sub {
		my ( $self, %parameters ) = @_;

		my $valid	= __validate_parameters( $method, %parameters );
		die $valid unless ( $valid eq "1" );

		my @body	= __construct_body( $method, %parameters );

		my $r = SOAP::Lite->endpoint( $ENDPOINT )
				  ->default_ns( $NS )
				  ->proxy( $PROXY )
				  ->on_action( sub { "$NS$method" } )
				  ->$method( @body, $self->{pids_header} )
				  ->result;

		return $METHODS{ $method }{ 'result' }->($r);
	};

	}
}

sub __validate_parameters {
	my ( $m, %p ) = @_;

	return 1 if not defined $METHODS{ $m }{ 'parameters' };

	for my $param ( @{ $METHODS{ $m }{ 'parameters' } } ) {
		defined $p{ $param->{ param } } 
			or return "Mandatory parameter $param->{ param } missing";

		( $p{ $param->{ param } } =~ $param->{ format } )
			or return "Value of parameter $param->{ param } does not conform to expected format";
	}

	return 1
}

sub __construct_body {
	my ( $m, %p ) = @_;
	my @b;

	for my $param ( @{ $METHODS{ $m }{ 'parameters' } } ) {
		push @b, SOAP::Data->name( $param->{ param } => $p{ $param->{ param } } )
				   ->type( $param->{ type } )
	}

	return @b
}

sub new {
	my ( $class, %args ) = @_;
	my $self = bless {}, $class;

	for my $a ( keys %ATTR ) {
		defined $args{ $a }
			? $self->{ $a } = $args{ $a }
			: $self->{ $a } = $ATTR{ $a } ;
	}

	defined $self->{ 'ClientGuid' } or $self->{ 'ClientGuid' } = $self->GetNewClientGuid();
	$ATTR{ 'ClientGuid' } = $self->{ 'ClientGuid' };

	$self->{pids_header} = SOAP::Header->name( 'PidsClientHeader' )
					   ->attr( { 'xmlns' => $NS } )
					   ->value( \SOAP::Header->value( 
							SOAP::Header->name( 'ClientGuid'		=> $ATTR{ 'ClientGuid' } ),
							SOAP::Header->name( 'ClientType'		=> $ATTR{ 'ClientType' } ),
							SOAP::Header->name( 'ClientVersion'		=> $ATTR{ 'ClientVersion' } ),
							SOAP::Header->name( 'ClientWebServiceVersion'	=> $ATTR{ 'ClientWebServiceVersion' } )
						) );
	
	return $self
}

1;

__END__

=head1 NAME

WWW::PIDS - Perl API for the tramTRACKER PIDS Web Service

=head1 SYNOPSIS

WWW::PIDS is a Perl API to the PIDS tramTRACKER web service.

The tramTRACKER PIDS web service "is a public Web Service that provides a set 
of Web Methods to request real-time and scheduled tram arrival times, as well 
as stops and routes information."

You can find more infomration on the tramTRACKER PIDS web service here
L<http://ws.tramtracker.com.au/pidsservice/pids.asmx>.

This Perl API aims to implement a one-to-one binding with the methods provided
by the web service.  Accordingly, the method names within this package are
named after the corresponding names of the methods exposed via the web service.
Unfortunately, this results in some exceedingly long camel-cased method names -
those wanting more aesthetically named methods and slightly more usable syntax
may prefer the WWW::PIDS::Sugar package.

    use WWW::PIDS;

    my $p = WWW::PIDS->new();

    ...

=head1 METHODS

=head2 new ( %ARGS )

Constructor - creates a new WWW::PIDS object.

This method accepts four optional parameters, if any parameter is ommitted a
default value will be used.  The parameters and their defaults are:

=over 4

=item * ClientGuid

The client GUID that must be passed to the tramTRACKER PIDS web service.  If
you do not pass this parameter, then on instatiation of a new WWW::PIDS object
an implicit call will be made to the L<GetNewClientGuid()> method requesting a new
GUID.

=item * ClientType

A string identifying the client application type.  If you require a dedicated
client type, contact feedback@yarratrams.com.au.

The default value for this parameter is 'WEBPID'.

=item * ClientVersion

The version of the client application.  The version must match the regex:

	^(\d{1,3}\.)(\d{1,3}\.)(\d{1,3}\.)(\d{1,5})$

The default value for this parameter is the module version.

=item * ClientWebServiceVersion

The current Web Service version that the client application is connecting to. 
The version format has to match the following expression:

	^(\d{1,3}\.)(\d{1,3}\.)(\d{1,3}\.)(\d{1,5})$

The default value for this parameter is the current web service version (6.4.0.0).

=back

=head2 GetNewClientGuid ()

Returns a new client GUID for use with the tramTRACKER PIDS web service.  

=head2 GetDestinationsForAllRoutes ()

Returns a list of destinations for all routes in the network.

The return type is an array of L<WWW::PIDS::Destination> objects.

=head2 GetDestinationsForRoute ( routeNo => SCALAR )

Accepts a single mandatory parameter; the route number - and 
returns a L<WWW::PIDS::RouteDestination> object containing route
destination information for the specified route.

=head2 GetListOfStopsByRouteNoAndDirection ( routeNo => SCALAR, isUpDirection => BOOLEAN )

Accepts two mandatory parameters; the route number, and an boolean value
(either 0 or 1) indicating if the direction of travel is in the "up" direction
according to the service specification.

Returns an array of L<WWW::PIDS::ListedStop> objects representing an in-order
list of the stops on the route in the direction of travel.

Please see the L<NOTES> section regarding the terminology, convention, and
specifities of this module including naming of parameters.

=head2 GetMainRoutes ()

Returns an array of L<WWW::PIDS::RouteNo> objects containing information on
all main routes.

=head2 GetMainRoutesForStop ( stopNo => SCALAR )

Accepts a single mandatory parameter; the stop number for which you wish to
retrieve a list of main routes, and returns an array of L<WWW::PIDS::RouteNo>
obejcts representing the main routes for the specified stop.

=head2 GetNextPredictedArrivalTimeAtStopsForTramNo ( tramNo => $tramNo )

Accepts a single mandatory parameter; the tram number for which you wish to
retrieve the predicted stop arrival time, and returns a 
L<WWW::PIDS::PredictedArrivalTimeData> object.

=head2 GetNextPredictedRoutesCollection ( stopNo => $stopNo, routeNo => $routeNo, lowFloor => $lowFloor )

Returns real-time predicted arrival times for the specified stop number, route 
number, and low floor requirement.

This method accepts three mandatory parameters;

=over 4

=item * stopNo

The stop number for which you would like to retrieve predicted arrival times.

=item * routeNo

The route number for which you would like to retrieve predicted arrival times.

=item * lowFloor

A boolean value (either 1 or 0) which if set to true will return data for
low floor services only.

=back

This method returns an array of L<WWW::PIDS::ScheduledTime> objects.

=head2 GetPlatformStopsByRouteAndDirection ( routeNo => $routeNo, isUpDirection => BOOLEAN )

Accepts two mandatory parameters; the route number and a boolean indicating the
direction of the service.

This method, although present in the PIDS web service documentation, does not appear to
be implemented and hence results in a server-side error when invoked.

It is included in this module for consistency and parity.

=head2 GetRouteSummaries ()

Returns a list of summaries for all main routes in the network.

At the time of authoring, the PIDS web service currently returns an empty response for this 
method, hence this method, whilst being implemented internally, also returns nothing.

It is included in this module for consistency and parity.

=head2 GetSchedulesCollection ( stopNo => $stopNo, routeNo => $routeNo, lowFloor => BOOLEAN, clientRequestDateTime => TIMESTAMP )

This method accepts four mandatory parameters and returns an array of three 
L<WWW::PIDS::PredictedTime> objects representing the next three scheduled passing times 
for services with the specified stop number, route number, low floor requirement, day, and time.

The four mandatory parameters are:

=over 4

=item * stopNo

The stop number for which you would like to retrieve scheduled arrival times.

=item * routeNo

The route number for which you would like to retrieve scheduled arrival times.

=item * lowFloor

A boolean value (either 1 or 0) which if set to true will return data for
low floor services only.

=item * clientRequestDateTime

The date and time representing the start of the period for which you would like to
retrieve scheduled arrival times in the format:

	YYYY-MM-DDThh:mm:ss

	# Example
	2015-05-08T16:20:00

=back

=head2 GetSchedulesForTrip ( tripID => $tripID, scheduledDateTime => TIMESTAMP )

This method accepts two mandatory parameters and returns an array of
L<WWW::PIDS::TripSchedule> objects representing the scheduled arrival times pertaining to a route
for the specified trip ID and scheduled departure date and time. 

To determine the trip ID, use the L<GetSchedulesCollection()> method.

The two mandatory parameters are:

=item * tripID

The trip ID identifying the route for which scheduled arrival times are to be retrieved.

=item * scheduledDateTime

The date and time representing the start of the period for which you would like to
retrieve scheduled arrival times in the format:

	YYYY-MM-DDThh:mm:ss

	# Example
	2015-05-08T16:20:00

=back

=head2 GetStopInformation ( stopNo => $stopNo )

Returns a L<WWW::PIDS::StopInformation> object containing information on the specified
stop ID.  The L<WWW::PIDS::StopInformation> object contains information including the flag 
stop number, latitude and logitude coordinates, and the suburb name.

This method accepts a single mandatory parameter:

=item stopNo

The 4-digit tracker ID of the stop for which infomration is to be retrieved.

=back

=head2 GetStopsAndRoutesUpdatesSince( dateSince => TIMESTAMP )

Returns a L<WWW::PIDS::CoreDataChanges> object containing a list of routes and 
tracker IDs whose information have been updated since the date specified in 
the parameter (dateSince). To obtain detailed information of the updates, use 
the L<GetStopInformation()>, L<GetListOfStopsByRouteNoAndDirection()>, and 
L<GetDestinationsForRoute()> methods.

=item * dateSince

The date and time representing the start of the period for which you would like to
retrieve scheduled arrival times in the format:

	YYYY-MM-DDThh:mm:ss

	# Example
	2015-05-08T16:20:00


=head1 NOTES

Many of the methods, parameters, attributes, stylistic and design choices in this module 
may appear to be (at first glance) nonsensical, unintuitive, and ill-informed.

However, the key philosophy in implementing this module has been to maintain strict adherence
to the conventions and naming used in the official tramTRACKER PIDS web service, and as such,
where at all possible, the naming conventions used there have been maintained herein.

This has been done intentionally to try to maintain consistency between the web service
and this module so as to try and reduce any potential source of confusion for users when
attempting to mentally map the methods of one to the other, and also to try and provide a very
close mapping of the official API to this binding.

Likewise, the extensive use of objects as a return type for even very simple methods has been
done for the purposes of consistency and with the philosophy that an object provides some
level of mapping to the official SOAP response type.

If you would prefer more aesthetically named methods and slightly more usable syntax,
then please consider the L<WWW::PIDS::Sugar> package.

=head1 AUTHOR

Luke Poskitt, C<< <ltp at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-www-pids at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=WWW-PIDS>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc WWW::PIDS

You can also look for information at:

=over 4

=item * tramTRACKER PIDS Web Service 

L<http://ws.tramtracker.com.au/pidsservice/pids.asmx>

=item * RT: CPAN's request tracker (report bugs here)

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=WWW-PIDS>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/WWW-PIDS>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/WWW-PIDS>

=item * Search CPAN

L<http://search.cpan.org/dist/WWW-PIDS/>

=back


=head1 SEE ALSO

L<WWW::PIDS::CoreDataChanges>
L<WWW::PIDS::Destination>
L<WWW::PIDS::ListedStop>
L<WWW::PIDS::NextPredictedStopDetail>
L<WWW::PIDS::PredictedTime>
L<WWW::PIDS::PredictedArrivalTimeData>
L<WWW::PIDS::RouteChange>
L<WWW::PIDS::RouteDestination>
L<WWW::PIDS::RouteNo>
L<WWW::PIDS::ScheduledTime>
L<WWW::PIDS::StopChange>
L<WWW::PIDS::StopInformation>
L<WWW::PIDS::TripSchedule>

=head1 LICENSE AND COPYRIGHT

Copyright 2015 Luke Poskitt.

This program is free software; you can redistribute it and/or modify it
under the terms of the the Artistic License (2.0). You may obtain a
copy of the full license at:

L<http://www.perlfoundation.org/artistic_license_2_0>

Any use, modification, and distribution of the Standard or Modified
Versions is governed by this Artistic License. By using, modifying or
distributing the Package, you accept this license. Do not use, modify,
or distribute the Package, if you do not accept this license.

If your Modified Version has been derived from a Modified Version made
by someone other than you, you are nevertheless required to ensure that
your Modified Version complies with the requirements of this license.

This license does not grant you the right to use any trademark, service
mark, tradename, or logo of the Copyright Holder.

This license includes the non-exclusive, worldwide, free-of-charge
patent license to make, have made, use, offer to sell, sell, import and
otherwise transfer the Package with respect to any patent claims
licensable by the Copyright Holder that are necessarily infringed by the
Package. If you institute patent litigation (including a cross-claim or
counterclaim) against any party alleging that the Package constitutes
direct or contributory patent infringement, then this Artistic License
to you shall terminate on the date that such litigation is filed.

Disclaimer of Warranty: THE PACKAGE IS PROVIDED BY THE COPYRIGHT HOLDER
AND CONTRIBUTORS "AS IS' AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES.
THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
PURPOSE, OR NON-INFRINGEMENT ARE DISCLAIMED TO THE EXTENT PERMITTED BY
YOUR LOCAL LAW. UNLESS REQUIRED BY LAW, NO COPYRIGHT HOLDER OR
CONTRIBUTOR WILL BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, OR
CONSEQUENTIAL DAMAGES ARISING IN ANY WAY OUT OF THE USE OF THE PACKAGE,
EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


=cut
