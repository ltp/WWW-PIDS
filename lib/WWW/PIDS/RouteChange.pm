package WWW::PIDS::RouteChange;

use strict;
use warnings;

our @ATTR = qw(Action Colour HeadboardRouteNo ID IsMainRoute RouteNo);

{
	no strict 'refs';
	
	*$_ = sub { return shift->{ $_ } } for ( @ATTR );
}

sub new {
	my ( $class, $obj ) = @_;
	my $self = bless {} , $class;

	for my $a ( @ATTR ) {
		defined $obj->{ $a }
			? $self->{ $a } = $obj->{ $a }
			: die "Mandatory parameter $a not supplied to constructor"
	}

	return $self
}

1;

__END__
