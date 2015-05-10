package WWW::PIDS::Stop;

use strict;
use warnings;

our @ATTR = qw(Name Longitude Latitude TID SuburbName Description);

our @OATTR = qw(CityDirection FlagStopNo HasConnectingBuses HasConnectingTrains HasConnectingTrams IsPlatformStop StopLength StopName Zones);

{
	no strict 'refs';

	*$_ = sub { return shift->{ $_ } } for ( @ATTR, @OATTR );
	
}

sub new {
	my ( $class, $obj )	= @_;
	my $self		= bless {} , $class;

	for my $a ( @ATTR ) {
		defined $obj->{ $a }
			? $self->{ $a } = $obj->{ $a }
			: die "Mandatory parameter $a not suppied in constructor" ;
	}

	for my $a ( @OATTR ) {
		$self->{ $_ } = ( defined $obj->{ $_ } ? $obj->{ $_ } : '' )
	}

	return $self
}

1;

__END__

$VAR1 = {
          'diffgram' => {
                        'DocumentElement' => {
                                             'S' => [
                                                    {
                                                      'Name' => '64 East Malvern',
                                                      'Longitude' => '145.059038828029',
                                                      'Latitude' => '-37.8773154546904',
                                                      'TID' => '1096',
                                                      'SuburbName' => 'Malvern East',
                                                      'Description' => 'East Malvern'
                                                    },
