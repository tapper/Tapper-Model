package t::Tools;

# inspired by Test::Fixture::DBIC::Schema

use strict;
use warnings;

use Artemis::Schema::TestsDB;
use Artemis::Schema::TestrunDB;
use Artemis::Schema::ReportsDB;

use Artemis::Config;


# TODO: schema --> testsdb_schema
#            % --> hardwaredb_schema

my $testsdb_schema;
my $testrundb_schema;
my $reportsdb_schema;

###################################################
#
# TestsDB is deprecated!
#
###################################################
sub setup_testsdb {

        # explicitely prefix into {test} subhash of the config file,
        # to avoid painful mistakes with deploy

        my $dsn = Artemis::Config->subconfig->{test}{database}{TestsDB}{dsn};

        my ($tmpfname) = $dsn =~ m,dbi:SQLite:dbname=([\w./]+),i;
        unlink $tmpfname;

        $testsdb_schema = Artemis::Schema::TestsDB->connect($dsn,
                                                            Artemis::Config->subconfig->{test}{database}{TestsDB}{username},
                                                            Artemis::Config->subconfig->{test}{database}{TestsDB}{password});
        $testsdb_schema->deploy;
}

sub setup_testrundb {

        # explicitely prefix into {test} subhash of the config file,
        # to avoid painful mistakes with deploy

        my $dsn = Artemis::Config->subconfig->{test}{database}{TestrunDB}{dsn};

        my ($tmpfname) = $dsn =~ m,dbi:SQLite:dbname=([\w./]+),i;
        unlink $tmpfname;

        $testrundb_schema = Artemis::Schema::TestrunDB->connect($dsn,
                                                                Artemis::Config->subconfig->{test}{database}{TestrunDB}{username},
                                                                Artemis::Config->subconfig->{test}{database}{TestrunDB}{password});
        $testrundb_schema->deploy;
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
        $reportsdb_schema->deploy;
}

sub import {
        my $pkg = caller(0);
        no strict 'refs';       ## no critic.
        *{"$pkg\::testsdb_schema"}   = sub () { $testsdb_schema   }; # DEPRECATED, DELETE ME
        *{"$pkg\::testrundb_schema"} = sub () { $testrundb_schema };
        *{"$pkg\::reportsdb_schema"} = sub () { $reportsdb_schema };
}

setup_testsdb; # DEPRECATED, DELETE ME
setup_testrundb;
setup_reportsdb;

1;
