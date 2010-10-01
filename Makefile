# By default build the site from the files found under the current 
# directory.
default:
	build-tpm-site

clean:
	rm -rf to.pm.org/index.html to.pm.org/20??/*

# Install the generated copies onto to.pm.org - you'll need the tpm
# password to be able to do this.
test-install:
	rsync -avz -n -e ssh to.pm.org/ to.pm.org:httpdocs/

# Install the generated copies onto to.pm.org - you'll need the tpm
# password to be able to do this.
install:
	rsync -avz -e ssh to.pm.org/ to.pm.org:httpdocs/

# Install the TPM-Website module which contains the build-tpm-site program.
# Note: this requires cpanm, which is probably a nice thing to have anyway -
# it's easy to find on http://search.cpan.org/
install-module:
	cpanm ./TPM-WebSite
