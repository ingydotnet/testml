.PHONY: spec clean open gh-clean

all: index.html spec

index.html: index.html.tt2
	tt-render --path=.:template --data=config.yaml $< > $@

spec:
	make -C $@

clean:
	rm -f index.html
	make -C spec $@

gh-clean:
	make -C spec $@

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
