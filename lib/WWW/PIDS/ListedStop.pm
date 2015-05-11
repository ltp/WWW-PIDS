package WWW::PIDS::ListedStop;

use strict;
use warnings;

our @ATTR = qw(Description Longitude Latitude Name SuburbName TID);

our @OATTR= qw(TurnType TurnMessage);

{
	no strict 'refs';

	*$_ = sub { return shift->{ $_ } } for ( @ATTR, @OATTR );
	
}

sub new {
	my ( $class, $obj )	= @_;
	my $self		= bless {} , $class;
use Data::Dumper;
print Dumper( $obj );
	for my $a ( @ATTR ) {
		defined $obj->{ $a }
			? $self->{ $a } = $obj->{ $a }
			: die "Mandatory parameter $a not suppied in constructor" ;
	}

	for my $a ( @OATTR ) {
		if ( defined $obj->{ $a } ) { print "Is: $obj->{ $a }\n" }
		defined $obj->{ $a }
			? $self->{ $a } = $obj->{ $a }
			: $self->{ $a } = '' ;
	}

	return $self
}

1;

__END__

