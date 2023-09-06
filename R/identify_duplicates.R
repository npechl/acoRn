#' Idntify duplicates in genotypes (i.e. parents or progenies)
#'
#' @param genotypes a data.frame with the genotypes
#' @param abbr a string with abbreviation to use
#'
#' @return a data.frame
#' @export
#'
#' @examples
identify_duplicates <- function(genotypes, abbr = NULL) {


    # Describe genotypes object - size
    nind     = nrow(genotypes)
    nloci    = ( ncol(genotypes) - 1 ) / 2
    nalleles = ncol(genotypes) - 1

    # cat(
    #     paste0(
    #         "Number of individuals:\t", nind, "\n",
    #         "Number of loci:\t",        nloci, "\n",
    #         "Number of alleles:\t",     nalleles
    #     ),
    #
    #     file = "info-duplicates.txt"
    # )

    message( c("\t...identify duplicates...\tnumber of individuals:\t", nind) )
    message( c("\t...identify duplicates...\tumber of loci:\t",        nloci) )
    message( c("\t...identify duplicates...\tumber of alleles:\t",     nalleles) )


    genotypes = genotypes[, 2:ncol(genotypes)] |>
        setDF(rownames = genotypes$Sample) |>
        as.matrix()


    genotypes[genotypes == 999] = NA


    dupl = genotypes |>
        dist(method = "euclidean") |>
        as.matrix()

    dupl = ifelse(dupl == 0, 1, 0) |>
        as.data.frame() |>
        setDT(keep.rownames = "Sample.a") |>
        melt(id.vars = "Sample.a", value.name = "value", variable.name = "Sample.b",
             value.factor = FALSE, variable.factor = FALSE)

    if(!is.null(abbr)) {

        dupl$Sample.a = paste0(abbr, dupl$Sample.a)
        dupl$Sample.b = paste0(abbr, dupl$Sample.b)

    }

    dupl = dupl[which(value == 1)]

    dupl = dupl[, by = Sample.a, .(
        Group = Sample.b |> sort() |> unique() |> paste(collapse = ", ")
    )]

    colnames(dupl) = c("Sample", "Grouping")

    return(dupl)

}
