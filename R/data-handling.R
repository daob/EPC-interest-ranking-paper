library(foreign)
library(reshape2)
library(plyr)
library(data.table)
library(WDI) # For World Bank data


setwd("~/Dropbox/Jeroen-Invariance/Data/WVS/Reproduction/")

source("R/data-handling-functions.R")

#http://datahub.io/dataset/iso-3166-1-alpha-2-country-codes
#   changed 1 code for Turkish Cypros
country_codebook <- read.csv("data/iso_3166_2_countries.csv")


#### Read WVS Wave 6 ####

load("data/WV6_Data_rdata_v_2014_06_04.rdata.gz")
wvs_6 <- WV6_Data_spss_v_2014_06_04

vnames <- c(paste("V", 60:65, sep=""), "V2")
names(vnames) <- c("set_1_choice_1", "set_1_choice_2", 
                   "set_2_choice_1", "set_2_choice_2", 
                   "set_3_choice_1", "set_3_choice_2", 
                   "country")

country_codebook_wvs6 <- get.codebook.wave(country_codebook, wvs_6$V2)

inglehart.wvs6 <- get.inglehart(wvs_6, vnames=vnames, 
                                year=2010, country_codebook=country_codebook_wvs6)

### Create long data ###

inglehart.wvs6<- subset(inglehart.wvs6, !is.na(country))
inglehart.wvs6$id <- 1:nrow(inglehart.wvs6)

id_vars <- c("id", "country", "year")

long <- melt(inglehart.wvs6, id.vars=id_vars)
long <- long[order(long$country, long$id), ]

long$set <- gsub("^set_(\\d).+", "\\1", long$variable)

write.table(long[,-4], file="inputs/inglehart_wvs6_long.rsp", sep="\t", quote=FALSE,
            col.names=TRUE, row.names=FALSE, na=".")


### Add World Bank indicators and write new file ###

long$country <- as.character(long$country)
long_dt <- data.table(long[,-4], key=c("country"))

country_indicators <- c('NY.GDP.PCAP.CD','SL.IND.EMPL.ZS','SL.SRV.EMPL.ZS','SG.GEN.PARL.ZS')
world_bank <- WDI(indicator=country_indicators, start=2010, end=2010, extra = TRUE)[,-2]
names(world_bank)[names(world_bank) == "iso3c"] <- "country"
world_bank$NY.GDP.PCAP.CD <- log(world_bank$NY.GDP.PCAP.CD)
names(world_bank) <- gsub("\\.","_",names(world_bank))

world_bank_dt <- data.table(world_bank[,c('country', gsub("\\.","_",country_indicators))], key='country')

write.table(long_dt[world_bank_dt, nomatch=0], file="inputs/inglehart_wvs6_long_gdp.rsp", 
            sep="\t", quote=FALSE,
            col.names=TRUE, row.names=FALSE, na=".")
