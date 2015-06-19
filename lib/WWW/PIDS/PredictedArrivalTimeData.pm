package WWW::PIDS::PredictedArrivalTimeData;

use strict;
use warnings;

use WWW::PIDS::TramNoRunDetail;
use WWW::PIDS::NextPredictedStopDetail;
use WWW::PIDS::NextPredictedStopsDetailTable;

our @ATTR = qw(NextPredictedStopsDetailsTable TramNoRunDetailsTable);

{
	no strict 'refs';

	for my $m ( @ATTR ) {
		*{ __PACKAGE__."::$m" } = sub {
			my $self = shift;
			return $self->{ $m } }
	}
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

	$self->{ 'NextPredictedStopsDetailsTable' } = WWW::PIDS::NextPredictedStopsDetailTable->new( @stops );

	return $self
}

1;

__END__
