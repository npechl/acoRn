---
title: 'acoRn: A Forest Adventure in Search of Oak Parents'
tags:
  - R 
  - ecology
  - ecological-modelling
  - parental-assignment
authors:
  - name: Nikos Pechlivanis
    orcid: 0000-0003-2502-612X
    affiliation: 1
  - name: Fotis Psomopoulos
    orcid: 0000-0002-0222-4273
    affiliation: 1
  - name: Aristotelis C. Papageorgiou
    orcid: 0000-0001-6657-7820
    affiliation: 2
affiliations:
 - name: Institute of Applied Biosciences, Centre for Research and Technology Hellas, Thessaloniki, Greece
   index: 1
 - name: Department of Molecular Biology and Genetics, Democritus University of Thrace, Alexandroupolis, Greece
   index: 2
date: 18 June 2024
bibliography: paper.bib
---

# Summary
In this study, we present `acoRn`, an open-source R package designed for exclusion-based parentage assignment. Utilizing the principles of Mendelian segregation, `acoRn` analyzes multilocus genotype data from potential parents and offspring to identify likely parentage relationships, while accommodating genotyping errors, missing data, and duplicate genotypes. We demonstrated the application of `acoRn` by analyzing synthetic datasets of adult and progeny trees within a specific forest stand. Our findings indicated that only a small subset of adult trees contributed to the juvenile generation, showcasing the tool's capability to elucidate parentage patterns. `acoRn` is effective not only for oak trees but also for a wide range of organisms, making it a versatile tool for parentage analysis. Its ability to process diverse datasets and deliver clear results highlights its utility in studying reproductive relationships and population dynamics in biological research. `acoRn` serves as a valuable resource for researchers seeking robust parentage assignment methods and is freely available on GitHub at [**npechl/acoRn**](https://github.com/npechl/acoRn).

# Statement of need
Parentage assignment based on the genetic information of two subsequent generations is a critical technique employed across multiple biological disciplines to gain insights into the reproductive relationships and genetic structures of populations [@Huang_et_al]. This method is essential for several key applications [@Jones_et_al]:
- *Biodiversity Conservation*: In conservation biology, understanding the genetic relationships within and between populations is fundamental for preserving genetic diversity. Parentage assignment helps identify which individuals are contributing offspring to the next generation, thereby informing strategies to maintain or enhance genetic variability, support breeding programs for endangered species, and manage habitat restoration efforts.
- *Breeding Programs*: In agricultural and horticultural contexts, parentage assignment is crucial for selective breeding programs. By accurately identifying parent-offspring relationships, breeders can make informed decisions to enhance desirable traits such as disease resistance, yield, or growth rates. This technique ensures the traceability of genetic lineage, aids in the prevention of inbreeding, and facilitates the development of new varieties or breeds with optimized characteristics.
- *Understanding Mating Patterns*: Analyzing mating patterns within a population provides insights into reproductive strategies, mate choice, and the genetic structure of populations. Parentage assignment can reveal patterns such as polygamy, monogamy, or assortative mating, which have significant implications for the genetic health and evolution of populations.
- *Gene Flow Studies*: Gene flow refers to the transfer of genetic material between populations. Parentage assignment helps track the movement of genes across geographical and ecological boundaries, thereby elucidating the connectivity between populations. This information is crucial for understanding how populations adapt to changing environments and for managing gene flow to prevent genetic isolation.
- *Hybridization Studies*: In natural and managed populations, hybridization between species or subspecies can have profound effects on genetic diversity and adaptation. Parentage assignment allows researchers to identify hybrid individuals and assess the extent and impact of hybridization events. This is particularly important in conservation, where hybridization with non-native species can threaten the genetic integrity of native populations.

Here, we introduce `acoRn`, an open-source R package designed for exclusion-based parentage assignment. Leveraging Mendelian segregation principles, `acoRn` compares multilocus genotype data from potential parents and offspring to identify likely parentage relationships, even in the presence of genotyping errors, missing values, and duplicate genotypes. This version of `acoRn` considers diploid individuals that can act both as male and female parents, thus can produce female as well as male gametes. This mating pattern is typical for most plant species.

# Results
In our study, we applied `acoRn` to synthetic datasets representing adult and juvenile trees within a forest population, demonstrating a typical use case for parentage analysis. We created six different representative cases of genetic diversity for 500 adult trees (parents). For each of these six scenarios, we generated datasets of 1,000 juvenile trees (progeny) based on a random mating model. The diversity patterns for the adult trees were as follows:
1. 100 gene loci with up to seven alleles each and random frequencies
2. 100 gene loci with up to two alleles each and random frequencies
3. 100 gene loci with up to two alleles each and minimum allele frequencies up to 0.1
4. 10 gene loci with up to seven alleles each and random frequencies
5. 10 gene loci with up to two alleles each and random frequencies
6. 10 gene loci with up to two alleles each and minimum allele frequencies up to 0.1

We then tested `acoRn` to assign parents to every juvenile tree for each of these six cases. As expected, the algorithm's effectiveness depended on the number of gene loci and their genetic diversity. In the high diversity scenario (#1), parents were correctly assigned for all progeny (1000/1000). However, in the case of 100 loci with two alleles each and random frequencies (#2), the success rate dropped to 272/1000 correct parent identifications. For the remaining cases with significantly reduced diversity, the algorithm often suggested more than two parents, leading to a failure in correctly isolating the parents in almost all instances (success rates were 1/1000, 26/1000, 0/1000, and 0/1000 for scenarios #3, #4, #5, and #6, respectively). These low diversity scenarios are unlikely to occur in practice and were used to test the algorithm's limits. Most next-generation sequencing (NGS) derived genotypic datasets contain hundreds or thousands of diverse biallelic loci. When using typical gene markers such as SSR, datasets tend to have fewer multiallelic and highly diverse loci. In both cases, we expect `acoRn` to successfully assign parents to progeny.

In a real-world application, we applied `acoRn` to a small mixed oak forest, where three different oak species occur. We compared two datasets containing the genotypes of 59 adult trees (parents) and 130 juvenile trees (progeny). Genotype information was based on 17 variable SSR markers (Papageorgiou et al. 2024). After addressing duplicate genotypes and missing values, parentage relationships were identified using comprehensive plots and tables generated by `acoRn`. The algorithm successfully identified or excluded parents for 126 of the 130 juvenile individuals. The analysis revealed that only a small subset of adult trees contributed to the next generation, demonstrating `acoRn`'s capability to uncover parentage patterns.

`acoRn` is versatile and suitable for a wide range of organisms beyond oak trees. It efficiently handles various datasets and provides clear results, making it a valuable tool for researchers studying reproductive relationships and population dynamics.

# Methodology
`acoRn` offers two main algorithms:
1. The first generates synthetic genotype data based on user-defined parameters, including the number of parent individuals, variant frequencies, and the number of loci. The progeny genotype data is then produced from the parent genotypes based on random mating and user-defined parameters, such as the number of female and male parents and the number of progeny produced.
2. The second uses genotype data from multiple samples to identify parentage patterns.

## Installation
`acoRn` is licensed under the [MIT License](https://opensource.org/license/mit) and can be easily installed from [GitHub](https://github.com/npechl/acoRn) as follows:

```R
# install.packages("remotes")
remotes::install_github("npechl/acoRn")
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
# References