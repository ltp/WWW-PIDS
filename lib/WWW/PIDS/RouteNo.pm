package WWW::PIDS::RouteNo;

use strict;
use warnings;

use overload ( '""' => \&__as_string );

sub new {
	my ( $class, $p )	= @_;
	my $self		= bless {}, $class;

	defined $p->{ 'RouteNo' }
		? $self->{ 'RouteNo' } = $p->{ 'RouteNo' }
		: die "Mandatory parameter RouteNo not provided in constructor" ;

	return $self
}

sub __as_string { return "$_[0]->{RouteNo}" }

1;

__END__
