package t::Tools;

# inspired by Test::Fixture::DBIC::Schema

use strict;
use warnings;

use Artemis::Schema::TestsDB;
use Artemis::Schema::TestrunDB;
use Artemis::Schema::ReportsDB;

use Artemis::Config;


my $testrundb_schema;
my $reportsdb_schema;

sub setup_testrundb {

        # explicitely prefix into {test} subhash of the config file,
        # to avoid painful mistakes with deploy

        my $dsn = Artemis::Config->subconfig->{test}{database}{TestrunDB}{dsn};

        my ($tmpfname) = $dsn =~ m,dbi:SQLite:dbname=([\w./]+),i;
        unlink $tmpfname;

        $testrundb_schema = Artemis::Schema::TestrunDB->connect($dsn,
                                                                Artemis::Config->subconfig->{test}{database}{TestrunDB}{username},
                                                                Artemis::Config->subconfig->{test}{database}{TestrunDB}{password});
        #$testrundb_schema->deploy;
}

sub setup_reportsdb {

        # explicitely prefix into {test} subhash of the config file,
        # to avoid painful mistakes with deploy

        my $dsn = Artemis::Config->subconfig->{test}{database}{ReportsDB}{dsn};

        my ($tmpfname) = $dsn =~ m,dbi:SQLite:dbname=([\w./]+),i;
        unlink $tmpfname;

        $reportsdb_schema = Artemis::Schema::ReportsDB->connect($dsn,
                                                                Artemis::Config->subconfig->{test}{database}{ReportsDB}{username},
                                                                Artemis::Config->subconfig->{test}{database}{ReportsDB}{password});
        #$reportsdb_schema->deploy;
}

sub import {
        my $pkg = caller(0);
        no strict 'refs';       ## no critic.
        *{"$pkg\::testrundb_schema"} = sub () { $testrundb_schema };
        *{"$pkg\::reportsdb_schema"} = sub () { $reportsdb_schema };
}

setup_testrundb;
setup_reportsdb;

1;
