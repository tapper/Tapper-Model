#! /usr/bin/env perl

use lib '.';

use strict;
use warnings;

use Artemis::Model 'model';
use t::Tools;

use Test::More;
use Test::Fixture::DBIC::Schema;

plan tests => 1;

# -----------------------------------------------------------------------------------------------------------------
construct_fixture( schema  => testrundb_schema, fixture => 't/fixtures/testrundb/testrun_with_preconditions.yml' );
# -----------------------------------------------------------------------------------------------------------------

is( model('TestrunDB')->resultset('Precondition')->count, 5, "version count" );

