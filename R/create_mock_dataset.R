




#' Title
#'
#' @param nmarkers number of markers
#' @param ntrees number of trees
#' @param nvariants number of trees
#' @param maf minimum allele frequency
#'
#' @importFrom stringi stri_rand_strings
#'
#' @importFrom data.table data.table
#' @importFrom data.table dcast
#'
#' @importFrom stringr str_to_upper
#' @importFrom stringr str_split_i
#' @importFrom stringr str_sort
#'
#'
#' @return a list
#' @export
#'
create_mock_parents <- function(nmarkers = 10, ntrees = 100, nvariants = 4, maf = NULL) {


    mock_markers = nmarkers |> seq_len() |> lapply(function(q) {

        variants = nvariants |>
            seq_len() |>
            sample(1) |>
            stri_rand_strings(5) |>
            str_to_upper()

        n = variants |> length()

        if(is.null(maf)) {

            prob = seq(0.001, 1, by = .001) |> sample(n)

            prob = prob / sum(prob)

        } else {

            prob = seq(0.001, maf, by = .001) |> sample(n - 1)

            prob = c(1 - sum(prob), prob)

        }

        out = data.table(
            "variant" = variants,
            "prob"    = prob
        )

        return(out)

    })

    names(mock_markers) = paste0("marker", seq_len(nmarkers))

    mock = data.table(
        "tree_id" = paste0("tree", ntrees |> seq_len() |> rep(each = 2 * nmarkers)),
        "marker_id" = paste0("marker", nmarkers |> seq_len() |> rep(each = 2) |> rep(ntrees) ),
        "variant" = (ntrees * nmarkers * 2) |> character()
    )

    mock[seq(2, nrow(mock), by = 2)]$marker_id = paste0(mock[seq(2, nrow(mock), by = 2)]$marker_id, "_b")

    mock$marker_family = mock$marker_id |> str_split_i("_", 1)


    mock = mock |>
        split(mock$marker_family) |>
        lapply(function(q) {

            marker = q$marker_family |> unique()

            qp = mock_markers[[ marker ]]

            q$variant = sample(x = qp$variant, prob = qp$prob, size = nrow(q), replace = TRUE)

            return(q)
        }) |>

        rbindlist()

    mock$tree_id = mock$tree_id |> factor(levels = mock$tree_id |> unique() |> str_sort(numeric = TRUE))
    mock$marker_family = mock$marker_family |> factor(levels = mock$marker_family |> unique() |> str_sort(numeric = TRUE))

    mock = mock[, by = .(tree_id, marker_family), .(variant = variant |> paste(collapse = "/"))]

    mock = mock |> dcast(tree_id ~ marker_family, value.var = "variant")
    mock_markers = mock_markers |> rbindlist(idcol = "marker_id")

    return(list(mock, mock_markers))

}






