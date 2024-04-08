###########################################
## VISUALISING DATA 
###########################################





## ACTIVITY 10: 
## Plot a histogram to inspect the HADS scores with 5, 20 and 50 breaks. Which do you think is the better choice and why?
hist(data$HADSsum, breaks=5) 
hist(data$HADSsum, breaks=20) 
hist(data$HADSsum, breaks=50) 


## Using histograms, inspect the distributions of the number of times an infant wakes up at night for mothers with a HADS score below and above the median
# Find median score
medianval <- median(data$HADSsum)
medianval # NB: the score for denoting anxiety is usually 8

# Create subsets based on the median score
belowHADS <- data[which(data$HADSsum<=medianval),]
aboveHADS <- data[which(data$HADSsum>medianval),]

# Plot distributions on two histograms on the same plot
hist(belowHADS$night_awakening_number_bb1, breaks=0:10, col=rgb(1,0,0,0.25),
     xlab="Number of times awake in night",
     main="Histogram of nightly waking, by total HADS score")
hist(aboveHADS$night_awakening_number_bb1, breaks=0:10, col=rgb(0,1,0,0.25), add=TRUE)

# Add a legend
legend("topright", # Add a legend
       legend=c("HADS score: low","HADS score: high"), # The labels
       col=c(rgb(1,0,0,0.25), rgb(0,1,0,0.25)), # The colours corresponding to the labels
       pt.cex=2, pch=15) # pt.cex = the size of the symbol, pch = the shape of the symbol






###########################################
## HYPOTHESIS TESTING
###########################################





## ACTIVITY 11: T test to see whether the number of times an infant wakes during the night is significantly different across male and female infants
t.test(male$night_awakening_number_bb1, female$night_awakening_number_bb1)
# From this, can you extract the p value?
ttest  <- t.test(male$night_awakening_number_bb1, female$night_awakening_number_bb1)
str(ttest) # str is for everything - not just data frames! The $ signs indicate extractable objects from within your object
ttest$p.value





###########################################
## ANALYSIS
###########################################





## ACTIVITY 12: If you put an entire dataframe into the 'cor' function, it will output a correlation matrix. This shows the correlation between all variables in the data
# 1. What happens when you try cor(data), and why?
# 2. Try to create a correlation matrix for all the mental health sums (HINT: you might want to subset your data for this...)
# 3. Do you results make sense? How would you visualise this?
cor(data, method="spearman")
cor(data[, c("CBTSsum", "HADSsum", "EPDSsum")],  method="spearman")
plot(data$EPDSsum, data$HADSsum)





## ACTIVITY 13: Repeat for HADS and City BiTS. Plus a model with all three. Do your results match the paper?
model <- lm(night_awakening_number_bb1 ~ HADSsum, data = data)
summary(model)
model <- lm(night_awakening_number_bb1 ~ CBTSsum, data = data)
summary(model)
model <- lm(night_awakening_number_bb1 ~ EPDSsum + HADSsum + CBTSsum, data = data)
summary(model)

plot(data$EPDSsum, data$HADSsum)





## ACTIVITY 14: lm vs glm
model <- lm(night_awakening_number_bb1 ~ EPDSsum, data = data)
summary(model)
model <- glm(night_awakening_number_bb1 ~ EPDSsum, data = data, family="gaussian")
summary(model)
# AIC...





## ACTIVITY 15
## Create a new variable - 5 or more wakes or less than 5
# Fit a logistic regression model and inspect the outcome. What has changed compared to the linear regression? Why?

data$wakes_binary <- ifelse(data$night_awakening_number_bb1<5, "Less than 5", "5 or more") # Add a new variable to categorise the number of wakes per night
table(data$wakes_binary, data$night_awakening_number_bb1) # Inspect whether this has worked as we think it has done
data$wakes_binary <- as.factor(data$wakes_binary) #  Change to a factor as we have a fixed set of possible values

# Fit model
model <- glm(wakes_binary ~ EPDSsum, data = data, family = "binomial")
summary(model)
exp(-0.06753) # Exponentiate the coefficient to get the odds ratio

# We think R is comparing less than 5 with 5+. But it's actually the other way around!
str(data) # Have a look at the order of the levels...
data$wakes_binary <- factor(data$wakes_binary, levels=c("Less than 5", "5 or more")) # Re level the variable so that the factors are in the right order...
model <- glm(wakes_binary ~ EPDSsum, data = data, family = "binomial")
summary(model)
exp(0.06753)
