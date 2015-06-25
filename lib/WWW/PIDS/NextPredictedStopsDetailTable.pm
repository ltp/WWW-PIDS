package WWW::PIDS::NextPredictedStopsDetailTable;

use strict;
use warnings;

sub new {
	my ( $class, @stops ) = @_;
	my $self = bless {}, $class;
	@{ $self->{ stops } } = @stops;

	return $self
}

sub first {
	
	return @{ $_[0]->{ stops } }[0]
}

1;

__END__
