Simple programs & modules to generate TPM website pages.

The objective of this is to have a go with some simple perl techniques
so that I can do something simple with some new modules.  This is not
meant to be a "state of the art" web site generator...

To make the program run you need to install the TPM::WebSite modules:

  cd TPM-WebSite
  perl Makefile.PL
  make && make test && make install

Then you can:

  make critic # testing perl code
  make clean
  make
  make install

Prerequisites:

  (specified in module Makefile.PL)
  Perl::Critic (for make critic)

Todo:

  add --src-root
  add --output
  fix pod
  add tests
  mootools
