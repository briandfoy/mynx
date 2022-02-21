package ynx;
use v5.34;
use experimental qw(signatures);

use Mynx;

use Exporter qw(import);

our @EXPORT     = qw( d );
our @EXPORT_ALL = @EXPORT;

our $VERSION = '0.011';

=over 4

=item d(HOST)

Digest HOST, which is one step in defining a preprocessor
subroutine.

=cut

sub d ( $host ) { Mynx->digest_host( $host ) }

=item f(URL)

Fetch URL and format it.

=cut

sub f ( $url ) {
	my sub fetch ( $url ) {
		state $rc = require Mojo::UserAgent;
		my $ua = Mojo::UserAgent->new;
		$ua->max_connections(0);

		$url = Mojo::URL->new( $url );
		( $url, $ua->get( $url )->res->body );
		}

	say Mynx->format_html_string(
		Mynx->preprocess( fetch($url) )
		);



	}

=back

=cut

1;
