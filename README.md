Website Source and Perl Processing for Toronto Perl Mongers
===========================================================

The objective of this is to have a go with some simple perl techniques
so that I can do something simple with some new modules.  This is not
meant to be a "state of the art" web site generator...

To generate the website you need to install the TPM::WebSite module and
its programs.  The simplest way to do this is:

     make install-module

Then you can do:

    make clean    # clean all generated files
    make          # generate files from XML and templates
    make install  # copy files to http://to.pm.org
