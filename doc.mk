.PHONY: clean gh-clean

POD = $(shell ls *.pod)

all: index.html

index.html: index.html.tt2
	tt-render --path=.:$(TOP)/template --data=config.yaml $< > $@

index.html.tt2: $(POD)
	pod2html $< > $@.tmp 2> /dev/null
	rm pod2htm[id].tmp
	$(TOP)/bin/strip.pl $@.tmp > $@
	rm $@.tmp

open: index.html
	$@ $<

clean:
	rm -f index.html*

gh-clean:
	rm -f index.html.tt2
