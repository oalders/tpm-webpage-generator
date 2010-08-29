#!perl -T

use Test::More;

BEGIN {
    use_ok( 'TPM::WebSite::Meeting' ) || print "Bail out!"
}

diag( "Testing TPM::WebSite::Meeting $TPM::WebSite::Meeting::VERSION, Perl $], $^X" );

my $sample_meeting = 't/fixtures/10-Meeting-simple.xml';
my $meeting = TPM::WebSite::Meeting->new();
$meeting->load_file($sample_meeting);

is($meeting->venue(), 'Nexient Learning; Room 15 on the 8th floor', "check venue");

done_testing;
