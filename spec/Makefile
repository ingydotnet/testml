all: index.html

index.html: spec-1.0.pod
	pod2html $< > $@ 2> /dev/null
	rm pod2htm[id].tmp

open: index.html
	$@ $<

clean:
	rm -f index.html

