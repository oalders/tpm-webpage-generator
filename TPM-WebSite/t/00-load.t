#!perl -T

use Test::More tests => 2;

BEGIN {
    use_ok( 'TPM::WebSite::Meeting' ) || print "Bail out!
";
    use_ok( 'TPM::WebSite::Builder' ) || print "Bail out!
";
}

diag( "Testing TPM::WebSite::Builder $TPM::WebSite::Builder::VERSION, Perl $], $^X" );
