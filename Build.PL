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
                        'Test::Fixture::DBIC::Schema' => "0.02",
                        'Artemis::Test'               => "2.010005",
		        'Data::DPath'                 => "0.17",
                       },
     requires => {
                  'perl'                        => '5.010',
                  'parent'                      => 0,
                  'Memoize'                     => 0,
                  'Artemis::Config'             => '2.010004',
                  'Artemis::Schema'             => '2.010046',
                 },
     add_to_cleanup      => [ 'Artemis-Model-*' ],
    );

$builder->create_build_script();
