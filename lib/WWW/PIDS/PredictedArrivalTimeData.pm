package WWW::PIDS::PredictedArrivalTimeData;

use strict;
use warnings;

use WWW::PIDS::TramNoRunDetail;
use WWW::PIDS::NextPredictedStopDetail;
use WWW::PIDS::NextPredictedStopsDetailTable;

our @ATTR = qw(NextPredictedStopsDetailsTable TramNoRunDetailsTable);

{
	no strict 'refs';
	*$_ = sub { return shift->{ $_ } } for @ATTR;
}

sub new {
	my ( $class, $obj ) = @_;
	my $self = bless {}, $class;

	$self->{ 'TramNoRunDetailsTable' } = 
		( defined $obj->{ 'TramNoRunDetailsTable' }
			? WWW::PIDS::TramNoRunDetail->new( $obj->{ 'TramNoRunDetailsTable' } )
			: undef
		);

	my @stops = map { WWW::PIDS::NextPredictedStopDetail->new( $_ ) } @{ $obj->{ 'NextPredictedStopsDetailsTable' } };
	use Data::Dumper; print Dumper( @stops );

	$self->{ 'NextPredictedStopsDetailsTable' } = WWW::PIDS::NextPredictedStopsDetailTable->new( @stops );

	return $self
}

1;

__END__
