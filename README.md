# acoRn

<!-- badges: start -->

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

``` r
library(acoRn)

data("parents")
data("offspring")

r = acoRn(parents, offspring)

head(r)
```
