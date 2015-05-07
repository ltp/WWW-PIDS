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


