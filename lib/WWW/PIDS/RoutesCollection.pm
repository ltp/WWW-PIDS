package WWW::PIDS::RoutesCollection;

use strict;
use warnings;

our @ATTR = qw(AirConditioned Destination DisplayAC HasDisruption HasSpecialEvent HeadboardRouteNo InternalRouteNo 
	IsLowFloorTram IsTTAvailable PredictedArrivalDateTime RequestDateTime RouteNo SpecialEventMessage VehicleNo);

{
	no strict 'refs';

	*$_ = sub { shift->{ $_ } } for ( @ATTR );
}

sub new {
	my ( $class, $obj )	= @_;
	my $self		= bless {}, $class;

	for my $a ( @ATTR ) { 
		$obj->{ $a } or die "Mandatory parameter $a not supplied in constructor";
		$self->{ $a } = $obj->{ $a }
	}	

	return $self
}

1;

__END__

          'diffgram' => {
                        'DocumentElement' => {
                                             'ToReturn' => [
                                                           {
                                                             'InternalRouteNo' => '1',
                                                             'DisplayAC' => 'false',
                                                             'IsLowFloorTram' => 'false',
                                                             'RouteNo' => '1',
                                                             'HasSpecialEvent' => 'true',
                                                             'AirConditioned' => 'true',
                                                             'Destination' => 'East Coburg',
                                                             'HeadboardRouteNo' => '1',
                                                             'RequestDateTime' => '2015-05-07T16:01:48.8541456+10:00',
                                                             'VehicleNo' => '2131',
                                                             'HasDisruption' => 'false',
                                                             'IsTTAvailable' => 'true',
                                                             'SpecialEventMessage' => 'Route 1 & 8 Works 12-17 May: Trams operating in sections. Buses Brunswick Rd - Moreland Rd diverting around work.',
                                                             'PredictedArrivalDateTime' => '2015-05-07T16:11:47+10:00'
                                                           },

