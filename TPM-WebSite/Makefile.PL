use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'TPM::WebSite::Calendar',
    AUTHOR              => q{Mike Stok <mike@stok.ca>},
    VERSION_FROM        => 'lib/TPM/WebSite/Calendar.pm',
    ABSTRACT_FROM       => 'lib/TPM/WebSite/Calendar.pm',
    ($ExtUtils::MakeMaker::VERSION >= 6.3002
      ? ('LICENSE'=> 'perl')
      : ()),
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'TPM::WebSite-*' },
);
