#' Identify relationships between parents and progenies
#'
#' @param adults a data.frame containing
#' @param progeny a data.frame
#'
#' @return a data.frame
#' @export
#'
#' @importFrom data.table data.table
#' @importFrom data.table rbindlist
#' @importFrom data.table .N
#'
#' @importFrom stringr str_split
#'
find_parents <- function(adults, progeny) {



    # Describe adults and progeny objects - size
    nindadu  = nrow(adults)
    nindpro  = nrow(progeny)
    nlociadu = ( ncol(adults) - 1 ) / 2
    nlocipro = ( ncol(progeny) - 1 ) / 2

    # cat(
    #     paste0(
    #         "Genotypes of adult individuals:\t",   nindadu, "\n",
    #         "Genotypes of progeny individuals:\t", nindpro, "\n",
    #         "Loci of adult individuals:\t",        nlociadu, "\n",
    #         "Loci of progeny individuals:\t",      nlocipro
    #     ),
    #
    #     file = "info.txt"
    # )

    # message( c("Genotypes of adult individuals...\t",   nindadu) )
    # message( c("Genotypes of progeny individuals...\t", nindpro) )
    # message( c("Loci of adult individuals...\t",        nlociadu) )
    # message( c("Loci of progeny individuals...\t",      nlocipro) )

    colnames(adults)[1] = "Sample"
    colnames(progeny)[1] = "Sample"

    adults = adults |>
        melt(
            id.vars = "Sample",
            variable.factor = FALSE, value.factor = FALSE,
            variable.name = "locus", value.name = "value"
        )

    progeny = progeny |>
        melt(
            id.vars = "Sample",
            variable.factor = FALSE, value.factor = FALSE,
            variable.name = "locus", value.name = "value"
        )

    levelsadu = adults$locus |> unique()
    levelspro = progeny$locus |> unique()

    adults$locus  = adults$locus |> factor(levels = levelsadu)
    progeny$locus = progeny$locus |> factor(levels = levelspro)

    adults  = adults[order(Sample, locus, value)]
    progeny = progeny[order(Sample, locus, value)]

    adults$Sample  = paste0("Ad. ", adults$Sample)
    progeny$Sample = paste0("Pro. ", progeny$Sample)

    adults$locus  = str_split(adults$locus, "\\.", simplify = TRUE)[,1]
    progeny$locus = str_split(progeny$locus, "\\.", simplify = TRUE)[,1]

    # adults$key  = paste0(adults$Sample, " - ", adults$locus)
    # progeny$key = paste0(progeny$Sample, " - ", progeny$locus)

    adults  = adults |> split(by = "locus")
    progeny = progeny |> split(by = c("Sample", "locus"), flatten = FALSE)

    out = list()

    for(i in names(progeny)) {

        x = lapply(progeny[[ i ]], function(y) {

            index = (adults[[ unique(y$locus) ]]$value %in% y$value )|> which()

            return(
                list(
                    "Sample" = adults[[ unique(y$locus) ]][index][[ "Sample" ]] |>
                        unique()
                )
            )
        })

        x = rbindlist(x, idcol = "locus")
        x = x[, by = Sample, .N]
        x = x[which(N == nlociadu)]

        out[[ i ]] = data.table(
            "Parents" = paste(x$Sample |> str_sort(numeric = TRUE), collapse = ", ")
        )
    }


    out = rbindlist(out, idcol = "Progeny")

    return(out)

}

globalVariables(c("Sample", "locus", "value", "N"))
