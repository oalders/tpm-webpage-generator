#!perl -T

use common::sense;
use Test::More tests => 14;

BEGIN {
    use_ok('TPM::WebSite::Meeting') || print "Bail out!";
}

diag(
    "Testing TPM::WebSite::Meeting $TPM::WebSite::Meeting::VERSION, Perl $], $^X"
);


my $sample_meeting_file = 't/fixtures/10-Meeting-simple.xml';
my $sample_utime = time - 12345;

utime $sample_utime, $sample_utime, $sample_meeting_file;
my $meeting        = TPM::WebSite::Meeting->new();

$meeting->load_file($sample_meeting_file);

my %simple_checks = (
    venue      => 'Nexient Learning; Room 15 on the 8th floor',
    topic      => 'Modules and Tips',
    filename   => '2010/01/28/Modules_and_Tips.html',
    timestamp  => 1264722300,
    date       => 'Thu 28 Jan 2010 18:45 EST',
    short_date => '28 Jan 2010',
    updated_at => $sample_utime,
);

while ( my ( $method, $expected ) = each %simple_checks ) {
    is( $meeting->$method(), $expected, "check meeting $method" );
}

my $synopsis = $meeting->synopsis();
like(
    $synopsis,
    qr/Some are old standbys, some are new\./,
    'quick check of synopsis'
);

my $talks = $meeting->talks();
is( scalar @{$talks}, 5, 'check the number of talks' );

is($talks->[-1]{title}, 'Odds & Ends', 'Check last talk title with an &');

my $leader = $meeting->leader();
ok($leader, 'meeting has a leader');
is($leader->name(), 'Some Dude', 'Leader name correct');
is($leader->label(), 'Emcee', 'Leader label correct');
