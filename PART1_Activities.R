###########################################
## LOADING IN AND CLEANING DATA
###########################################


## ACTIVITY 1: Inspect the data. Is everything as you'd expect given what we know about the data?
str(data) # Use the structure command to investigate the column names, types, number of observations, etc..





## ACTIVITY 2:
##Extract age data from the 5th observation
# By column name
data[5,]$Age 
data[5,"Age"] 
# By column number
colnames(data) # Check column names to see which column number corresponds to age
which(colnames(data)=="Age") # Can use the which command to verify
data[5,2]

## Extract all data relating to observations 10-40
data[10:40,] 
data[c(10,11,12,38,39,40),] # Could also explicitly write the vector
data[,c("Age", "Marital_status")] # Can also use vectors for column selecting

## Explore which(data$sex_baby1 == 1)
which(data$sex_baby1 == 1) # Gives the row numbers where the sex of the baby is 1
data[which(data$sex_baby1 == 1),] # Put the above condition into an indexing format to filter data to female infants
data[which(data$Age<30),] # Can do a similar thing with age

female <- data[which(data$sex_baby1 == 1),] # Can use this to create subsets of data - female only infant
male <- data[which(data$sex_baby1 == 2),] # Male only infants





## ACTIVITY 3: Inspect the data using ‘str’ and identify whether there are any variables whose type may need to be changed. And then change this!
str(data)
data$sex_baby1 <- as.factor(data$sex_baby1)
data$Marital_status <- as.factor(data$Marital_status)
data$Education <- as.factor(data$Education)
data$how_falling_asleep_bb1 <- as.factor(data$how_falling_asleep_bb1)





## ACTIVITY 4: Sum of EPDS scores
data$EPDSsum <- data$EPDS_1 + data$EPDS_2 + data$EPDS_3 + data$EPDS_4 + data$EPDS_5 + 
  data$EPDS_6 + data$EPDS_7 + data$EPDS_8 + data$EPDS_9 + data$EPDS_10 

# We could have also summed the columns by number:
colnames(data) # From this, it looks like the columns we want to sum are numbers 28-37
colnames(data[,28:37]) # Do this to double check
data$EPDSsum <- data[,28] + data[,29] + data[,30] + data[,31] + data[,32] + data[,33] +
  data[,34] + data[,35] + data[,36] + data[,37] # Create a sum variable

# We can also use the rowSums function - this simply adds up values across rows for a certain value
EPDS_data <- data[,28:37] # Create a subset of data which just contains the EPDS items
rowSums(EPDS_data) # Sum across the EPDS items for each row
rowSums(data[,28:37])# Short cut!
data$EPDSsum # Compare with the manual way to reassure yourselves!





## ACTIVITY 5: HADS and CBPTSD scores
colnames(data[,38:44]) 
data$HADSsum <- rowSums(data[,38:44])

colnames(data[,8:27]) 
data$CBTSsum <- rowSums(data[,8:27])





## ACTIVITY 6: HADS score categories
data$HADScat <- ifelse(data$HADSsum>7, "Yes", "No")
data$HADScat <- ifelse(data$HADSsum<8, "No", "Yes")
# Or can include multiple categories, through multiple statements:
data$HADScat2 <- ifelse(data$HADSsum<8, "No", 
                       ifelse(data$HADSsum<11, "Mild", 
                              ifelse(data$HADSsum<16, "Moderate", "Severe")))
# AND/OR operators can also be used, as well as greater/less than OR EQUAL signs
data$HADScat3 <- NA
data$HADScat3 <- ifelse(data$HADSsum<8, "No", data$HADScat3)
data$HADScat3 <- ifelse(data$HADSsum>7 & data$HADSsum<=10, "Mild", data$HADScat3)
data$HADScat3 <- ifelse(data$HADSsum>10 & data$HADSsum<=15, "Moderate", data$HADScat3)
data$HADScat3 <- ifelse(data$HADSsum>15, "Severe", data$HADScat3)
# Check this:
data[,c("HADScat", "HADScat2", "HADScat3")]






###########################################
## SUMMARISING DATA 
###########################################




## ACTIVITY 7: table function
table(data$sex_baby1) # One way table
table(data$Education)
table(data$Education, data$Marital_status) # Two way table
table(data$Sleep_night_duration_bb1)
table(data$Sleep_night_duration_bb1, useNA = "always") # Doesn't show missing values unless you explicitly outline this...





## ACTIVITY 8
## Find the standard error of the mean for age
stddev <- sd(data$Age)
stddev_mean <- stddev/sqrt(410)
stddev_mean <- stddev/sqrt(nrow(data)) # Or could use nrow, which tells you how many rows your data has
stddev_mean
round(stddev_mean, 2) # Round to 2 decimal places

## How many people with an age less than 30?
data$Agecat <- ifelse(data$Age<30, "Less than 30", "30+")
table(data$Agecat)
table(data$Age<30) # Could just use the logical value directly
length(which(data$Age<30)) # Or use the length function, which tells you the length of the vector





## ACTIVITY 9: use the table1 package to create a nicely formatted table 1
# Create a table
table1(~ Age + Marital_status + Education + Gestational_age + sex_baby1 + Age_bb +
         night_awakening_number_bb1 + how_falling_asleep_bb1 + EPDSsum + HADSsum + CBTSsum, data=data)


# Rename levels  - an alternative to ifelse...
data$Education <- 
  factor(data$Education, 
         # The current levels of your factor variable:
         levels=c(1,2,3,4,5), 
         # The desired levels of your factor variable:
         labels=c("None", "Compulsory school",  "Post-compulsory",  "Applied Science or University Technology", "University"))


# Re-run with new formatting
table1(~ Age + Marital_status + Education + Gestational_age + sex_baby1 + Age_bb +
         night_awakening_number_bb1 + how_falling_asleep_bb1 + EPDSsum + HADSsum + CBTSsum, data=data)






