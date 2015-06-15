package WWW::PIDS::Sugar;

use strict;
use warnings;

use WWW::PIDS;

sub new {
	my ( $class, $obj )	= @_;
	my $self		= bless {}, $self;
	my $self->{__p}		= WWW::PIDS->new();

	return $self
}

# $p->

1;

__END__
