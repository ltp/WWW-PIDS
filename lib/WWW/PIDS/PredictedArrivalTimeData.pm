package WWW::PIDS::PredictedArrivalTimeData;

use strict;
use warnings;

use WWW::PIDS::TramNoRunDetail;
use WWW::PIDS::NextPredictedStopDetail;

our @ATTR = qw(TramNoRunDetailsTable NextPredictedStopsDetailsTable);

{
	no strict 'refs';
	*$_ = sub { return shift->{ $_ } } for @ATTR;
}

sub new {
	my ( $class, $obj ) = @_;
	my $self = bless {}, $class;

	$self->{ 'TramNoRunDetailsTable' } = 
		defined $obj->{ 'TramNoRunDetailsTable' }
			? $obj->{ 'TramNoRunDetailsTable' }
			: '';

	for my $a ( @ATTR ) {
		defined $obj->{ $a} 
			? $self->{ $a } = $obj->{ $a }
			: die "Mandatory parameter $a not supplied in constructor" ;
	}

	return $self
}

1;

__END__
