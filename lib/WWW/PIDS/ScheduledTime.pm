package WWW::PIDS::ScheduledTime;

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
		defined $obj->{ $a } 
			? $self->{ $a } = $obj->{ $a }
			: die "Mandatory parameter $a not supplied in constructor" ;
	}	

	return $self
}

1;

__END__


