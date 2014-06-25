library(plyr)
library(reshape2)
library(ggplot2)
library(directlabels)
library(RColorBrewer)


#### Figure 1 ####

covariates <- read.table("data/covariates.tab", header=TRUE)

pal <- c("#027E47", "#c94F00", "#555093")#brewer.pal(3, "Dark2")

pl <- ggplot(covariates, aes(Level, Pr.Class., colour=Class))
pl <- pl +  geom_line() + facet_wrap(~Predictor) +
  theme_bw() + scale_x_continuous("Covariate level", breaks=c(1,3), labels=c("Minimum", "Maximum"), 
                                  limits=c(1, 3.8)) +
  scale_y_continuous("Probability of Class") + scale_color_manual(values=pal) 

direct.label(pl, list(cex=0.8, 'last.qp'))

ggsave("latex/figures/covariates.pdf", width=7, height=3)


#### Figure 2 ####

dat <- read.table("data/data1.dat.gz", header=TRUE, na.strings = ".")

dat.by <- ddply(dat, "country", function(x) colMeans(x[,c("NY_GDP_PCAP_CD", "SG_GEN_PARL_ZS", "Class1", "Class2", "Class3")], na.rm=TRUE))
names(dat.by)[4:6] <- paste("Class", 1:3)
dat.by.melt <- melt(dat.by, id.vars = c("country","NY_GDP_PCAP_CD","SG_GEN_PARL_ZS"), measure.vars = paste("Class",1:3))
dat.by.melt <- na.omit(melt(dat.by.melt, id.vars=c("country","variable","value")))
names(dat.by.melt)[2:5] <- c("Class", "Posterior", "Predictor", "Value")

levels(dat.by.melt$Class) <- c("Class 1\n(\"Materialist\")", "Class 2 \n(\"Postmaterialist\")", "Class 3\n(\"Mixed\")")

ggplot(subset(dat.by.melt, Predictor == "NY_GDP_PCAP_CD"), aes(Value, Posterior, label=country)) + 
  geom_text(cex=2.5) + theme_bw() + facet_wrap(~Class) +
  scale_y_continuous("Class posterior") +
  scale_x_continuous("Ln(GDP per capita)")
ggsave("latex/figures/gdp-posterior.pdf", width=7, height=3)

ggplot(subset(dat.by.melt, Predictor == "SG_GEN_PARL_ZS"), aes(Value, Posterior, label=country)) + 
  geom_text(cex=2.5) + theme_bw() + facet_wrap(~Class) +
  scale_y_continuous("Class posterior") +
  scale_x_continuous("% Women in Parliament")
ggsave("latex/figures/women-posterior.pdf", width=7, height=3)



#### Figure 3 ####

library(rworldmap)
sPDF <- joinCountryData2Map(dat.by, joinCode = "ISO3", nameJoinColumn = "country")
pdf("latex/figures/maps.pdf", width=6.5, height=2)
par(mai=c(0,0.01,0.3,0.01),xaxs="i",yaxs="i",mfrow=c(1,3))
mapit <- function(nm)
  mapCountryData(sPDF, nameColumnToPlot=nm, catMethod=seq(0,0.85,length=100), 
                 #colourPalette="white2Black", 
                 aspect="variable",
                  addLegend=FALSE)
mapit("Class 1")
mapit("Class 2")
mapit("Class 3")
dev.off()
