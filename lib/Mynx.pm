package Mynx;
use v5.32;
use experimental qw(signatures);

use Carp qw(carp croak);
use Digest::MD5 qw();
use Mojo::DOM;

use Mynx::Format;

our $VERSION = '0.011';

=head1 NAME

Mynx - pre-host HTML preprocessing without exposing the hosts

=head1 SYNOPSIS

	my $different_body = Mynx->preprocess( $url, $body );

=head1 DESCRIPTION

Given a URL and the message body that goes with it, determine if we
have a defined preprocessor for that host. If we do, use it.
Otherwise, return the message body as is.

But here's the rub. We don't want to advertise which hosts we are
preprocessing, so we take the MD5 digest of a normalized hostname and
use that. The host name never shows up in the source code (and, don't
leave comments noting that). To choose your sub name, start with an
C<_> and add the MD5 digest. The string should be the host name
lowercased with non-alphabetics replaced with C<_> (just to make it a
legal Perl identifier).

For example, the host C<www.example.com> becomes C<_5fbeefc2e6443eaa8555ea3a01a08079>.

	% md5 -s www_example_com
	MD5 ("www_example_com") = 5fbeefc2e6443eaa8555ea3a01a08079

Alternately, this module can do it:

	% perl -Ilib -MMynx -E 'Mynx->digest_host(shift)' www.example.com
	_5fbeefc2e6443eaa8555ea3a01a08079

Or, with the L<ynx> convenience module:

	% perl -Ilib -Mynx -E 'say d(shift)' www.example.com
	_5fbeefc2e6443eaa8555ea3a01a08079

Thus, valid preprocessor sub names begin with an underscore, are all
lowercase, use only C<[a-f0-9]>, and are 33 characters long.

=cut

=head2 Methods

=over 4

=item add_preprocessor( DIGESTED_HOST, CODEREF )

Add a pre-processor using DIGESTED_HOST for its name. The CODEREF
should take a single argument, which is the message body as a string:

	my $digested_host = Mynx::Preprocessors->digest_host( $host );
	my $sub = sub ( $body ) { ... };

	Mynx::Preprocessors->add_preprocessor( $host, $sub );

This will not add the coderef as a preprocessor if it is not a coderef.
This emits a warning and returns the empty list.

=cut

sub add_preprocessor ( $class, $host, $sub ) {
	unless( ref $sub eq ref sub {} ) {
		carp "Second argument was not a code ref. Not adding preprocessor for <$host>.";
		return;
		}

	no strict 'refs';
	my $digested_host = $class->digest_host( $host );
	*{"$digested_host"} = $sub;
	}

=item digest_host( HOST )

Given HOST (which could be any string really), return the MD5 digest with
an underscore prepended to it.

=cut

sub digest_host ( $class, $host ) {
	'_' . Digest::MD5::md5_hex( lc($host =~ s/[.-]/_/gr) );
	}

=item digest_url( URL )

Like C<digest_host>, but extracts the host from the URL. This emits a
warning if the URL does not have a host.

=cut

sub digest_url ( $class, $url ) {
	my $host = Mojo::URL->new( $url )->host;
	unless( $host ) {
		carp "URL <$url> has no host";
		return;
		}
	$class->digest_host( $host );
	}

=item format_html_string( STRING [, FORMATTER] )

C<FORMATTER> defaults to L<Mynx::Format>. If you want an alternate
formatter, pass a different package name. That package should have
a C<format_html> method which takes an HTML string as its first
argument.

Use this after you have already preprocessed the string.

=cut

sub format_html_string ( $class, $string, $formatter = 'Mynx::Format' ) {
	croak "Invalid package name <$formatter>"
		unless $formatter =~ / \A [A-Z][A-Z0-9_]* ( :: [A-Z][A-Z0-9_]* )* \z /xia;
	my $file = $formatter =~ s|::|/|gr;

	eval { require "$file.pm" } or croak "Could not load formatter <$formatter>: $@";

	my $method = 'format_html';
	unless( $formatter->can($method) ) {
		croak "Formatting module <$formatter> cannot <$method>";
		}

	$formatter->$method( $string );
	}

=item preprocess( URL, BODY )

Given a URL and the message body for it, determine the right processor
and return the modified text. If there is no preprocessor, this returns
BODY unmodified.

=cut

sub preprocess ( $class, $url, $body ) {
	my $digested_host = $class->digest_url( $url );
	my $coderef = $class->can( $digested_host ) || sub { $body };
	$body = $coderef->($body);
	}

=back

=cut

sub _7650beecf29baef1909862220e427dea ( $body ) {
	my $dom = Mojo::DOM->new($body)->at( 'article' );
	"$dom";
	}

sub _497e9b97fa60cac8d7f283efc990d94f ( $body ) {
	my $dom = Mojo::DOM->new($body)->at( 'div.rad-article' );
	"$dom";
	}

# this is the empty string
sub _d41d8cd98f00b204e9800998ecf8427e ( $body ) {
	carp "Preprocessing text without a URL, so doing nothing to it";
	$body;
	}

1;
