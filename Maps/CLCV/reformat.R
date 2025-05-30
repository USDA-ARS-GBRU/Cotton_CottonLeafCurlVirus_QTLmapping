# gtbil
# may 30 2025


# Gemini 2.5 Flash Function to Fix CHR Names ----------------------------------------------------------------------

#' @title Add Cumulative Count to Strings
#' @description This function takes a character vector and appends a period
#'   followed by a cumulative count of how many times that specific string
#'   has appeared up to that point in the vector.
#' @param input_vector A character vector.
#' @return A character vector with each string followed by its cumulative count.
#' @examples
#' add_cumulative_count(c("A01", "A01", "A02", "A02", "A03"))
#' # Expected output: "A01.1", "A01.2", "A02.1", "A02.2", "A03.1"
#'
#' add_cumulative_count(c("apple", "banana", "apple", "orange", "banana", "apple"))
#' # Expected output: "apple.1", "banana.1", "apple.2", "orange.1", "banana.2", "apple.3"
add_cumulative_count <- function(input_vector) {
  # Initialize an empty vector to store the results
  output_vector <- character(length(input_vector))
  
  # Initialize an empty list or hash map to store current counts for each string
  # Using a named list for simplicity, where names are the strings
  # and values are their current cumulative counts.
  current_counts <- list()
  
  # Loop through each element of the input vector
  for (i in seq_along(input_vector)) {
    current_string <- input_vector[i]
    
    # Check if the string has been seen before
    if (current_string %in% names(current_counts)) {
      # If seen, increment its count
      current_counts[[current_string]] <- current_counts[[current_string]] + 1
    } else {
      # If not seen, initialize its count to 1
      current_counts[[current_string]] <- 1
    }
    
    # Construct the output string for the current element
    output_vector[i] <- paste0(current_string, ".", current_counts[[current_string]])
  }
  
  return(output_vector)
}


# Get chromosome renaming -----------------------------------------------------------------------------------------

chrSZ <- read.table("https://gist.github.com/gtbil/380bd53023948bd90d7e8c1837a9e917/raw", header = TRUE, sep = "\t")


# Set ignores -----------------------------------------------------------------------------------------------------

CHR <- NULL
cM <- NULL
POS <- NULL
SNP <- NULL
LG <- NULL

# Read in all the JMAPS and TXT -----------------------------------------------------------------------------------

pops          <- list.files(path = ".", pattern = "*.jmap")
pops.lgtochrs <- list.files(path = ".", pattern = "*.txt")

names(pops) <- names(pops.lgtochrs) <- substr(pops, 1, nchar(pops) - 5)

lg.to.chr.lst <- lapply(pops.lgtochrs,
                        \(x) read.table(x, header = TRUE, sep = "\t") |>
                          dplyr::left_join(chrSZ, by = "CHR_OLD") |>
                          dplyr::select(LG, CHR) |>
                          dplyr::mutate(CHR = add_cumulative_count(CHR)))

maps <- lapply(pops,
              \(x) read.table(x, header = FALSE, sep = "", fill = TRUE,
                              col.names = c("SNP", "cM"))) |>
  lapply(dplyr::mutate, LG = ifelse(SNP == "group", cM, NA_integer_), .before = 1) |>
  lapply(tidyr::fill, LG, .direction = "down") |>
  lapply(dplyr::filter, SNP != "group") |>
  purrr::map2(lg.to.chr.lst,
              \(x, y) dplyr::left_join(x, y, by = "LG")) |>
  lapply(dplyr::select, CHR, SNP, cM) |>
  lapply(dplyr::arrange, CHR, cM, SNP)  |>
  # add the POS column to make it a .map file
  lapply(dplyr::mutate, POS = 0) |>
  # add the "#" needed to make the first row a comment
  lapply(dplyr::rename, "#CHR" = "CHR")

lapply(names(maps),
       \(x) write.table(maps[[x]],
                        file = paste0("../lg_", x, ".map"),
                        sep = "\t",
                        row.names = FALSE,
                        col.names = TRUE,
                        quote = FALSE))

  
