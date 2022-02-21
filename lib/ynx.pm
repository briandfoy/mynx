package ynx;
use v5.34;
use experimental qw(signatures);

use Mynx;

use Exporter qw(import);

our @EXPORT     = qw( d );
our @EXPORT_ALL = @EXPORT;

our $VERSION = '0.011';
sub d ( $host ) { Mynx->digest_host( $host ) }

sub f ( $url ) {
	Mynx->digest_host( $host )

	}

1;
