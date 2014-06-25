

get.inglehart <- function(wvs, vnames, year, country_codebook) {
  stopifnot(c("set_2_choice_1", "set_2_choice_2", "country") %in% names(vnames))
  if("set_1_choice_1" %in% names(vnames)) stopifnot("set_1_choice_2" %in% names(vnames))
  if("set_3_choice_1" %in% names(vnames)) stopifnot("set_3_choice_2" %in% names(vnames))
  
  inglehart <- wvs[,vnames]
  names(inglehart) <- names(vnames)
  
  inglehart$year <- year
  
  inglehart[inglehart < 0] <- NA
  inglehart$country <- as.factor(country_codebook[as.character(inglehart$country)])

  for(iset in 1:3) {
    choice_names <- paste("set",iset,"choice",1:2,sep="_")
    if(!all(choice_names %in% names(inglehart))) next
    cat(sprintf("Found set %d.\n", iset))
    valid_choices <- is.na(inglehart[,choice_names[1]]) | 
                    is.na(inglehart[,choice_names[2]]) | 
                    inglehart[,choice_names[1]] != inglehart[,choice_names[2]]
    inglehart <- inglehart[valid_choices,]
    
    cat(sprintf("Impossible choices removed (set %d): %d (%3.2f pct)\n", iset, sum(!valid_choices), 100*mean(!valid_choices)))      
  }
  # Order by country then choices
  names_choices <- names(inglehart)[grep("^set_", names(inglehart))]
  ordering <- eval(parse(text=sprintf("order(country, %s)", paste(names_choices, collapse=", "))), inglehart)
  inglehart <- inglehart[ordering,]

  # Remove all-missing rows
  all_missing <- apply(inglehart[, grep("^set_", names(inglehart))], 1, function(x) all(is.na(x)))
  inglehart <- inglehart[!all_missing, ]
  cat(sprintf("All-missing rows removed: %d (%3.1f pct)\n", sum(all_missing), 100*mean(all_missing)))
  
  inglehart
}

get.codebook.wave <- function(country_codebook, country_var) {
  dset <- subset(country_codebook, ISO.3166.1.Number %in% levels(as.factor(country_var)))
  iso.number <- dset$ISO.3166.1.Number
  select.first.of.dups <- c(TRUE, iso.number[-1] != iso.number[-length(iso.number)])
  dset <- dset[select.first.of.dups, ]
  
  codebook_wvs2 <- as.character(dset$ISO.3166.1.3.Letter.Code)
  names(codebook_wvs2) <- as.character(dset$ISO.3166.1.Number)
  
  codebook_wvs2
}

make.patterns <- function(dat) {
  pats <- apply(dat, 1, paste, collapse="-")
  pats.tab <- table(pats)
  
  pats.df <- matrix(NA, ncol(dat), length(pats.tab))
  pats.df[] <- unlist(strsplit(names(pats.tab), "-"))
  pats.df <- t(pats.df)
  pats.df[pats.df=="NA"] <- NA
  
  pats.df <- as.data.frame(pats.df)
  names(pats.df) <- names(dat)
  
  pats.df$freq <- as.vector(pats.tab)
  
  pats.df
  
}