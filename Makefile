.PHONY: spec clean

all: index.html spec

index.html: index.html.tt2
	tt-render --path=.:template $< > $@

spec:
	make -C $@

clean:
	rm -f index.html
	make -C spec $@
