# import dataset from local file
library('data.table')
library('e1070')
library('graphics')

#df <- read.csv('recipe.csv', header=TRUE)
df<-fread("recipe.csv", header=TRUE)

# summary of dataset
summary(df)

# structure of dataframe
str(df)

# first couple of observations of dataframe
head(df)

# converting columns to appropriate data types
df$BeerID <- as.factor(df$BeerID)
df$Name <- as.factor(df$Name)
df$URL <- as.factor(df$URL)
df$Style <- as.factor(df$Style)
df$StyleID <- as.factor(df$StyleID)
df$UserId <- as.factor(df$UserId)
df$PrimingMethod <- as.factor(df$PrimingMethod)
df$PrimingAmount <- as.factor(df$PrimingAmount)
df$BrewMethod <- as.factor(df$BrewMethod)
df$SugarScale <- as.factor(df$SugarScale)
df$PrimaryTemp <- as.numeric(df$PrimaryTemp)
df$MashThickness <- as.numeric(df$MashThickness)
df$BoilGravity <- as.numeric(df$BoilGravity)
df$PitchRate <- as.factor(df$PitchRate)
df$BoilTime <- as.numeric(df$BoilTime)
#df$BoilTime <- as.factor(df$BoilTime)
#df$PitchRate <- as.numeric(df$PitchRate)

# summary of new dataframe
summary(df)
str(df)
# summary of the most common beer styles 
summary(df$Style)

# creating subset of drinkable beer
df1 = subset(df, ABV>3.2 & ABV<14)
df2 = subset(df1, FG>.9 & FG<1.5)
df3 = subset(df2, OG>.9 & OG<1.5)
df4 = subset(df3, IBU>8 & IBU<120)

# create a copy of subset
dfs <- df4

# summary of drinkable beer recipe dataframe
summary(dfs)

# import ggplot2
library(ggplot2)

# scatterplot using ggplot2 of "abv", "ibu", and "color
abv_ibu_gg <- ggplot(dfs, aes(x=ABV, y=IBU, color=Color))
+ geom_point() + labs(title="Scatterplot", x="ABV", y="IBU") 
print(abv_ibu_gg)

# understanding "PrimingMethod" feature 
dfs$PrimingMethod[0:300]

# understanding "PrimingAmount" feature
dfs$PrimingAmount[0:300]

# ABV density distribution curve
abv_density <- qplot(ABV, data=dfs, geom="density", alpha=I(.5), 
                     main="ABV Density Distribution", xlab="ABV", ylab="Density")
print(abv_density)

# IBU desity distribution curve
ibu_density <- qplot(IBU, data=dfs, geom="density", alpha=I(.5), 
                     main="IBU Density Distribution", xlab="IBU", ylab="Density")
print(ibu_density)

# Color density distribution curve
color_density <- qplot(Color, data=dfs, geom="density", alpha=I(.5), 
                       main="Color Density Distribution", xlab="Color", ylab="Density")
print(color_density)

# Efficiency density distribution curve
efficiency_density <- qplot(Efficiency, data=dfs, geom="density", alpha=I(.5), 
                            main="Efficiency Density Distribution", xlab="Efficiency", ylab="Density")
print(efficiency_density)

# BoilTime histogram
boiltime_hist <- hist(dfs$BoilTime, col="red", main="BoilTime(Histogram)", xlab="BoilTime")

# qplot of "FG" ,"OG", and "IBU"
og_fg_qplot <- qplot(FG, OG, color=IBU, data=dfs)
print(og_fg_qplot)

# qplot of "IBU", "BoilTime", and "BrewMethod"
boiltime_ibu_qplot <- qplot(IBU, BoilTime, color=BrewMethod, data=dfs)
print(boiltime_ibu_qplot)

# eliminating several features columns that are not needed
beer <- dfs[,c(2:16, 18:20)]
summary(beer)
brew_allgrain <- subset(beer, BrewMethod=="All Grain")
summary(brew_allgrain)
brew_biab <- subset(beer, BrewMethod=="BIAB")
summary(brew_biab)
brew_extract <- subset(beer, BrewMethod=="extract")
summary(brew_extract)
brew_partial <- subset(beer, BrewMethod=="Partial Mash")
summary(brew_partial)
prim_temp_qplot <- qplot(Efficiency, PrimaryTemp , color=BrewMethod, data=beer)
print(prim_temp_qplot)

