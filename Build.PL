use strict;
use warnings;

use Module::Build;

my $builder = Module::Build->new
    (
     module_name         => 'Artemis::Model',
     license             => 'restrictive',
     dist_author         => 'OSRC SysInt Team <osrc-sysint@elbe.amd.com>',
     dist_version_from   => 'lib/Artemis/Model.pm',
     build_requires => {
                        'Test::More'                  => 0,
                        'Test::Fixture::DBIC::Schema' => 0,
                        'Artemis::Test'               => 0,
                       },
     requires => {
                  'perl'                        => '5.010',
                  'parent'                      => 0,
                  'Artemis::Config'             => 0,
                  'Artemis::Schema'             => 0,
                 },
     add_to_cleanup      => [ 'Artemis-Model-*' ],
    );

$builder->create_build_script();
