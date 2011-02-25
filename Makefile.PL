use strict;
use warnings;

use inc::Module::Install;

name     'Tapper-Model';
all_from 'lib/Tapper/Model.pm';
author   'OSRC SysInt Team <osrc-sysint@elbe.amd.com>';
license  'freebsd';

build_requires 'Test::More'                  => 0;
build_requires 'Test::Perl::Critic'          => 0;
build_requires 'Test::Fixture::DBIC::Schema' => "0.02";
build_requires 'Tapper::Test'               => "2.010005";
build_requires 'Data::DPath'                 => "0.17";

author_requires 'Module::Install::WriteAll';

requires 'perl'                        => '5.010';
requires 'parent'                      => 0;
requires 'Memoize'                     => 0;
requires 'Tapper::Config'             => '2.010004';
requires 'Tapper::Schema'             => '2.010066';

WriteAll;
