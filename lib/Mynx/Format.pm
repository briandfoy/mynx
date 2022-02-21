package Mynx::Format;
use v5.34;
use experimental qw(signatures);

use Exporter qw(import);
our @EXPORT = qw(html_format);

sub _html_tree ( $class, $body ) {
	use HTML::TreeBuilder;
	my $tree = HTML::TreeBuilder->new->parse($body);
	$tree->eof;
	$tree;
	}

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

1;
