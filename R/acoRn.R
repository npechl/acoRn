


#' acoRn workflow
#'
#' @param adults a data.frame
#' @param progeny a data.frame
#'
#' @return a data.frame
#' @export
#'
acoRn <- function(adults, progeny) {

    adults  <- adults |> setDT()
    progeny <- progeny |> setDT()

    # clean input dataset -------------------------


    adults <- clean_input(adults)
    progeny <- clean_input(progeny)


    # identifying duplicates ---------------------------

    message("Adults duplicates...\t", appendLF = FALSE)
    adults_dupl <- identify_duplicates(adults, abbr = "Ad. ")
    message("OK")

    message("Progeny duplicates...\t", appendLF = FALSE)
    progeny_dupl <- identify_duplicates(progeny, abbr = "Pro. ")
    message("OK")

    # find parents ------------------------------

    message("Find parents...\t", appendLF = FALSE)
    out <- find_parents(adults, progeny)
    message("OK")

    # report duplicates ------------------------------

    message("Report duplicates...\t", appendLF = FALSE)
    out <- exclude_duplicates(out, adults_dupl, progeny_dupl)
    message("OK")

    message("done!")

    return(out)
}
