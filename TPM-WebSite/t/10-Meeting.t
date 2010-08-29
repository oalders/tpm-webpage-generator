#!perl -T

use common::sense;
use Test::More;

BEGIN {
    use_ok('TPM::WebSite::Meeting') || print "Bail out!";
}

diag(
    "Testing TPM::WebSite::Meeting $TPM::WebSite::Meeting::VERSION, Perl $], $^X"
);

my $sample_meeting = 't/fixtures/10-Meeting-simple.xml';
my $meeting        = TPM::WebSite::Meeting->new();
$meeting->load_file($sample_meeting);

my %sample_checks = (
    venue     => 'Nexient Learning; Room 15 on the 8th floor',
    timestamp => 1264722300,
    topic     => 'Modules and Tips',
);
while ( my ( $method, $expected ) = each %sample_checks ) {
    is( $meeting->$method(), $expected, "check meeting $method" );
}

done_testing;
