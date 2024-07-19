# acoRn

<!-- badges: start -->

[![R-CMD-check](https://github.com/npechl/acoRn/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/npechl/acoRn/actions/workflows/R-CMD-check.yaml)

<!-- badges: end -->

**`acoRn`** an open-source R package designed for exclusion-based parentage assignment. Utilizing the principles of Mendelian segregation, `acoRn` analyzes multilocus genotype data from potential parents and offspring to identify likely parentage relationships, while accommodating genotyping errors, missing data, and duplicate genotypes.

## Installation

`acoRn` can be easily installed through GitHub as follows:

```R
# install.packages("remotes")
library(remotes)
install_github("npechl/acoRn")
```

## Usage

### Synthetic genotype data generation
```R
# load acoRn
library(acoRn)

# create mock parents dataset
parents <- create_mock_parents()

# create mock progeny dataset
offspring <- create_mock_progeny(p[[1]], fparents = 5, mparents = 5, prog = 5)
```

### Parental assignment
```R
# load acoRn
library(acoRn)

# example datasets
data("parents")
data("offspring")

# run acoRn
r <- acoRn(parents, offspring)

head(r)
```
