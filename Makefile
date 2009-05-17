.PHONY: spec clean open gh-clean force

ALL = $(shell find . -name *.pod | perl -pe 's/^(.*\/).*$$/$$1/' | sort | uniq)

all: index.html $(ALL)

index.html: index.html.tt2
	tt-render --path=.:template --data=config.yaml $< > $@

$(ALL): force
	make -C $@

force:
	true

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