# Mash density distribution curve
mash_density <- qplot(MashThickness, data=brew_allgrain, geom="density") + xlim(0,10)
print(mash_density)

# dataframe for numeric features only 
beer1 <- beer[,c(5:15, 17:18)]
beer1$PitchRate <- as.character(beer1$PitchRate)
beer1$PitchRate <- as.numeric(beer1$PitchRate)
summary(beer1)

# data frame matrix for na values in beer data frame
beer_x <- as.data.frame(abs(is.na(beer1)))
head(beer_x, n=5)
head(beer1, n=5)

# maxtrix for the variables with missing values
beer_y <- beer_x[which(apply(beer_x,2,sum)>0)]
cor(beer_y)

# correlation matrix for those numeric features and features with missing values
cor(beer1, y, use="pairwise.complete.obs")

# exploring missing value patterns
library('mice')
library("VIM")
md.pattern(beer)
aggr(beer, prop=FALSE, numbers=TRUE)
matrixplot(beer)

# correlation matrix for complete observations
cor(beer1, use="complete.obs")

# create another dataset of beer to do imputations and replacements of missing values
df_beer <- beer

# replace missing values of Primary Temp with "-99"
df_beer$PrimaryTemp[is.na(df_beer$PrimaryTemp)] <- -99
df_beer$PrimaryTemp[df_beer$PrimaryTemp == -17.78] <- -99

# since PitchRate is a factor convert to numeric to do replacement
df_beer$PitchRate <- as.numeric(as.character(df_beer$PitchRate))

# replace missing value of PitchRate with "-1"
df_beer$PitchRate[is.na(df_beer$PitchRate)] <- -1

# convert PitchRate back to factor
df_beer$PitchRate <- as.factor(df_beer$PitchRate)

# convert missing values of MashThickness to "-1"
df_beer$MashThickness[is.na(df_beer$MashThickness)] <- -1

# create a function that labels missing values for BoilGravity
mis <- function(t)
{
  x <- dim(length(t))
  x[which(!is.na(t))] = 1
  x[which(is.na(t))] = 0
  return(x)
}

# create binary column that denotes missing values
df_beer$M <- mis(df_beer$BoilGravity)

# simple linear function to impute missing values in BoilGravity
bg_lm <- lm(BoilGravity~OG, data=df_beer)
summary(bg_lm)

# function to impute missing values for BoilGravity using simple linear function
for(i in 1:nrow(df_beer))
{
  if(df_beer$M[i] == 0)
  {
    df_beer$BoilGravity[i] = 0.2773 + 0.7314*df_beer$OG[i]
  }
}

# check the summary of df_beer dataframe
summary(df_beer)

# remove MashThickness, M, and SIZE variable
df_beer1 <- df_beer[,c(6:14, 16:18)]
df_beer1 <- df_beer1[,c(1:5, 7:12)]

# use numeric features for kmeans
df_beer2 <- df_beer1[,c(1:8, 10:11)]
df_beer2$PitchRate <- as.character(df_beer2$PitchRate)
df_beer2$PitchRate <- as.numeric(df_beer2$PitchRate)

# create a new column called BU_GU_Ratio that tells us how balanced the beer is
BU_GU_Ratio <- ((df_beer2$IBU)/((df_beer2$OG*1000)-1000))
BU_GU_Ratio <- round(BU_GU_Ratio, 3)
df_beer2 <- cbind(df_beer2, BU_GU_Ratio)

# replace infinate values of BU_GU_Ratio with "1.001"
df_beer2$BU_GU_Ratio[is.infinite(df_beer2$BU_GU_Ratio)] <- 1.001

# print str and summary for df_beer2 dataframe
str(df_beer2)
summary(df_beer2)

# scale data for kmeans
df_beer2_z <- as.data.frame(lapply(df_beer2, scale))
summary(df_beer2_z)

# do kmeans clustering
library("cluster")

