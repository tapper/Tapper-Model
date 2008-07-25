#!perl -T

use Test::More tests => 1;

BEGIN {
	use_ok( 'Artemis::Model' );
}

diag( "Testing Artemis::Model $Artemis::Model::VERSION, Perl $], $^X" );
