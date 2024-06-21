


#' Title
#'
#' @param genotypes data.table
#'
#' @return data.table
#' @export
#'
#' @importFrom data.table tstrsplit
#' @importFrom data.table setDT
#' @importFrom data.table as.data.table
clean_input <- function(genotypes) {

    o <- genotypes |>
        lapply(function(q) q |> tstrsplit(split = "\\/", names = FALSE) |> setDT()) |>
        lapply(function(q) {colnames(q) <- ncol(q) |> seq_len() |> as.character(); return(q) }) |>
        as.data.table()

    colnames(o)[1] = "tree_id"

    return(o)



}
