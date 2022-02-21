use Test::More tests => 1;

my $file = 'blib/script/mynx';

BAIL_OUT( "Script file <$file> is missing!" ) unless -e $file;

my $output = `$^X -c $file 2>&1`;

like( $output, qr/syntax OK$/, 'script compiles' );
