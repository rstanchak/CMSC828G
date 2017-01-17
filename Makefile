#topic-presentation.ps: topic-presentation.dvi
#topic-presentation.dvi: topic-presentation.tex
all:
	latex topic-presentation
	dvips topic-presentation -o topic-presentation.ps
pdf:
	latex topic-presentation
	dvipdf topic-presentation
test:
	latex test
	dvips test -o test.ps
clean:
	rm -f topic-presentation.dvi topic-presentation.pdf
