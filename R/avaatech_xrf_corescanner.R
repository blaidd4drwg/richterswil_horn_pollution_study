#' Parse legacy Avaatech XRF-CS WinAXIL csv files
#'
#' This function tries to validate and parse Avaatech XRF-Corescanner files created with WinAXIL (and converted to csv files).
#'
#' The function expects the following fields and conditions in the csv file:
#' * The first field in the file must be called `FileName`. The CoreID, Voltage and Current are extracted from that field.
#' * The sample depth must be in a field called `Sample_ID`.
#' * The XRF data must be in a wide form like `Ag_Area ;Ag_ DArea ;Ag_ ChiSqr;`. Element and Parameter need to be separated with an underline.
#'
#' @param avaa_winaxil_csv_path Absolute or relative path to the csv file
#' @param cut_off_set Should the offset at the top of the measurement be substracted (default is TRUE)? The offset cause by material that was used to close the sediment core will be substracted.
#' @param delim What csv file delimiter should be used (default is ";" for csv files exported from Microsoft Excel)?
#' @param show_col_types Show column types that were initially guessed by readr::read_delim() when reading the csv file. May be useful for debugging (default is FALSE)
#' @param xrf_data_start Number of the column in which the XRF data starts (e.g. `Ag_Area`).
#' @param ... Further optional arguments that are passed on to read_delim()
#'
#' @return A dataframe/tibble containing tidy Avaatech XRF-CS data
#' @export
#'
#'
parse_avaatech_winaxil_csv <-
  function(avaa_winaxil_csv_path,
           cut_off_set = TRUE,
           delim = ";",
           show_col_types = FALSE,
           xrf_data_start = 8,
           ...) {
    filename <- basename(avaa_winaxil_csv_path)
    avaa_winaxil_csv <-
      read_delim(
        avaa_winaxil_csv_path,
        delim = delim,
        trim_ws = TRUE,
        show_col_types = show_col_types,
        ...
      )
    safe_validate <- safely(validate_avaa_winaxil_csv)

    filename_field_tibble <-
      safe_validate(avaa_winaxil_csv, xrf_data_start)
    
    if (is.null(filename_field_tibble$error)) {
      filename_field_tibble <- filename_field_tibble$result
    } else {
      stop(
        paste0(
          "Error encountered in ",
          filename,
          "; Skipping file. ",
          filename_field_tibble$error$message
        )
      )
    }
    
    if (cut_off_set) {
      avaa_winaxil_csv[["Sample_ID"]] <-
        avaa_winaxil_csv[["Sample_ID"]] - min(avaa_winaxil_csv[["Sample_ID"]])
    }
    
    df_cols <- ncol(avaa_winaxil_csv)
    avaa_winaxil_csv <-
      bind_cols(filename_field_tibble, avaa_winaxil_csv)
    avaa_winaxil_csv <-
      pivot_longer(
        avaa_winaxil_csv,
        (!!xrf_data_start + 3):last_col(),
        names_to = c("Element", "Measure") ,
        values_to = "Value",
        names_sep = "[_\\W]+"
      )
    
    avaa_winaxil_csv <-
      select(
        avaa_winaxil_csv,
        CoreID = core_id,
        Voltage = voltage,
        Current = current,
        Depth = Sample_ID,
        Element:Value
      )
    
    avaa_winaxil_csv <-
      mutate(
        avaa_winaxil_csv,
        CoreID = as.character(CoreID),
        Voltage = as.numeric(str_extract(Voltage, "\\d+")),
        Current = as.numeric(str_extract(Current, "\\d+")),
        Depth = as.numeric(Depth)
      )
    
    avaa_winaxil_csv <-
      pivot_wider(avaa_winaxil_csv,
                  names_from = "Measure",
                  values_from = "Value")
    
    avaa_winaxil_csv
  }

validate_avaa_winaxil_csv <- function(data, xrf_pos) {
  stopifnot({
    "File validation failed: Incorrect file type or csv file not read correctly (there is only one column). Make sure the correct delimiter is set." = ncol(data) > 1
    "File validation failed: Expected 'FileName' field in first column but not found." = names(data[1]) == "FileName"
    "File validation failed: Expected 'Sample_ID' column in file but not found." = "Sample_ID" %in% names(data)
    "File validation failed: 'Sample_ID' column (depth) not numeric, check input file." = is.numeric(data[["Sample_ID"]])
    "File validation failed: 'Sample_ID' column ambiguous: Possibly duplicate rows/measurements in file or missing values." = !any(duplicated(data[["Sample_ID"]]))
    "File validation failed: Expected numeric XRF element data" = is.numeric(data[[xrf_pos]])
  })
  
  tryCatch(
    filename_field_splits <- str_split(data$FileName, "\\s+"),
    error = function(e)
      stop("Unable to split 'FileName' column into parts.")
  )
  nr_field_splits <- unique(map(filename_field_splits, length))
  
  stopifnot("File validation failed: 'FileName' column structure unknown or inconsistent." = nr_field_splits == 13L)
  
  core_id <-
    map(str_extract_all(data$FileName, "(?<=\\\\)(\\S+)"), last)
  stopifnot(
    "File validation failed: Different CoreIDs found in csv." = !is_empty(unique(core_id)) &&
      length(unique(core_id)) == 1
  )
  voltage <- map(filename_field_splits, str_subset, "(^[0-9]+)kV$")
  current <- map(filename_field_splits, str_subset, "(^[0-9]+)uA$")
  filename_field_tibble <- tibble(core_id, voltage, current)
  
  filename_field_tibble
}
