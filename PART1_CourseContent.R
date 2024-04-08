###########################################
## LOADING IN AND CLEANING DATA
###########################################


##### Working directory #####
# First, what is your working directory?
getwd()

# Set the working directory to the folder you have your data saved to (as well as this script)
setwd("yourfilepath") # Use forward slashes
# E.g. setwd("C:/Users/p34264hc/OneDrive - The University of Manchester/Documents/Teaching/R workshop pregnancy")

# Check this has worked 
getwd()





##### Load in the data ##### 

# As you have set your working directory to the data location, you can easily load this in using the csv file name alone!
data <- read.csv(file = "data_input.csv") # You may also see a function called read.csv2 - this is used for csv files that have semi-colon separated values

# If you hadn't set your working directory, you could still use the above command but would have to specify the full file path, e.g.
# data <- read.csv("C:/Users/p34264hc/OneDrive - The University of Manchester/Documents/Teaching/R workshop pregnancy/data_input.csv") 

# Inspect the 'head' of the dataset (first 6 rows)
head(data)

# View entire dataset
View(data)

# Produce a list of column names
colnames(data)

# Investigate the 'structure' of the data
str(data)








##### Indexing ##### 
## Indexing a column:
data$Marital_status # By column name
data[,"Marital_status"] # Alternative way of doing this
data[,3] # By column number

## Indexing a row
data[4,] # Data relating to the fourth observation

## Indexing both a row and a column
data[4,]$Marital_status
data[4,"Marital_status"]
data[4,3]


## SEE ACTIVITY FILE 


## Creating subsets (activity - but need these for later!)
female <- data[which(data$sex_baby1 == 1),] 
male <- data[which(data$sex_baby1 == 2),] 








##### Variable types ##### 


# The 'structure' command told us the type of variables we have...

# Use the 'class' command to view classes for individual columns (or values)
class(3)
class(3L)
class("3")

# Other functions exist which tell you whether a variable belongs to a certain class 
is.character(3)
is.character(3L)
is.character("3")
is.numeric(3)
is.numeric(3L)
is.numeric("3")

# Changing variable types
1:10
is.character(1:10)
as.character(1:10)

data$Participant_number <- as.character(data$Participant_number) # Change to character
data$Type_pregnancy <- as.factor(data$Type_pregnancy) # Change to factor (either twins or not twins in this dataset)


## SEE ACTIVITY FILE 




##### Cleaning ##### 

## Renaming a variable -  Gestationnal_age to Gestational_age
colnames(data)
which(colnames(data) == 'Gestationnal_age') # Find out which column number we need to change
colnames(data)[which(colnames(data) == 'Gestationnal_age')] <- 'Gestational_age' # Reassign using colnames <- 
colnames(data) # Check it worked

## Creating a new variable
data$Age_bb_months # Extracting a column that doesn't exist
data$Age_bb_months <- data$Age_bb*12 # Multiple years by 12 to get months and use <- to assign to a new column name
data$Age_bb_months # Now it does exist!


## SEE ACTIVITY FILE 


## Sex - male and female
data$sex_baby1 # Show infant sex data
ifelse(data$sex_baby1=="1", "female", "male") # Use ifelse to change 1=female, and 2=male
data$sex_baby1 <- ifelse(data$sex_baby1=="1", "female", "male") # Reassign to sex_baby1
data$sex_baby1 # Check it's worked
data$sex_baby1 <- as.factor(data$sex_baby1) # Change to a factor


## SEE ACTIVITY FILE 


## Change missing infant sleep duration to correct format 99:99
# NA = missing data format in R
NA 
NA + 3 # Something known plus something unknown still gives us something unknown

# Use indexing to change our missing value of sleep night duration!
which(data$Sleep_night_duration_bb1=="99:99")
data[which(data$Sleep_night_duration_bb1=="99:99"),]$Sleep_night_duration_bb1 <- NA

# Making missing data a standard format that is recognised by R is useful, as you can utilise R's missing data functions
is.na(data$Sleep_night_duration_bb1)


## Removing the empty rows
data <- data[-which(is.na(data$Participant_number)),] # Use participant number to filter here, but other tricks exist (such as functions to remove rows if ALL values are NA)

## Check:
str(data) # Look at the number of observations...






##### Saving your data ##### 
write.csv(data, file = "data_cleaned.csv", row.names=FALSE) # As our working directory is the folder we want to save to, we only have to write the file name. We set row.names=FALSE to prevent R numbering the rows 1, 2, 3...

# It's good practice to NOT overwrite the raw data - you may need this in future.



#####




###########################################
## SUMMARISING DATA 
###########################################

  

##### The basics ##### 

## Summary function
summary(data)


## SEE ACTIVITY FILE 


## Proportions
twowaytable <- table(data$Education, data$Marital_status) # First, create a table
prop.table(twowaytable) # Use the prop.table function - provides % for each cell (% of the total population)
prop.table(twowaytable, 1) # Proportions row-wise (margin 1)
prop.table(twowaytable, 2) # Proportions column-wise (margin 2)





##### Distribution functions ##### 

# Min and max
min(data$Age)
max(data$Age)

# Mean and standard deviation
mean(data$Age)
sd(data$Age)
mean(data$Education) # Cannot take mean of factors, even if these are represented by numeric values

# Median and interquartile range
median(data$Age)
quantile(data$Age, p=0.25)
quantile(data$Age, p=0.75) # We can also use p=0.01 for the 1% percentile, p=0.33 for the 33% percentile, etc.
IQR(data$Age)


## SEE ACTIVITY FILE 






##### Table 1 ##### 

# Install and load
install.packages("table1")
library(table1)


## SEE ACTIVITY FILE 



# Save any changes that were made...
write.csv(data, file = "data_cleaned.csv", row.names=FALSE) # Will overwrite the file we saved previously






