package Artemis::Model;

use warnings;
use strict;

our $VERSION = '2.010001';

use Artemis::Config;

our @EXPORT_OK = qw(model);

=begin model

Returns a connected schema, depending on the environment (live,
development, test).

@param 1. $schema_basename - optional, default is "Tests", meaning the
          Schema "Artemis::Schema::Tests"

@return $schema

=end model

=cut

sub model
{
        my ($self, $schema_basename) = @_;

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


=head1 NAME

Artemis::Model - Get connected Artemis Schema aka. a model!

=head1 SYNOPSIS

    use Artemis::Model qw(model);
    my $testrun = model('ReportsDB')->schema('Report')->find(12345);

=head1 EXPORT

=head2 model

Returns a connected schema.

=head1 COPYRIGHT & LICENSE

Copyright 2008 OSRC SysInt Team, all rights reserved.

This program is released under the following license: restrictive


=cut

1; # End of Artemis::Model
