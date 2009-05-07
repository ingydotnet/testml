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
