
##### 1) determines if something is an attatchment or not #####

is_attachment_col <- function(col) {
  all(
    map_lgl(col, function(z) {
      is.null(z) ||
        (is.list(z) && !is.null(z$filename))
    })
  )
}



##### 2) Save attatchments to the /2. Data/attatchments folder #####

get_airtable_attachments <- function(attachments, attachments_dir) {
  for (i in seq_len(nrow(attachments))) {
    slug <- stringi::stri_extract_first_regex(attachments$url[i], "(?<=\\.attachments\\/).*$")
    download_dest <- file.path(attachments_dir, slug)
    if (!file.exists(download_dest) || file.info(download_dest)$size != attachments$size[i]) {
      if (!dir.exists(dirname(download_dest))) dir.create(dirname(download_dest), recursive = TRUE)
      download.file(attachments$url[i], destfile = download_dest, quiet = TRUE) # Do this with curl::multi_run?
    }
  }
}

###### 3) Collapse complex structures into a useable dataframe ######

write_airtable_to_csv <- function(df, filename, attachments_dir = NULL, ...) {
  # Convert any columns of attachments to comma-delimited URLs
  df <- mutate_if(df, is_attachment_col, function(x) {
    map_chr(x, function(z) {
      if (is.null(z)) {
        return(NA_character_)
      } else {
        if (!is.null(attachments_dir)) {
          get_airtable_attachments(z, attachments_dir)
        }
        return(paste(paste0(z$filename, " (", z$url, ")"), collapse = ","))
      }
    })
  })

  df <- mutate_if(df, is.list, function(x) {
    map_chr(x, function(z) {
      paste(z, collapse = ",")})
  })
  write_csv(df, filename, ...)
}



# 4) Deal with airtable only being able to retreive 100 rows at a time

select_all1 <- function (base, table_name, record_id = NULL, fields = NULL, filterByFormula = NULL, 
                         maxRecord = NULL, sort = NULL, view = NULL, pageSize = NULL) {
  retmaster <- NULL
  ret_offset = NULL
  offset_list <- c("go")
  i<-1
  
  while (offset_list[i]=="go")({
    ret <- air_select(base, table_name, record_id, fields, 
                      filterByFormula, maxRecord, sort, view, pageSize, 
                      ret_offset, combined_result = TRUE)
    ret_offset <- get_offset(ret)
    retmaster <- bind_rows(retmaster, ret)
    offset_add <- ifelse(is.null(ret_offset)==TRUE, "stop", "go")
    offset_list <- c(offset_list, offset_add)
    i <- length(offset_list)
  })
  
  retmaster[retmaster=="NA"] <- NA
  return(retmaster)
  
}



#### 5) Save dataframes to the /2. Data folder as csv files ####

save_airtable <- function(AT_BASE, tables, path = ".") {
  
  for (i in 1:length(tables)) {

    df <- select_all1(AT_BASE, paste(tables[i], sep = ""))
    dfnames <- colnames(df)
    outfile <- file.path(path, paste0(tables[i], ".csv"))
    
    #unlist columns
    for (m in 1:length(dfnames)) {
      
      df[[paste(dfnames[m])]] <- as.character(df[[paste(dfnames[m])]])
      
    }
    
    write.csv(df, outfile)
    
  }
}



