all:
	cd code && ./build-tree

critic:
	perlcritic --brutal code/build-index code/TPM/*.pm

clean:
	rm -f to.pm.org/index.html

install:
	scp -r to.pm.org/index.html to.pm.org/tpm.css to.pm.org/sponsors.html to.pm.org/20?? tpm@to.pm.org:httpdocs/
