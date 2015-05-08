package WWW::PIDS::Destination;

use strict;
use warnings;

our @ATTR = qw(Destination UpStop RouteNo);

{
	no strict 'refs';

	for my $a ( @ATTR ) {
		*$a = sub { return shift->{ $a } }
	}

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
