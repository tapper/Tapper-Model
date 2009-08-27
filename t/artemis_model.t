#! /usr/bin/env perl

use lib '.';

use strict;
use warnings;

use Test::More;
use Artemis::Model qw(model get_hardwaredb_overview);
use Artemis::Schema::TestTools;
use Test::Fixture::DBIC::Schema;
use Data::DPath qw(dpath);
use Data::Dumper;

plan tests => 2;

# --------------------------------------------------
construct_fixture( schema  => testrundb_schema, fixture => 't/fixtures/testrundb/testrun_with_preconditions.yml' );
construct_fixture( schema  => hardwaredb_schema, fixture => 't/fixtures/hardwaredb/systems.yml' );
# --------------------------------------------------

is( model('TestrunDB')->resultset('Precondition')->count, 5, "version count" );

my $content = get_hardwaredb_overview(12);
print STDERR Dumper($content);
my $result = $content ~~ dpath '/network//vendor';
is ($result->[0], 'RealTek', 'Content from hw report');
