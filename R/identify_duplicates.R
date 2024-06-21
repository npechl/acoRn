#' Identify duplicates in genotypes (i.e. parents or progenies)
#'
#' @param genotypes a data.frame with the genotypes
#' @param abbr a string with abbreviation to use
#'
#' @return a data.frame
#' @export
#'
#' @importFrom data.table setDF setDT melt
#' @importFrom stats dist
#'
identify_duplicates <- function(genotypes, abbr = NULL) {


    genotypes$tree_id = paste0(abbr, genotypes$tree_id)

    genotypes <- genotypes[, by = tree_id, .(Genotype = paste(.SD, collapse = ";"))]
    genotypes <- genotypes[, by = Genotype, .(Grouping = tree_id |> str_sort(numeric = TRUE) |> paste(collapse = ", "))]

    genotypes$Sample = genotypes$Grouping |> str_split_i("\\,", 1) |> str_squish()

    dupl = genotypes[, c("Sample", "Grouping"), with = FALSE]

    # nind     = nrow(genotypes)
    # nloci    = ( ncol(genotypes) - 1 ) / 2
    # nalleles = ncol(genotypes) - 1
    #
    # # message( c("\t...identify duplicates...\tnumber of individuals:\t", nind) )
    # # message( c("\t...identify duplicates...\tumber of loci:\t",         nloci) )
    # # message( c("\t...identify duplicates...\tumber of alleles:\t",      nalleles) )
    #
    #
    # genotypes = genotypes[, 2:ncol(genotypes)] |>
    #     setDF(rownames = genotypes$Sample) |>
    #     as.matrix()
    #
    #
    # # genotypes[genotypes == 999] = NA
    #
    #
    # dupl = genotypes |>
    #     dist(method = "euclidean") |>
    #     as.matrix()
    #
    # dupl = ifelse(dupl == 0, 1, 0) |>
    #     as.data.frame() |>
    #     setDT(keep.rownames = "Sample.a") |>
    #     melt(
    #         id.vars = "Sample.a",
    #         value.name = "value", variable.name = "Sample.b",
    #         value.factor = FALSE, variable.factor = FALSE
    #     )
    #
    # if(!is.null(abbr)) {
    #
    #     dupl$Sample.a = paste0(abbr, dupl$Sample.a)
    #     dupl$Sample.b = paste0(abbr, dupl$Sample.b)
    #
    # }
    #
    # dupl = dupl[which(dupl$value == 1)]
    #
    # dupl = dupl[, by = Sample.a, .(
    #     Group = Sample.b |> sort() |> unique() |> paste(collapse = ", ")
    # )]
    #
    # colnames(dupl) = c("Sample", "Grouping")

    return(dupl)

}

globalVariables(c("Genotype"))
