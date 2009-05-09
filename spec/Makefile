.PHONY: clean gh-clean

all: index.html

index.html: index.html.tt2
	tt-render --path=.:../template --data=config.yaml $< > $@
	rm $<

index.html.tt2: spec-1.0.pod
	pod2html $< > $@.tmp 2> /dev/null
	rm pod2htm[id].tmp
	bin/strip.pl $@.tmp > $@
	rm $@.tmp

open: index.html
	$@ $<

clean:
	rm -f index.html*

gh-clean:
	rm -f index.html.tt2
