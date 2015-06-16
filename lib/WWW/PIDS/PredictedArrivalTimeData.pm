package WWW::PIDS::PredicatedArrivalTimeData;

use strict;
use warnings;

use WWW::PIDS::TramNoRunDetail;
use WWW::PIDS::NextPredictedStopDetail;

our @ATTR = qw(TramNoRunDetailsTable NextPredictedStopsDetailTable);

{
	no strict 'refs';
	*$_ = sub { return shift->{ $_ } } for @ATTR;
}

sub new {
	my ( $class, $obj ) = @_;
	my $self = bless {}, $class;

	for my $a ( @ATTR ) {
		defined $obj->{ $a} 
			? $self->{ $a } = $obj->{ $a }
			: die "Mandatory parameter $a not supplied in constructor" ;
	}

	return $self
}

1;

__END__
