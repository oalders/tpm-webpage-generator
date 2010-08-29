#!perl -T

use Test::More tests => 5;

BEGIN {
    use_ok( 'TPM::WebSite::Calendar' ) || print "Bail out!
";
    use_ok( 'TPM::WebSite::Meeting' ) || print "Bail out!
";
    use_ok( 'TPM::WebSite::HTMLRenderer' ) || print "Bail out!
";
    use_ok( 'TPM::WebSite::HTMLFile' ) || print "Bail out!
";
    use_ok( 'TPM::WebSite::Builder' ) || print "Bail out!
";
}

diag( "Testing TPM::WebSite::Builder $TPM::WebSite::Builder::VERSION, Perl $], $^X" );
