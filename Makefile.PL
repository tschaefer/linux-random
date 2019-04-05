#!/usr/bin/env perl

use strict;
use warnings;

use ExtUtils::MakeMaker;

WriteMakefile(
    'ABSTRACT'   => 'Seed entropy and harvest random bytes.',
    'AUTHOR'     => 'Tobias Schaefer <github@blackox.org>',
    'DISTNAME'   => 'Linux-Random',
    'META_MERGE' => {
        resources => {
            'license'    => 'http://dev.perl.org/licenses',
            'homepage'   => 'https://github.com/tschaefer/linux-random',
            'repository' => 'https://github.com/tschaefer/linux-random.git',
        }
    },
    'NAME'      => 'Linux::Random',
    'PREREQ_PM' => {
        'Readonly' => '2.05',
    },
    'VERSION_FROM' => 'lib/Linux/Random.pm',
    'clean'        => { FILES => 'Linux-Random-*' },
    'dist'         => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    ( $ExtUtils::MakeMaker::VERSION >= 6.3002 ? ( 'LICENSE' => 'perl', ) : () ),
);
