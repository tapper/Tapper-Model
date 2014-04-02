package Tapper::Model;
# ABSTRACT: Tapper - Context sensitive connected DBIC schema

use warnings;
use strict;

use 5.010;

# avoid these warnings
#   Subroutine initialize redefined at /2home/ss5/perl510/lib/site_perl/5.10.0/Class/C3.pm line 70.
#   Subroutine uninitialize redefined at /2home/ss5/perl510/lib/site_perl/5.10.0/Class/C3.pm line 88.
#   Subroutine reinitialize redefined at /2home/ss5/perl510/lib/site_perl/5.10.0/Class/C3.pm line 101.
# by forcing correct load order.

use Class::C3;
use MRO::Compat;
use Tapper::Config;
use parent 'Exporter';
use Tapper::Schema::TestrunDB;

my  $or_testrundb_schema;
our @EXPORT_OK = qw(model get_hardware_overview);

=head2 model

Returns a connected schema, depending on the environment (live,
development, test).

@param 1. $schema_basename - optional, default is "Tests", meaning the
          Schema "Tapper::Schema::Tests"

@return $schema

=cut

sub model {
    if ( $or_testrundb_schema ) {
        return $or_testrundb_schema;
    }
    else {
        return $or_testrundb_schema = Tapper::Schema::TestrunDB->connect(
            @{Tapper::Config->subconfig->{database}{TestrunDB}}{qw/ dsn username password /},{},
        );
    }
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
        my $owner_search = model('TestrunDB')->resultset('Owner')->search({ login => $login });
        my $owner_id;
        if (not $owner_search->count) {
                my $owner = model('TestrunDB')->resultset('Owner')->new({ login => $login });
                $owner->insert;
                return $owner->id;
        } else {
                my $owner = $owner_search->search({}, {rows => 1})->first; # at least one owner
                return $owner->id;
        }
        return;
}

=head2 free_hosts_with_features

Return list of free hosts with their features and queues.

=cut


=head2 get_hardware_overview

Returns an overview of a given machine revision.

@param int - machine lid

@return success - hash ref
@return error   - undef

=cut

use Carp;

sub get_hardware_overview
{
        my ($host_id) = @_;

        my $host = model('TestrunDB')->resultset('Host')->find($host_id);
        return qq(Host with id '$host_id' not found) unless $host;

        my %all_features;

        foreach my $feature ($host->features) {
                $all_features{$feature->entry} = $feature->value;
        }
        return \%all_features;

}

=head1 SYNOPSIS

    use Tapper::Model 'model';
    my $testrun = model('TestrunDB')->schema('Testrun')->find(12);
    my $testrun = model('TestrunDB')->schema('Report')->find(7343);

=cut

1; # End of Tapper::Model