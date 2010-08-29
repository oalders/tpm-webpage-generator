Website Source and Perl Processing for Toronto Perl Mongers
===========================================================

This repo contains the code and data to generate the meeting and index
pages for recent Toronto Perl Mongers meetings.

The typical uses of this are:

1. Add a new meeting.
2. Cycle the next or most recent meeting listed at the top of the index page.

To generate the website you need to install the TPM::WebSite module and
its programs.  The simplest way to do this is:

     make install-module

Then you can do:

    make clean    # clean all generated files
    make          # generate files from XML and templates
    make install  # copy files to http://to.pm.org

Guide to Directories
--------------------

* meetings

    This directory contains the XML files used to generate the web
    pages for the meetings themselves and the entries in the main index
    page for the http://to.pm.org/ web site.

* sections

    This contains the sections used on the index page of http://to.pm.org/
    as HTML fragments.  The file names (without extensions) are used as the
    section headings on the page.

* templates

    This contains the files used by Template to generate the index page and
    the pages for the meetings.

    Page templates have a .tt suffix, and supporting files have no suffix.

* to.pm.org

    This contains all the old content of the Toronto Perl Mongers web site
    as well as the css files and generated HTML.  Be careful messing around
    in here...

* TPM-WebSite

    This contains a module which provides the build-tpm-site program.

Caveats
-------

The objective of this is to have a go with some simple perl techniques
so that I can do something simple with some new modules.  This is not
meant to be a "state of the art" web site generator...

