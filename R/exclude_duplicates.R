#' Report duplicates
#'
#' @param parents a data.frame
#' @param adults a data.frame
#' @param progeny a data.frame
#'
#' @return a data.frame
#' @export
#'
#' @importFrom stringr str_squish
#' @importFrom stringr str_detect
#' @importFrom stringr str_order
#'
#' @importFrom data.table :=
#' @importFrom data.table .SD
#'
#' @importFrom utils head
#'

exclude_duplicates <- function(parents, adults = NULL, progeny = NULL) {

    if(!is.null(adults)) {

        # adults = adults[, by = Grouping, newName := head(.SD, 1)[["Sample"]]]

        parents$`Parents (no duplicates)` = parents$Parents |>
            str_split("\\,") |>
            lapply(str_squish) |>
            lapply(function(x) {

                index = match(x, adults$Sample)

                out = ifelse(is.na(index), NA, adults[index][["Sample"]])

                out[which(!is.na(out))]

            }) |>

            lapply(unique) |>
            lapply(paste, collapse = ", ") |>
            unlist()

        parents$`No. of parents` = parents$`Parents (no duplicates)` |>
            str_split("\\,") |>
            lapply(str_squish) |>
            lapply(str_detect, "Ad") |>
            lapply(sum) |>
            unlist()
    }

    if(!is.null(progeny)) {

        index = match(parents$Progeny, progeny$Sample)

        parents$`Progeny (clustering)` = progeny[index][["Grouping"]]

        parents = parents[str_order(parents$`Progeny (clustering)`, numeric = TRUE)]
    }

    return(parents)
}

globalVariables(c("Grouping", "Sample"))
