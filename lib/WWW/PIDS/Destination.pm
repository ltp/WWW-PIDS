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
		$obj->{ $a } or die "Mandatory parameter $a not supplied in constructor";
		$self->{ $a } = $obj->{ $a }
	}

	return $self
}

1;
