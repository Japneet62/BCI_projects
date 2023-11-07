#############################################################################
# Seminar: Analysis Methods with R  - Winter Term 2019-2020 - Session 1.02
# - Graphical representation of data
#############################################################################

#####################################
# R packages for today
#####################################
#install.packages("Amelia")
#install.packages("mlbench")
#install.packages("rgl")
#install.packages("MASS")
#install.packages("corrplot")
#install.packages("psych")


#####################################
# Define working folder
#####################################

pfad <- "D:/Working in Oldenburg/Teaching/seminar_analysisR_WT_1920/Session2/Data_and_scripts"
setwd(pfad)

#####################################
# Data import
#####################################

Data <- read.table("Data_seminar.txt", header=TRUE, sep="\t", dec=".")
dat <- Data[, c("subject","sex", "age", "WMf", "WMn", "WMv", "gff", "e4")]
head(dat)


#####################################
# Histogram
#####################################

hist(dat$age)
hist(dat$gff)

#-------------------------------------------------------------------
# draw a figure with a group of histograms and save as .png file
#-------------------------------------------------------------------

png("1Histogram.png") #establish a blank .png graphic device, you can also use "bmp","jpec" and "tiff"
par(mfrow=c(2,3)) # Based on the vector mfrow/mfcol=c(nr,nc) in par(), subsequent figures will be drawn in an nr-by-nc array
                  # on the device by columns(mfcol) or rows (mfrow), respectively

for(i in 3:7) {   # draw a group of figures in "for" Loop            
  hist(dat[,i], main=names(dat)[i])  # choose the variable from column 3 to 7 in the dataset 
}

dev.off() 


#####################################
# Density plot
#####################################

png("2DensityPlot.png")
par(mfrow=c(2,3))
for(i in 3:7) {
  plot(density(dat[,i]), main=names(dat)[i])
}
dev.off()


#####################################
# Box and whisker plots
#####################################

png("3BoxWhiskerPlot.png")
par(mfrow=c(2,3))
for(i in 3:7) {
  boxplot(dat[,i], main=names(dat)[i])
}
dev.off()


#####################################
# Barplot
#####################################
#par(mfrow=c(1,1))

#simple barplot
counts <- table(Data$genotype) # build a table of counts for the genotype variable
barplot(counts, main="genotype", xlab="APOE genotypes") # the input of barchart should be a vector or matrix

# bar plots
png("4Barplot.png")
par(mfrow=c(1,2))

for(i in c(2,8)) {
  counts <- table(dat[,i])
  name <- names(dat)[i]
  barplot(counts, main=name)
}
dev.off()


#####################################
# missing plot
#####################################
#install.packages("Amelia")
#install.packages("mlbench")
library(Amelia)
library(mlbench)


png("5Mismap.png")
#we can visually check where in our variables we have missing data by using missmap().
missmap(dat, col=c("black", "grey"), legend=FALSE)
dev.off()

#test the function of missmap - from left to right, order 
dat2<-dat
dat2$age[2]<-NA
dat2$age[23]<-NA
dat2$age[157]<-NA
missmap(dat2, col=c("black", "grey"), legend=FALSE)


##############################
# Bivariate plots
##############################

library(car)
#------------------
# Scatterplot
#------------------

png("6Scatterplot.png")
scatterplot(gff ~ WMf, data=dat) 
dev.off()

#parameter setting
scatterplot(gff ~ WMf, data=dat, boxplots=F, grid=F,smooth=F)

#---------------
# 3D Scatterplot
#---------------

#The scatter3d() function uses the "rgl" package to draw 3D scatterplots
#install.packages("rgl")
library(rgl) 
scatter3d(gff ~ WMf + age, data=dat) # 3D scatterplots with various regression surfaces

# Change point colors and remove the regression surface
scatter3d(gff ~ WMf + age, data = dat, point.col = "blue", surface=FALSE)

#----------------------------------
### two dimensional kernel density
#----------------------------------

#install.packages("MASS")
library(MASS)

png("7TwoDimensionalDensity.png")

WM2v <- kde2d(dat$WMn, dat$WMv, n = 255) #kde()- Two-Dimensional Kernel Density Estimation
persp(WM2v, phi = 45, theta = 30, shade = .1, border = NA,  # phi and theta are defining the viewing direction
      xlab = "WMn", ylab = "WMv", zlab = "Density") # draws perspective plots of a surface over the x--y plane

dev.off()

png("8TwoDimensionalDensity2.png")
AgeWM <- kde2d(dat$age, dat$WMn, n = 255)
persp(AgeWM, phi = 45, theta = 30, shade = .1, border = NA,
      xlab = "Age", ylab = "WMn", zlab = "Density")
dev.off()

##############################
# Multivariate plots
##############################


#-----------------------------
# Two dimensional scatterplot
#-----------------------------
library(car)

# 2 dimensional scatterplot
png("9GroupedScatter.png")
scatterplot(gff ~ WMf | sex, data=dat)
dev.off()

png("10GroupedScatter2.png")
scatterplot(gff ~ WMf | e4, data=dat)
dev.off()

#-----------------------------
# Correlation plot
#-----------------------------
#install.packages("corrplot")

library(corrplot)
# calculate correlations

correlations <- cor(dat[,2:8])
# Or
correlations <- cor(na.exclude(dat[,2:8]))# remove NA values

# create correlation plot
png("11Corrplot.png")
corrplot(correlations, method="circle")
dev.off()

#-----------------------------
# Scatterplot matrix
#-----------------------------

dat1 <- dat[,2:8]
head(dat1)
png("12ScatterMatrix.png")
pairs(dat1)
dev.off()

#-----------------------------
# Scatterplot matrix by class
#-----------------------------

png("13ScatterMatrixClass.png")
pairs(sex~., data=dat1, col=dat1$sex) #all other variables will give a response according to sex; col - default color
dev.off()

#-----------------------------
# violin plot
#-----------------------------

#install.packages("psych")
library(psych)

dat2<-dat1[, c("WMf", "gff" )]
png("14ViolinbyGroup.png")
violinBy(dat2,grp=dat1$e4,ylab="Observed",xlab="",main="Density plot") 
dev.off()

