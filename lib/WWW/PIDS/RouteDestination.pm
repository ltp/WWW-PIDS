package WWW::PIDS::RouteDestination;

use strict;
use warnings;

sub new {
	my ( $class, %p ) = @_;
	my $self = bless {} , $class;

	for my $param ( qw(UpDestination DownDestination) ) {
		defined $p{ $param }
			? $self->{ $param } = $p{ $param }
			: die "Mandatory parameter $param not provided to constructor in " . __PACKAGE__ ;
	}
	
	return $self
}

sub UpDestination	{ return $_[0]->{ UpDestination }	}

sub DownDestination	{ return $_[0]->{ DownDestination }	}

1;

__END__
