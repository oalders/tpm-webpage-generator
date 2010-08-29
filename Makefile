all:
	cd code && ./build-tree

tidy:
	perltidy -nst -nse -b code/build-tree

critic:
	perlcritic --brutal code/build-tree

clean:
	rm -f to.pm.org/index.html

install:
	scp -r to.pm.org/index.html \
	       to.pm.org/tpm.css \
	       to.pm.org/sponsors.html \
	       to.pm.org/reviews.html \
	       to.pm.org/reviews/ \
	       to.pm.org/20?? \
	       tpm@to.pm.org:httpdocs/
