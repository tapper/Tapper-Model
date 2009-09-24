package Artemis::Model;

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

use Memoize;
use Artemis::Config;
use parent 'Exporter';

our $VERSION   = '2.010014';
our @EXPORT_OK = qw(model get_hardwaredb_overview);


=begin model

Returns a connected schema, depending on the environment (live,
development, test).

@param 1. $schema_basename - optional, default is "Tests", meaning the
          Schema "Artemis::Schema::Tests"

@return $schema

=end model

=cut

memoize('model');
sub model
{
        my ($schema_basename) = @_;

        $schema_basename ||= 'TestrunDB';

        my $schema_class = "Artemis::Schema::$schema_basename";

        # lazy load class
        eval "use $schema_class";
        if ($@) {
                print STDERR $@;
                return undef;
        }
        return $schema_class->connect(Artemis::Config->subconfig->{database}{$schema_basename}{dsn},
                                      Artemis::Config->subconfig->{database}{$schema_basename}{username},
                                      Artemis::Config->subconfig->{database}{$schema_basename}{password});
}

sub get_systems_id_for_hostname
{
        my ($name) = @_;
        my $system = model('HardwareDB')->resultset('Systems')->search({systemname => $name, active => 1});
        return if not $system;
        return $system->count ? $system->first->lid : undef;
}

sub get_hostname_for_systems_id
{
        my ($lid) = @_;
        my $host  = model('HardwareDB')->resultset('Systems')->find($lid);
        return if not $host;
        return $host->systemname;
}

sub get_user_id_for_login {
        my ($login) = @_;
        my $user_search = model('TestrunDB')->resultset('User')->search({ login => $login });
        return if not $user_search;
        my $user = $user_search->first;
        my $user_id = $user ? $user->id : 0;
        return $user_id;
}

sub free_hosts_with_features
{
        my $hosts =  model('TestrunDB')->resultset("Host")->free_hosts;
        my @hosts_with_features;
        while (my $host = $hosts->next) {
                push @hosts_with_features, {host => $host, features => get_hardwaredb_overview(get_systems_id_for_hostname($host->name))};
        }
        return \@hosts_with_features;
}


=head2 get_hardwaredb_overview

Returns an overview of a given machine revision.

@param int - machine lid

@return success - hash ref
@return error   - undef

=cut

use Carp;

sub get_hardwaredb_overview
{
        my ($lid) = @_;

        return {} unless defined $lid;

        my $system = model('HardwareDB')->resultset('Systems')->find($lid);
        return {
                # error => "machine $lid not found in database"
               } unless $system;

        my $revisions = $system->revisions;
        return {} if not $revisions->count;
        return {
                hostname        => $system->systemname,
                mem             => $revisions->mem,

                cpus            => [ map {{ vendor   => $_->vendor,
                                            family   => $_->family,
                                            model    => $_->model,
                                            stepping => $_->stepping,
                                            revision => $_->revision,
                                            socket   => $_->socket_type,
                                            cores    => $_->cores,
                                            clock    => $_->clock,
                                            l2cache  => $_->l2cache,
                                            l3cache  => $_->l3cache,
                                        }} $revisions->cpus],

                mainboard      => [ map {{
                                          vendor       => $_->vendor,
                                          model        => $_->model,
                                          socket_type  => $_->socket_type,
                                          nbridge      => $_->nbridge,
                                          sbridge      => $_->sbridge,
                                          num_cpu_sock => $_->num_cpu_sock,
                                          num_ram_sock => $_->num_ram_sock,
                                          bios         => $_->bios,
                                          features     => $_->features,
                                  }} $revisions->mainboards ]->[0],       # this is a map to handle empty mainboards correctly

                network         => [ map {{
                                           vendor   => $_->vendor,
                                           chipset  => $_->chipset,
                                           mac      => $_->mac,
                                           bus_type => $_->bus_type,
                                           media    => $_->media,
                                   }} $revisions->networks],
                   };
}

=head1 NAME

Artemis::Model - Get a connected Artemis Schema aka. model!

=head1 SYNOPSIS

    use Artemis::Model 'model';
    my $testrun = model->schema('Testrun')->find(12);  # defaults to "TestrunDB"
    my $testrun = model('ReportsDB')->schema('Report')->find(7343);


=head1 EXPORT

=head2 model

Returns a connected schema.

=head1 COPYRIGHT & LICENSE

Copyright 2008 OSRC SysInt Team, all rights reserved.

This program is released under the following license: restrictive


=cut

1; # End of Artemis::Model
