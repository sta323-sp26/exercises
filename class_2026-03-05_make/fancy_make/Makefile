all: paper.html paper.md

paper.html: paper.qmd fig1/fig.png fig2/fig.png
	quarto render paper.qmd

paper.md: paper.qmd fig1/fig.png fig2/fig.png
	quarto render paper.qmd --to gfm

fig%/fig.png: fig%/fig.R
	cd $(<D);Rscript $(<F)

clean: 
	rm -f paper.html
	rm -f paper.md
	rm -f fig*/fig.png

.PHONY: all clean
