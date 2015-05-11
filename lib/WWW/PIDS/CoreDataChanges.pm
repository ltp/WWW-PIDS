package WWW::PIDS::CoreDataChanges;

use strict;
use warnings;

our @ATTR = qw(RouteChanges ServerTime StopChanges);

sub new {
	my ( $class, %obj ) = @_;
	my $self = bless {}, $class;

	for my $a ( @ATTR ) {
		defined $obj{ $a }
			? $self->{ $a } = $obj{ $a }
			: die "Mandatory parameter $a not supplied to constructor"
	}

	return $self	
}

sub RouteChanges	{ return @{ shift->{RouteChanges} }	}

sub StopChanges		{ return @{ shift->{StopChanges} }	}

sub ServerTime		{ return @{ shift->{ServerTime} }	}

1;

__END__
