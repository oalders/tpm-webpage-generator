all:
	cd code && ./build-tree

critic:
	perlcritic --brutal code/build-index code/TPM/*.pm

clean:
	rm -f to.pm.org/index.html

install:
	scp to.pm.org/index.html to.pm.org/tpm.css to.pm.org/sponsors.html tpm@to.pm.org:httpdocs/
