package WWW::PIDS::PredictedTime;

use strict;
use warnings;

use WWW::PIDS::ScheduledTime;

our @ATTR	= qw(TripID PredictionType);
our @OATTR	= qw(Deviation);

{
	no strict 'refs';
	*$_ = sub { shift->{ $_ } } for ( @ATTR, @OATTR );
}

sub new {
	my ( $class, $obj )	= @_;
	my $self		= WWW::PIDS::ScheduledTime->new( $obj ); 
	bless $self, $class;

	for my $a ( @ATTR ) { 
		defined $obj->{ $a }
			? $self->{ $a } = $obj->{ $a }
			: die "Mandatory parameter $a not supplied in constructor" ;
	}

	for ( @OATTR ) {
		$self->{ $_ } = ( defined $obj->{ $_ } ? $obj->{ $_ } : '' )
	}

	return $self
}

1;

__END__


