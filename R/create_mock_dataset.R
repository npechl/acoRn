




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

#' Title
#'
#' @param info mock parents, as generated from `create_mock_parents` function
#' @param fparents number of female parents
#' @param mparents number of male parents
#' @param prog number of progeny??
#'
#' @return a data table
#' @export
#'
#' @importFrom data.table .N
#' @importFrom data.table data.table
#'
#' @importFrom stringr str_split
#'
create_mock_progeny <- function(info, fparents, mparents, prog) {

    # Size of parents dataset
    nind  <- nrow(info)
    nloci <- ncol(info) - 1

    # cat("The parents dataset contains", nind, "individuals and", nloci, "loci.", "\n")
    #
    # cat("Number of female parents:", fparents, "\n")
    # cat("Number of male parents:", mparents, "\n")
    # cat("Number of progeny produced:", prog, "\n")

    # define datasets with female and male parents for this mating season
    f1 <- info[sample(.N, fparents, replace = FALSE)]
    m1 <- info[sample(.N, mparents, replace = FALSE)]

    # Creating *prog* random mating events (pairs of trees).
    # Each mating event should result in one offspring.
    # Participating parents will be randomly chosen from
    # the defined parent datasets respectively

    f <- f1[sample(.N, prog, replace = TRUE)]
    m <- m1[sample(.N, prog, replace = TRUE)]

    # cat("Number of mating female parents:", length(unique(f[,1])), "\n")
    # cat("Number of mating male parents:", length(unique(m[,1])), "\n")

    # mating_events
    # mating_combinations <- table(f$tree_id, m$tree_id)

    # mating_combinations

    # For each mating event, one multilocus gamete must be
    # produced from each parent. With nloci loci, there are 2^nloci
    # possible combinations for each gamete to occure. From each locus,
    # one of the two gametes will be randomly selected.

    progeny = f

    for(i in seq_len(nloci)) {

        fgametes <- f[[i + 1]] |> str_split("\\/") |> lapply(sample, 1) |> unlist()
        mgametes <- m[[i + 1]] |> str_split("\\/") |> lapply(sample, 1) |> unlist()

        progeny[[i + 1]] <- paste0(fgametes, "/", mgametes)

    }

    progeny$tree_id = paste0("tree", seq_len(prog))

    return(progeny)


}


globalVariables(c(".", "tree_id", "marker_family", "variant"))

