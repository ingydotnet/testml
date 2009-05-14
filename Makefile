.PHONY: spec clean open gh-clean

TOP = $(shell pwd)
ALL = spec doc/manual

all: index.html
	for d in $(ALL); do TOP=$(TOP) make -C $$d; done

index.html: index.html.tt2
	tt-render --path=.:template --data=config.yaml $< > $@

clean:
	rm -f index.html
	for d in $(ALL); do make -C $$d $@; done;

gh-clean:
	for d in $(ALL); do make -C $$d $@; done;

open: all
	open index.html

publish: clean
	git checkout master
	git push
	git checkout gh-pages
	git merge master
	make clean all
	make gh-clean
	git add .
	git status
	git commit -a -m 'Publish latest spec'
	git push
	git checkout master
