# What is Beer?
Over 70K beer recipes
download the data from https://www.kaggle.com/jtrofe/beer-recipes/data

## by Saul Tamariz, June 2018
MSDS692-Final Project

## Understanding the Many Styles of Beer


### Description
Beer has been around for a very long time. Ever since the begining of civilization people have been brewing away and comming up with new ways to make good beer. For this project I will attempt to understand the quantitative qualities of beer. I have decided to download 73861 beer quantitative observations and 23 distinct features. I will attempt to trim and categorize the 176 styles of beer in this dataset. The goal will be to use data science as a tool to uncover what people are brewing and how they like their beer. 

### Features
BeerID - ID index for each beer recipe
Name - Beer Name
URL - Beer url link to the homebrew website
Style - Style name (176 Total)
StyleID - Style unique ID (176 Total)
Size(L) - Size in terms of liters 
OG - Original Gravity (metric & plato)
FG - Final Gravity (metric & plato)
ABV - Alcohol by Volume
IBU - International Bitterness Unit
Color - Color in terms of Standard Reference Method
BoilSize - Boil size in terms of liters
BoilTime - Boiltime in minutes
BoilGravity - BoilGravity (metric & plato)
Efficiency - Efficiency
MashThickness - (us & metric)
SugarScale - Plato or Specific Gravity
BrewMethod - All Grain, BIAB, extract, and Partial Mash
PitchRate - Pitch Rate
PrimaryTemp - Primary Temperature
Priming Method - Priming Method
PrimingAmount - Priming Amount
UserID - Specific user ID of brewer

### Project Overview
In the first part of the project I went ahead and did exploratory data analysis on the dataset. The goal was to understand each and every feature and see how I can use each variable accordingly. Since I wanted to do unsupervised learning using K-Means, I knew that my primarly focus was going to be in the numeric features. I decided to look at the features one to see which ones I could use. I soon realize and somewhat disapointed that there were many variables with many missing values. The goal for the first couple of weeks was to understand each feature and how it can be used. 

### EDA
After taking a crash course in the different quantitative qualities of beer I went ahead began to ommit all the features that I felt were not necessary to conduct K-Means. I started by removing the ID fields, Size, and also those with many missing values. I ran correlation matrix to see if I could impute some missing values but realize that there several features such as PitchRate, PrimaryTemp, PrimingMethod, and PrimingAmount that had large amounts of missing values. Furthermore, upon I realize that several variables had two different types of measuring units. I decided to trim the dataset to what I called drinkable beer. Typical range for Alcohol by Volume(ABV) is from 3.2 to 14, the higher the number the stronger the beer. As seen in the 
desity distribution curve most beers fall right around or bellow 6 ABV. International Bitteness Unit(IBU) is another unit of measure that takes into account how bitter a beer is, where typical values range from 8 IBU to 120 IBU. The Standard Reference Method(SRM) measures how light or how dark a beer is, where most values lie between 0 and 50. The larger the number the darker the beer. Other features that such as BoilTime range at or near 60 minutes, while there is a small cluster of beers that are at or near 90 minutes in BoilTime. There were four main brew methods found in this dataset, the most common is an All Grain method, followed by Extract. The least common methods were BIAB and Partial Mash. MashThickness was variable that I wanted to use do to the fact that it contained important information, however I discovered that this feature contained values that were intermixed with two different units of measure.Therefore, for this reason I had to eliminate MashThickness from the list of features that I would use for my K-Means analysis. 

![abv_density_plot](https://user-images.githubusercontent.com/36432832/42034666-0117f15c-7a9e-11e8-8ab9-f7f09cec0ab1.png)


### 

### Analysis


### Conclusion


