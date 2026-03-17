all: hw4.html

hw4.html: hw4.qmd data/lq.rds data/dennys.rds
	quarto render hw4.qmd

data/lq.rds: parse_lq.R data/lq/*.htm
	Rscript parse_lq.R

data/dennys.rds: parse_dennys.R data/dennys/*.htm
	Rscript parse_dennys.R

data/lq/*.htm: get_lq.R
	Rscript get_lq.R

data/dennys/*.htm: get_dennys.R
	Rscript get_dennys.R

clean:
	rm -f hw4.html
	rm -f hw4.md
	rm -rf data/

.PHONY: all clean
