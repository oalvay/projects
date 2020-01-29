
# reading the dataset
anemia.data <- read.csv("AnemiaData.csv")

# extract the data without missing value
anemia.data_noNA <- anemia.data[anemia.data$Haemoglobin != -1,]

# change missing data's value from -1 to NA
anemia.data$Haemoglobin[anemia.data$Haemoglobin == -1] <- NA

###################################################################
#
##   Exploratory analysis
#
###################################################################
cat('\n\nExploratory analysis: \n')
cat('-------------------------------\n')

#attach the dataset makes code clear
attach(anemia.data)

##########
# 1. CleanWater, TreatedWater, Electricity, Toilet
#####


# dependency checking

water <- table(CleanWater, TreatedWater)
cat('\nFrequency and Relative frequency tables:\n\n')
print(prop.table(water))
cat('\n')
# Combine CleanWater and TreatedWater to a new variable called Water

water.temp <- as.numeric(CleanWater) + as.numeric(TreatedWater)
water.numeric <- c(2, 3, 4)
water.categorical <- c('Unclean', 'Clean', 'Treated')
detach(anemia.data)
anemia.data$Water <- 
  factor(water.categorical[match(water.temp, water.numeric)])

# plots between Haemoglobin level and variables

attach(anemia.data)
png("boxplot1(figure1).png",height = 800, width = 600, pointsize = 20)
par(mfrow=c(1,1),mgp=c(2.25,0.75,0))
plot(Haemoglobin ~ Electricity, range = 0, cex.lab=1.5, 
     cex.axis = 1.2,lwd = 2, ylab = 'Haemoglobin Level (g/Dl)'
     , xlab = 'availability of electricity') 
abline(h = median(Haemoglobin[Electricity == 'No'], na.rm = TRUE), col = 'red', lwd = 2)
legend('topleft',legend=c("median for women \ncan't use electricity"),
       col=c("red"), lty = 1, cex=0.9, inset = -0.02, lwd = 2)
title("Figure 1: Boxplot of women's Haemoglobin \nlevel by availability of electricity",
      cex.main = 1.3)
dev.off()

png("boxplot2.png",height = 800, width = 600, pointsize = 20)
par(mfrow=c(1,1),mgp=c(2.25,0.75,0))
plot(Haemoglobin ~ Toilet, range = 0, cex.lab=1.5, lwd = 2,
     cex.axis = 1.2, ylab = 'Haemoglobin Level (g/Dl)', xlab = 'availability of toilet') 
abline(h = median(Haemoglobin[Toilet == 'No'], na.rm = TRUE), col = 'red', lwd = 2)
legend('topleft',legend=c("median for women have no toilet"),
       col=c("red"), lty = 1, cex=0.8,  lwd = 2)
title("Boxplot for women's Haemoglobin level \nby availability of toilet", cex.main = 1.3)
dev.off()

png("boxplot3.png",height = 800, width = 600, pointsize = 20)
par(mfrow=c(1,1),mgp=c(2.25,0.75,0))
plot(Haemoglobin ~ Water, range = 0, lwd = 2
     , cex.lab=1.5, cex.axis = 1.2)
abline(h = median(Haemoglobin[Water == 'Clean'], na.rm = TRUE), col = 'red', lwd = 2)
legend('topright',legend=c("median for women can use clear water"),
       col=c("red"), lty = 1, cex=0.7, lwd = 2)
title("Boxplot for women's Haemoglobin level \n quality of water", cex.main = 1.3)
dev.off()


##########
# 2. Chicken, Goats, Horses, Sheep, Cows
#####

# dependency checking

print(prop.table(table(AnimCart, Horses), 1))
cat('\n')
print(prop.table(table(Rural, Sheep), 2))
cat('\n')
print(prop.table(table(Rural, Cows), 2))
cat('\n')

# plots between Haemoglobin level and variables

