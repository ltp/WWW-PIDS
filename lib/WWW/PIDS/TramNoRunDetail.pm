package WWW::PIDS::TramNoRunDetail;

use strict;
use warnings;

our @ATTR = qw(AtLayover Available HasDisruption HasSpecialEvent HeadBoardRouteNo Up VehicleNo RouteNo);

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
