use strict;
use warnings;

use inc::Module::Install;

name     'Artemis-Model';
all_from 'lib/Artemis/Model.pm';
author   'OSRC SysInt Team <osrc-sysint@elbe.amd.com>';

build_requires 'Test::More'                  => 0;
build_requires 'Test::Perl::Critic'          => 0;
build_requires 'Test::Fixture::DBIC::Schema' => "0.02";
build_requires 'Artemis::Test'               => "2.010005";
build_requires 'Data::DPath'                 => "0.17";

requires 'perl'                        => '5.010';
requires 'parent'                      => 0;
requires 'Memoize'                     => 0;
requires 'Artemis::Config'             => '2.010004';
requires 'Artemis::Schema'             => '2.010066';
 

WriteAll;