png("boxplot4.png",height = 800, width = 600, pointsize = 20)
par(mfrow=c(2,3),lwd=2,mar=c(5,3.5,5,4),mgp=c(2,0.75,0))
plot(Haemoglobin ~ Cows, range = 0, cex.lab=1.4, 
     cex.axis = 1.2,lwd = 2, ylab = 'Haemoglobin Level (g/Dl)')
abline(h = median(Haemoglobin[Cows == 'No'], na.rm = TRUE), col = 'red', lwd = 2)
plot(Haemoglobin ~ Horses, range = 0, cex.lab=1.4, 
     cex.axis = 1.2,lwd = 2, ylab = 'Haemoglobin Level (g/Dl)')
abline(h = median(Haemoglobin[Horses == 'No'], na.rm = TRUE), col = 'red', lwd = 2)
plot(Haemoglobin ~ Goats, range = 0, cex.lab=1.4, 
     cex.axis = 1.2,lwd = 2, ylab = 'Haemoglobin Level (g/Dl)')
abline(h = median(Haemoglobin[Goats == 'No'], na.rm = TRUE), col = 'red', lwd = 2)
plot(Haemoglobin ~ Sheep, range = 0, cex.lab=1.4, 
     cex.axis = 1.2,lwd = 2, ylab = 'Haemoglobin Level (g/Dl)')
abline(h = median(Haemoglobin[Sheep == 'No'], na.rm = TRUE), col = 'red', lwd = 2)
plot(Haemoglobin ~ Chickens, range = 0, cex.lab=1.4, 
     cex.axis = 1.2,lwd = 2, ylab = 'Haemoglobin Level (g/Dl)')
abline(h = median(Haemoglobin[Chickens == 'No'], na.rm = TRUE), col = 'red', lwd = 2)
legend('topleft',legend=c("median for no ownership of each type of animals"),
       col=c("red"), lty = 1,inset = c(-2, -0.3),xpd=NA, cex = 1.25, lwd = 2)
title(main ="Boxplot for women's Haemoglobin level against animals ownerships", outer = TRUE,
      line = -3.5, cex.main = 1.75)
dev.off()

# aggregate animals other than Sheep by counting their species 

anemia.data$AnimalSpeciesNoSheep <- as.numeric(Cows) + as.numeric(Horses) + as.numeric(Goats) + 
  as.numeric(Chickens) - 4

# reattach data

detach(anemia.data)
attach(anemia.data)

# plots between Haemoglobin level and the aggregated variable

png("boxplot5.png",height = 600, width = 800, pointsize = 20)
par(mfrow=c(1,1),mgp=c(2.25,0.75,0))
boxplot(Haemoglobin ~ AnimalSpeciesNoSheep, range = 0, cex.lab=1.4, 
        cex.axis = 1.2,lwd = 2, ylab = 'Haemoglobin Level (g/Dl)',
        xlab = 'species of animals owned')
abline(h = median(Haemoglobin[AnimalSpeciesNoSheep == 0], na.rm = TRUE), col = 'red', lwd = 2)
legend('topleft',legend=c("median for women \nhad no animals"),
       col=c("red"), lty = 1, cex=0.8, inset = -0.02, lwd = 2)
