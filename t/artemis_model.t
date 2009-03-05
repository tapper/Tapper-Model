#! /usr/bin/env perl

use lib '.';

use strict;
use warnings;

use Test::More;
use Artemis::Model 'model';
use Artemis::Schema::TestTools;
use Test::Fixture::DBIC::Schema;

BEGIN { $DBD::SQLite::sqlite_version } # fix "used only once" warning

plan tests => 1;

# -----------------------------------------------------------------------------------------------------------------
construct_fixture( schema  => testrundb_schema, fixture => 't/fixtures/testrundb/testrun_with_preconditions.yml' );
# -----------------------------------------------------------------------------------------------------------------

is( model('TestrunDB')->resultset('Precondition')->count, 5, "version count" );
