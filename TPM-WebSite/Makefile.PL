use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'TPM::WebSite::Builder',
    AUTHOR              => q{Mike Stok <mike@stok.ca>},
    VERSION_FROM        => 'lib/TPM/WebSite/Builder.pm',
    ABSTRACT_FROM       => 'lib/TPM/WebSite/Builder.pm',
    ($ExtUtils::MakeMaker::VERSION >= 6.3002
      ? ('LICENSE'=> 'perl')
      : ()),
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More'       => 0,
        'Path::Class'      => 0,
        'Readonly'         => 0,
        'Template'         => 0,
        'File::Find::Rule' => 0,
        'XML::Twig'        => 0,
        'Date::Parse'      => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'TPM::WebSite-*' },
);