title(main ="Boxplot for women's Haemoglobin level against 
species of animals owned(sheep excluded)", cex.main = 1.5)
dev.off()

##########
# 3. AgricLandOwn, Rural, AgricArea
#####

# dependency checking

print(prop.table(table(AgricLandOwn,Rural), 2))
cat('\n')
# plots between Haemoglobin level and variables

png("boxplot6.png",height = 800, width = 600, pointsize = 20)
par(mfrow=c(1,1),mgp=c(2.25,0.75,0))
plot(Haemoglobin ~ AgricLandOwn,  range = 0, cex.lab=1.35, 
     cex.axis = 1.2,lwd = 2, ylab = 'Haemoglobin Level (g/Dl)')
abline(h = median(Haemoglobin[AgricLandOwn == 'No'], na.rm = TRUE), col = 'red', lwd = 2)
legend('topright',legend=c("median for women \nhad no animals"),
       col=c("red"), lty = 1, cex=0.8, inset = -0.02, lwd = 2)
title(main ="Boxplot for women's Haemoglobin level\n against agricultural land ownership"
      , cex.main = 1.5)
dev.off()

png("boxplot7.png",height = 800, width = 600, pointsize = 20)
par(mfrow=c(1,1),mgp=c(2.25,0.75,0))
plot(Haemoglobin ~ Rural, range = 0, cex.lab=1.4, 
     cex.axis = 1.2,lwd = 2, ylab = 'Haemoglobin Level (g/Dl)',
     xlab = "Lived in rural area?")
abline(h = median(Haemoglobin[Rural == 'No'], na.rm = TRUE), col = 'red', lwd = 2)
legend('topright',legend=c("median for women who \ndon't live in rural area"),
       col=c("red"), lty = 1, cex=0.7, inset = -0.02, lwd = 2)
title(main ="Boxplot for women's Haemoglobin level regarding \nto whether women lived in rural area"
      , cex.main = 1.5)
dev.off()

png("scatterplot8.png",height = 600, width = 800, pointsize = 20)
par(mfrow=c(1,1),mgp=c(2.25,0.75,0))
plot(Haemoglobin ~ AgricArea, cex.lab=1.4, 
     cex.axis = 1.2,lwd = 2, ylab = 'Haemoglobin Level (g/Dl)', pch = 19, cex = 0.5)
abline(h = median(Haemoglobin, na.rm = TRUE), col = 'red', lwd = 2)
legend('topright',legend=c("median"),
       col=c("red"), lty = 1, cex=0.8, lwd = 2)
title(main ="Scatter plot for women's Haemoglobin level against area of agricultural land",
      cex.main = 1.5)
dev.off()




##########
# 4.AnimCart(animal-drawn cart) and BikeScootCar
#####

# dependency checking

print(table(AnimCart, BikeScootCar))
cat('\n')
# plots between Haemoglobin level and variables

png("boxplot9.png",height = 600, width = 800, pointsize = 20)
boxplot(Haemoglobin ~ round(BikeScootCar,2), range = 0
        ,lwd = 2, ylab = 'Haemoglobin Level (g/Dl)',
        xlab = 'Proprotion of the following owned by household:
(a) bike (b) scooter/motorcycle (c) car/truck')
abline(h = median(Haemoglobin[BikeScootCar == '0'], na.rm = TRUE), col = 'red', lwd = 2)
legend('topright',legend=c("median for women who don't\n have transportations"),
       col=c("red"), lty = 1, cex=0.8, lwd = 2)
title(main ="Boxplot for women's Haemoglobin level\n against transportation ownership",
      cex.main = 1.25)
dev.off()

png("boxplot10.png",height = 800, width = 700, pointsize = 20)
plot(Haemoglobin ~ AnimCart, range = 0,lwd = 2, ylab = 'Haemoglobin Level (g/Dl)',
     xlab = 'animal-drawn cart ownership')
abline(h = median(Haemoglobin[AgricLandOwn == 'No'], na.rm = TRUE), col = 'red', lwd = 2)
legend('topleft',legend=c("median for women who don't live in rural area"),
       col=c("red"), lty = 1, lwd = 2)
title(main ="Boxplot of women's Haemoglobin level \nagainst animal-drawn cart ownership",
      cex.main = 1.5)
dev.off()

##########
# 5.HHSize, HHUnder5s, TotalChildren
#####

# matrix plot amongst variables

png("matrixplot11.png",height = 800, width = 800, pointsize = 20)
pairs(anemia.data[,c('HHSize', 'HHUnder5s', 'TotalChildren')])
title(main ="Matrix plot for variables regarding to family size", cex.main = 1.5, line = 2.7)
dev.off()

# plots between Haemoglobin level and variables

png("plot12.png",height = 800, width = 900, pointsize = 20)
par(mfrow=c(2,2),mgp=c(2.5,0.75,0))
plot(Haemoglobin ~ HHSize, lwd = 2, ylab = 'Haemoglobin Level (g/Dl)', pch = 19, cex = 0.75,
     xlab = 'Number of household members')    
abline(h = median(Haemoglobin, na.rm = TRUE), col = 'red', lwd = 2)
plot(Haemoglobin ~ TotalChildren,lwd = 2, ylab = 'Haemoglobin Level (g/Dl)',pch = 19, cex = 0.75,
     xlab = 'Number of children ever born to the woman') 
abline(h = median(Haemoglobin, na.rm = TRUE), col = 'red', lwd = 2)
boxplot(Haemoglobin ~ HHUnder5s, range = 0, lwd = 2, ylab = 'Haemoglobin Level (g/Dl)',
        xlab = 'Number of children under \nthe age of 5 in the household') 
abline(h = median(Haemoglobin, na.rm = TRUE), col = 'red', lwd = 2)
legend('topleft',legend=c("median of women's Haemoglobin level"),
       col=c("red"), lty = 1,inset = c(0.5, -0.4),xpd=NA, cex = 1.25, lwd = 2)
title(main ="Plots for women's Haemoglobin level against\n variables regarding to family size",
      cex.main = 1.5, outer = TRUE, line = -3)
dev.off()

##########
# 6. Education, HHEducation WealthScore
#####

# plots between WealtheScore and variables to check dependency

png("plot13.png",height = 800, width = 900, pointsize = 20)
par(mfrow=c(2,3),mgp=c(2.88,0.75,0))
plot(WealthScore ~ Education, range = 0, cex.lab=1.2, cex.axis = 0.9,
     ylab = 'Haemoglobin Level (g/Dl)',xlab = "Women's education level") 
plot(WealthScore ~ HHEducation, range = 0, cex.lab=1.2, cex.axis = 0.9,
     ylab = 'Haemoglobin Level (g/Dl)',xlab = "Household's education level") 
plot(WealthScore ~ AnimCart, range = 0, cex.lab=1.2, cex.axis = 1.2,
     ylab = 'Haemoglobin Level (g/Dl)',xlab = "animal-drawn cart ownership") 
boxplot(WealthScore ~ round(BikeScootCar,2), range = 0, cex.lab=1.2, cex.axis = 1.2,
        ylab = 'Haemoglobin Level (g/Dl)',xlab = 
        'Proprotion of transportation owned') 
boxplot(WealthScore ~ AnimalSpeciesNoSheep, range = 0, cex.lab=1.2, cex.axis = 1.2,
        ylab = 'Haemoglobin Level (g/Dl)',xlab = 'species of animals owned\n(sheep excluded)') 
title(main ="Boxplots for WealthScore against\n other variables",
      cex.main = 1.5, outer = TRUE, line = -3)
dev.off()

# plots between Haemoglobin level and variables

png("plot14.png",height = 800, width = 900, pointsize = 20)
plot(Haemoglobin ~ HHEducation, pch = 19, cex = 0.1, cex.lab=1.2, range = 0,
     cex.axis = 1.2,lwd = 2, ylab = 'Haemoglobin Level (g/Dl)', xlab = 'Education level')
abline(h = median(Haemoglobin[HHEducation == 'None'], na.rm = TRUE), col = 'red', lwd = 2)
legend('topleft',legend=c("median for women whose household is not educated"),
       col=c("red"), lty = 1, lwd = 2)
title(main ="Boxplot of women's Haemoglobin level \nagainst household's education level"
      , cex.main = 1.5)
dev.off()

png("plot15.png",height = 800, width = 900, pointsize = 20)
plot(Haemoglobin ~ Education, range = 0, cex.lab=1.2, 
     cex.axis = 1.2,lwd = 2, ylab = 'Haemoglobin Level (g/Dl)',
     xlab = "Household's education level")
abline(h = median(Haemoglobin[Education == 'None'], na.rm = TRUE), col = 'red', lwd = 2)
legend('topright',legend=c("median for women who is not educated"),
       col=c("red"), lty = 1, lwd = 2)
title(main ="Boxplot of women's Haemoglobin level \nagainst education level", cex.main = 1.5)
dev.off()

png("plot16.png",height = 800, width = 900, pointsize = 20)
plot(Haemoglobin ~ WealthScore,  cex.lab=1.4,  pch = 19, cex = 0.5,
     cex.axis = 1.2,lwd = 2, ylab = 'Haemoglobin Level (g/Dl)')
abline(h = median(Haemoglobin, na.rm = TRUE), col = 'red', lwd = 2)
legend('topleft',legend=c("median of women's Haemoglobin level"),
       col=c("red"), lty = 1, lwd = 2)
title(main ="Scatter plot of women's Haemoglobin level \nagainst wealth score", cex.main = 1.5)
dev.off()



##########
# 7. Province, Region, Ethnicity
#####

# plots between Haemoglobin level and variables

png("boxplot17(figure2).png",height = 800, width = 1200, pointsize = 20)
par(mfrow=c(1, 1),mar=c(6, 5, 6, 3), mgp=c(2.8,0.75,0))
plot(Haemoglobin ~ Province, range = 0, cex.lab=1.4, 
     cex.axis = 1.1,lwd = 2, ylab = 'Haemoglobin Level (g/Dl)', xlab = '', las=2)
abline(h = median(Haemoglobin, na.rm = TRUE), col = 'red', lwd = 2)
legend('topright',legend=c("median of women's Haemoglobin level"),
       col=c("red"), lty = 1, lwd = 2, cex = 0.95)
title(main ="Figure 2: Boxplot of women's Haemoglobin\nlevel by province", cex.main = 1.5)
dev.off()

png("boxplot18.png",height = 800, width = 900, pointsize = 20)
par(mfrow=c(1, 1),mar=c(9, 5, 6, 3), mgp=c(2.8,0.75,0))
plot(Haemoglobin ~ Region, range = 0, cex.lab=1.3, xlab = '',
     cex.axis = 1,lwd = 2, ylab = 'Haemoglobin Level (g/Dl)', las=2)
abline(h = median(Haemoglobin, na.rm = TRUE), col = 'red', lwd = 2)
legend('topleft',legend=c("median of women's Haemoglobin level"),
       col=c("red"), lty = 1, lwd = 2)
title(main ="Boxplot of women's Haemoglobin level \nby region", cex.main = 1.5)
dev.off()

png("boxplot19(figure3).png",height = 800, width = 1000, pointsize = 20)
plot(Haemoglobin ~ Ethnicity, data = anemia.data_noNA,range = 0, cex.lab=1.2, 
     cex.axis = 1.1,lwd = 2, ylab = 'Haemoglobin Level (g/Dl)', xlab = 'Ethnicity')
abline(h = median(Haemoglobin, na.rm = TRUE), col = 'red', lwd = 2)
legend('topleft',legend=c("median of women's Haemoglobin level"),
       col=c("red"), lty = 1, lwd = 2, cex = 0.9)
title(main ="Figure 3:Boxplot of women's Haemoglobin\nlevel by ethnicity", cex.main = 1.5)
dev.off()

# Hierarchical clustering for Province

NumVars <- c('Haemoglobin', 'AgricArea', 'WealthScore')
Summaries <- aggregate(anemia.data_noNA[,NumVars],
                           by = list(anemia.data_noNA$Province),
                           FUN = function(x) c(Mean = mean(x), SD = sd(x)))
rownames(Summaries) <- Summaries[,1]
Summaries <- scale(Summaries[,-1])
Clustree <- hclust(dist(Summaries), method = 'complete')
par(mfrow=c(1,1))
png("ProvinceCluster.png",height = 800, width = 1200, pointsize = 20)
plot(Clustree,xlab = 'levels', ylab = 'Seperation')
abline(h = 2.2, col = 'red')
dev.off()
NewGroups <- paste('ProvinceGrp', cutree(Clustree, h = 2.2), sep = "")
anemia.data$ProvinceGrp <- factor(NewGroups[match(anemia.data$Province,
                                                  levels(anemia.data$Province))])

# aggregate Ethnicity by similarity in Haemoglobin level

Ethnicity.old <- c('Dari', 'Other/missing', 'Pashto', 'Turkmen', 'Uzbek')
Ethnicity.new <- c('Dari&Pashto', 'Other/missing','Dari&Pashto','Turkmen&Uzbek', 'Turkmen&Uzbek')
anemia.data$Ethnicity <- 
  factor(Ethnicity.new[match(anemia.data$Ethnicity, Ethnicity.old )])

##########
# 8. Pregnant and RecentBirth
#####

# plots between Haemoglobin level and variables

png("boxplot20(figure4).png",height = 800, width = 600, pointsize = 20)
boxplot(Haemoglobin ~ Pregnant, range = 0, cex.lab=1.2, 
        cex.axis = 1.1,lwd = 2, ylab = 'Haemoglobin Level (g/Dl)', xlab = 'Pregnancy')
abline(h = median(Haemoglobin[Pregnant == 'No'], na.rm = TRUE), col = 'red', lwd = 2)
legend('topright',legend=c("median for non-\npregnant women"),
       col=c("red"), lty = 1, lwd = 2, cex = 0.95, inset = -0.01)
title(main ="Figure 4: Boxplot of women's \nHaemoglobin level by pregnancy", cex.main = 1.4)
dev.off()

png("boxplot21(figure5).png",height = 800, width = 600, pointsize = 20)
plot(Haemoglobin ~ RecentBirth, range = 0, cex.lab=1.2, 
cex.axis = 1.1,lwd = 2, ylab = 'Haemoglobin Level (g/Dl)', xlab = 'Recent birth experience')   
abline(h = median(Haemoglobin[RecentBirth == 'No'], na.rm = TRUE), col = 'red', lwd = 2)
legend('topleft',legend=c("median for women with no\n recent birth experience"),
       col=c("red"), lty = 1, lwd = 2, cex = 0.92, inset = -0.02)
title(main ="Figure 5: Boxplot of women's Haemoglo-\nbin level by recent birth experience",
      cex.main = 1.4)
dev.off()


##########
# 9. Age
#####

# plots between Haemoglobin level and variable

png("boxplot22.png",height = 800, width = 900, pointsize = 20)
par(mfrow=c(1,1))
boxplot(Haemoglobin ~ Age, range = 0, cex.lab=1.2, 
        cex.axis = 1.1,lwd = 2, ylab = 'Haemoglobin Level (g/Dl)', xlab = 'Age')
abline(h = median(Haemoglobin, na.rm = TRUE), col = 'red', lwd = 2)
legend('topright',legend=c("median of women's Haemoglobin level"),
       col=c("red"), lty = 1, lwd = 2, cex = 0.75)
title(main ="Boxplot of women's Haemoglobin level \nby age", cex.main = 1.4)
dev.off()

detach(anemia.data)

###################################################################
#
##   Model-building
#
###################################################################

# data reprocessing
anemia.data_noNA <- anemia.data[anemia.data$Haemoglobin != -1,]

##########
# the initial model
#####
cat('\n\nThe initial model:\n')
cat('-------------------------------\n')

lm.initial <- lm(Haemoglobin ~ ProvinceGrp, data = anemia.data_noNA)
cat('\nModel summary:\n')
print(summary(lm.initial))

# Diagnostic plots

png("initial_model.png",height = 800, width = 900, pointsize = 20)
par(mfrow=c(2,2),lwd=2,mar=c(3,3,5,2),mgp=c(2,0.75,0))
plot(lm.initial,pch = 19, cex = 0.5,which=1:4)
title(main ="Diagnostic plot of initial linear model", outer = TRUE,
      cex.main = 1.4, line = -2)
dev.off()

cat('\nThe number of standardized residuals with absolute value greater than 2 is', 
    length(rstandard(lm.initial)[abs(rstandard(lm.initial)) > 2]))

##########
# covariate selection
#####
cat('\n\nCovariate selection:\n')
cat('-------------------------------\n')

lm1 <- update(lm.initial, .~. + Electricity + Water)
cat('\nThe p-value for new added covariate Electricity is:',
    summary(lm1)$coefficients["ElectricityYes", 4])
lm2 <- update(lm1, .~. + Rural - Water)
cat('\nThe p-value for new added covariate Rural is:',
    summary(lm2)$coefficients["RuralYes", 4])
lm3 <- update(lm2, .~. + HHUnder5s)
cat('\nThe p-value for new added covariate HHUnder5s is:',
    summary(lm3)$coefficients["HHUnder5s", 4])
lm4 <- update(lm3, .~. + Ethnicity)
cat('\nThe p-values for new added covariate Ethnicity are:',
    summary(lm4)$coefficients["EthnicityOther/missing", 4], 'and',
    summary(lm4)$coefficients["EthnicityTurkmen&Uzbek", 4])
lm5 <- update(lm4, .~. + Pregnant +  RecentBirth - HHUnder5s)
cat('\nThe p-value for new added covariate Pregnant is:',
    summary(lm5)$coefficients["PregnantYes", 4])
cat('\nThe p-value for new added covariate RecentBirth is:',
    summary(lm5)$coefficients["RecentBirthYes", 4])
cat('\nCovariate HHUnder5s is dropped.')
lm.final <- update(lm5, .~. + Pregnant:Ethnicity )
cat('\nThe p-values for new added interaction are:',
    summary(lm.final)$coefficients["EthnicityOther/missing:PregnantYes", 4], 'and',
    summary(lm.final)$coefficients["EthnicityTurkmen&Uzbek:PregnantYes", 4])

# Diagnostic plots

png("final_model.png",height = 800, width = 900, pointsize = 20)
par(mfrow=c(2,2),lwd=2,mar=c(3,3,5,2),mgp=c(2,0.75,0))
plot(lm.final,pch = 19, cex = 0.5,which=1:4)
title(main ="Diagnostic plot of final linear model", outer = TRUE,
      cex.main = 1.4, line = -2)
dev.off()

png("final_model.png",height = 800, width = 900, pointsize = 20)

##########
# Model choosing
#####
cat('\n\nModel choosing:\n')
cat('-------------------------------\n')

# alternative model for comparison: Gamma glm with identity link

glm1 <- glm(Haemoglobin ~ ProvinceGrp + Electricity + Rural +
            Ethnicity + Pregnant + RecentBirth + Pregnant:Ethnicity,
           family = Gamma(link = 'identity'), data = anemia.data_noNA)

cat('\nIn gamma glm(identity link):Dispersion parameter for Gamma family is taken to be',
    summary(glm1)$dispersion)

# Diagnostic plots

png("alter_model.png",height = 800, width = 900, pointsize = 20)
par(mfrow=c(2,2),lwd=2,mar=c(3,3,5,2),mgp=c(2,0.75,0))
plot(glm1,pch = 19, cex = 0.5,which=1:4)
title(main ="Diagnostic plot of alternative Gamma glm", outer = TRUE,
      cex.main = 1.4, line = -2)
dev.off()

# the final model is the linear model

model.final <- lm.final

##########
# Prediction
#####

# extract the dataset to be predicted
anemia.data_NA <- anemia.data[is.na(anemia.data$Haemoglobin),]

# prediction
prediction <- predict(model.final, newdata = anemia.data_NA,se.fit = TRUE)

# export ID, predicted value and associated standard error to dat file
predict.data <- data.frame(as.numeric(names(prediction$fit)), prediction$fit, prediction$se.fit)
write.table(predict.data, '17024114_pred.dat', col.names = FALSE, row.names = FALSE)