# run kmeans, k = 5
set.seed(123)
df_beer2_cluster <- kmeans(df_beer2_z, 5, nstart = 20)
df_beer2_cluster$centers
df_beer2_cluster$size

# run kmeans, k = 8
set.seed(123)
df_beer2_cluster2 <- kmeans(df_beer2_z, 8, nstart = 20)
df_beer2_cluster2$centers
df_beer2_cluster2$size

# create a dataframe with clusters
cluster_num <- df_beer2_cluster2$cluster
beer_cluster <- cbind(df_beer, cluster_num)

# set cluster column as factor
beer_cluster$cluster_num <- as.factor(beer_cluster$cluster_num)

# subsets for clusters
clust1 <- subset(beer_cluster, cluster_num==1)
clust2 <- subset(beer_cluster, cluster_num==2)
clust3 <- subset(beer_cluster, cluster_num==3)
clust4 <- subset(beer_cluster, cluster_num==4)
clust5 <- subset(beer_cluster, cluster_num==5)
clust6 <- subset(beer_cluster, cluster_num==6)
clust7 <- subset(beer_cluster, cluster_num==7)
clust8 <- subset(beer_cluster, cluster_num==8)

# export csv file with file encoding "UTF-8" and Row Names equals "False"
#write.csv(df_beer2, 'beer_cluster3.csv', fileEncoding = "UTF-8", row.names = FALSE)

# use numeric features for kmeans
df_beer3 <- df_beer2[,c(1:8, 11)]

# scale data for kmeans
df_beer3_z <- as.data.frame(lapply(df_beer3, scale))

# run kmeans, k = 6
set.seed(123)
df_beer3_cluster3 <- kmeans(df_beer3_z, 6, nstart = 20)
df_beer3_cluster3$centers
df_beer3_cluster3$size

# create a dataframe with clusters
cluster_num1 <- df_beer3_cluster3$cluster
beer_cluster1 <- cbind(df_beer, cluster_num1)
bu_gu <- df_beer3$BU_GU_Ratio
beer_cluster2 <- cbind(beer_cluster1, bu_gu)

# set cluster column as factor
beer_cluster2$cluster_num1 <- as.factor(beer_cluster2$cluster_num1)

# subsets for clusters
cluster1 <- subset(beer_cluster2, cluster_num1==1)
cluster2 <- subset(beer_cluster2, cluster_num1==2)
cluster3 <- subset(beer_cluster2, cluster_num1==3)
cluster4 <- subset(beer_cluster2, cluster_num1==4)
cluster5 <- subset(beer_cluster2, cluster_num1==5)
cluster6 <- subset(beer_cluster2, cluster_num1==6)

# visualizations for clusters
qplot(beer_cluster2$ABV, beer_cluster2$IBU, col=beer_cluster2$cluster_num1, 
      xlab = 'ABV', ylab = 'IBU', main = 'ABV vs IBU by Clusters')
qplot(beer_cluster2$bu_gu, beer_cluster2$Color, col=beer_cluster2$cluster_num1,
      xlab = 'BU/GU Ratio', ylab = 'Color', main = 'BU/GU Ratio vs Color by Clustetrs')
qplot(beer_cluster2$Efficiency, beer_cluster2$Color, col=beer_cluster2$cluster_num1,
      xlab = 'Efficiency', ylab = 'Color', main = 'Efficiency vs Color by Clusters')
qplot(beer_cluster2$BoilTime, beer_cluster2$BoilGravity, col=beer_cluster2$cluster_num1,
      xlab = 'BoilTime', ylab = 'BoilGravity', main = 'BoilTime vs BoilGravity by Clusters')
qplot(beer_cluster2$BoilTime, beer_cluster2$OG, col=beer_cluster2$cluster_num1,
      xlab = 'BoilTime', ylab = 'OG', main = 'BoilTime vs OG by Clusters')
qplot(beer_cluster2$bu_gu, beer_cluster2$OG, col=beer_cluster2$cluster_num1,
      xlab = 'BU/GU Ratio', ylab = 'OG', main = 'BU/GU Ratio vs OG by Clustetrs')




