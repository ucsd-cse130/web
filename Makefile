#############################################################################

PANDOC=pandoc --columns=80  -s --mathjax=http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML --slide-level=2
SLIDY=$(PANDOC) -t slidy
DZSLIDES=$(PANDOC) --highlight-style tango --css=slides.css -w dzslides
HANDOUT=$(PANDOC) --highlight-style tango --css=text.css -w html5
SLIDES=$(patsubst lectures/%.md,lectures/%.md.slides.html,$(wildcard *.md))

# clear out all suffixes
.SUFFIXES:
# list only those we use
.SUFFIXES: .html .md
.PHONY: all slides handouts

#############################################################################

site:
	stack build
	stack exec -- homepage rebuild

upload:
	cp -r _site/* docs/ 
	cd docs/ && git add . && git commit -a -m "update page" && git push origin master 

clean:
	rm -rf *.hi *.o .*.swp .*.swo website _site/ _cache/

server:
	stack exec -- homepage watch

#############################################################################

handouts:
	for file in *.md; do $(HANDOUT) $$file -o $$file.handout.html; done
# for file in *.md; do $(DZSLIDES) $$file -o $$file.slides.html; done
#	for file in *.md; do $(PANDOC) $$file -o $$file.pdf; done

slides: $(SLIDES)

%.md.slides.html: %.md
	$(DZSLIDES) $< -o $@

# clean:
#	rm -f *.pdf *.html *.class
