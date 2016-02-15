package Tapper::Model;

# ABSTRACT: Tapper - Context sensitive connected DBIC schema

use strict;
use warnings;

use 5.010;

# avoid these warnings
#   Subroutine initialize redefined at /2home/ss5/perl510/lib/site_perl/5.10.0/Class/C3.pm line 70.
#   Subroutine uninitialize redefined at /2home/ss5/perl510/lib/site_perl/5.10.0/Class/C3.pm line 88.
#   Subroutine reinitialize redefined at /2home/ss5/perl510/lib/site_perl/5.10.0/Class/C3.pm line 101.
# by forcing correct load order.

use English;
use Class::C3;
use MRO::Compat;
use Tapper::Config;
use parent 'Exporter';
use Tapper::Schema::TestrunDB;

my $or_testrundb_schema;
our @EXPORT_OK = qw(model get_hardware_overview);

=head2 model

Returns a connected schema, depending on the environment (live,
development, test).

@param 1. $schema_basename - optional, default is "Tests", meaning the
          Schema "Tapper::Schema::Tests"

@return $schema

=cut

sub model {
    return $or_testrundb_schema //= Tapper::Schema::TestrunDB->connect(
        @{Tapper::Config->subconfig->{database}{TestrunDB}}{qw/ dsn username password /},{},
    );
}

=head2 get_or_create_owner

Search a owner based on login name. Create a owner with this login name if
not found.

@param string - login name

@return success - id (primary key of owner table)
@return error   - undef

=cut

sub get_or_create_owner {

        my ($login) = @_;

        return model('TestrunDB')
            ->resultset('Owner')
            ->find_or_create({ login => $login },{ login => $login })
            ->id()
        ;

}

=head2 get_hardware_overview

Returns an overview of a given machine revision.

@param int - machine lid

@return success - hash ref
@return error   - undef

=cut

sub get_hardware_overview {

        my ($host_id) = @_;

        my $host = model('TestrunDB')
                ->resultset('Host')
                ->search({ 'me.id' => $host_id }, { prefetch => 'features' })
                ->first()
        ;

        if (! $host ) {
                return qq(Host with id '$host_id' not found);
        }

        return { map { $_->entry => $_->value } $host->features };

}

=head1 SYNOPSIS

    use Tapper::Model 'model';
    my $testrun = model('TestrunDB')->schema('Testrun')->find(12);
    my $testrun = model('TestrunDB')->schema('Report')->find(7343);

=cut

1; # End of Tapper::Model