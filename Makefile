.PHONY: spec clean open

all: index.html spec

index.html: index.html.tt2
	tt-render --path=.:template --data=config.yaml $< > $@

spec:
	make -C $@

clean:
	rm -f index.html
	make -C spec $@

open: index.html
	open $<

publish:
	git co master
	git push
	git co gh-pages
	git merge master
	make clean all
	make clean
	git commit -a -m 'Publish latest spec'
	git push
	git co master
