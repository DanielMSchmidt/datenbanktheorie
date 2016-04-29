all: heft

heft:
	@pdflatex solution.tex -interaction=scrollmode

clean:
	@rm *.ist *.glo *.acn

docker:
	docker run --rm -v $(shell pwd):/test/ -w=/test -t passy/texlive-poppler pdflatex solution.tex -interaction=scrollmode
