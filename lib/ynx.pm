package ynx;
use v5.32;
use experimental qw(signatures);

use Mynx;

use Exporter qw(import);

our @EXPORT     = qw( d f );
our @EXPORT_ALL = @EXPORT;

our $VERSION = '0.012';

=encoding utf8

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

=head1 TO DO


=head1 SEE ALSO


=head1 SOURCE AVAILABILITY

This source is in Github:

	http://github.com/perlreview/mynx/

=head1 AUTHOR

brian d foy, <bdfoy@cpan.org>

=head1 COPYRIGHT AND LICENSE

Copyright © 2022, brian d foy <bdfoy@cpan.org>. All rights reserved.

You may redistribute this under the terms of the Artistic License 2.0.

=cut

1;

