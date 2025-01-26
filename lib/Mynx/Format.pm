package Mynx::Format;
use v5.32;
use experimental qw(signatures);

use Exporter qw(import);
our @EXPORT = qw(format_html);

our $VERSION = '0.012';

=encoding utf8

=over 4

=cut

sub _html_tree ( $class, $body ) {
	use HTML::TreeBuilder;
	my $tree = HTML::TreeBuilder->new->parse($body);
	$tree->eof;
	$tree;
	}

=item format_html( HTML )

=cut

# I'll have to look at formatting HTML through Mojo::DOM
sub format_html ( $class, $body ) {
	use HTML::FormatText;
	my $tree = $class->_html_tree( $body );

	my $formatter = HTML::FormatText->new(
		leftmargin  =>  5,
		rightmargin => 70,
		);

	$formatter->format( $tree );
	}

=back

=head1 TO DO


=head1 SEE ALSO


=head1 SOURCE AVAILABILITY

This source is in Github:

	http://github.com/perlreview/mynx/

=head1 AUTHOR

brian d foy, <briandfoy@pobox.com>

=head1 COPYRIGHT AND LICENSE

Copyright © 2022, brian d foy <briandfoy@pobox.com>. All rights reserved.

You may redistribute this under the terms of the Artistic License 2.0.

=cut

1;

