
COURS=$(patsubst %/main.tex,%,$(wildcard */main.tex))
BUILDDIR=.out/
LATEXMK=latexmk

BUILD=$(LATEXMK) -use-make -Werror \
		-usepretex='\def\mat{$*}' \
		-M -MP -MF .$*.deps \
		$< -jobname=$* \
		-pdf #-dvi -ps

all: $(patsubst %,%.pdf,$(COURS) full)

include $(wildcard .*.deps)

full.pdf: full.tex
	$(BUILD)
full.dvi: full.tex
full.ps: full.tex

full.tex: \
		.template/full_head.tex \
		.template/full_main.tex \
		.template/full_foot.tex \
		$(patsubst %,%/main.tex,$(COURS))
	cat .template/full_head.tex > $@
	echo -n $(COURS) | tr ' ' '\0' | sort -z | xargs -0 -I {} -n 1 echo $$(cat .template/full_main.tex) >> $@
	cat .template/full_foot.tex >> $@

%.pdf: .template/alone.tex %/main.tex
	$(BUILD)
%.dvi: %/main.tex
	$(BUILD)
%.ps: %/main.tex
	$(BUILD)

clean:
	$(LATEXMK) -c $(COURS) full
distclean:
	$(LATEXMK) -C $(COURS) full
	rm -f $(patsubst %,%.pdf,$(COURS) full)
	rm -f $(patsubst %,%.dvi,$(COURS) full)
	rm -f $(patsubst %,%.ps ,$(COURS) full)
fullclean: distclean
	rm -f .*.deps
