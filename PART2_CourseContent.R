##### Getting started ##### 

# Load in data from the previous session
data <- read.csv(file = "data_cleaned.csv") # Load in the clean data

# A good idea to check the formats are as expected when you load in data - even if this is a dataset you have already reformatted
str(data)

# Reformat accordingly:
data$Participant_number <- as.character(data$Participant_number)
data$Type_pregnancy <- as.factor(data$Type_pregnancy)
data$sex_baby1 <- as.factor(data$sex_baby1)
data$Marital_status <- as.factor(data$Marital_status)
data$Education <- as.factor(data$Education)
data$how_falling_asleep_bb1 <- as.factor(data$how_falling_asleep_bb1)









###########################################
## VISUALISING DATA 
###########################################




##### R basic plots #####

## Numeric: histogram
# Histogram of EPDS scores
hist(data$EPDSsum)

# We can change the bin parameters:
hist(data$EPDSsum, breaks=20) # Can specify a number of bins
hist(data$EPDSsum, breaks=c(0, 5, 10, 15, 25, 30)) # Or can specify the specific break points for your histogram

# We can also add plot titles and axis titles
hist(data$EPDSsum, breaks=20,
     xlab = "EPDS total score", # X axis
     ylab = "Density frequency", # Y axis
     main = "Histogram of total EPDS scores", # Title
     col="orange") # Colour of histogram bars


# Plotting two histograms for boy and girl dataset
female <- data[which(data$sex_baby1=="female"),] # Female subset (if not done already...)
male <- data[which(data$sex_baby1=="male"),] # Male subset
hist(female$EPDSsum, breaks=20) 
hist(male$EPDSsum, breaks=20) 

# Plotting two distributions on the same figure
hist(female$EPDSsum, breaks=20, col=rgb(1,0,0,0.25)) # RGB specifies the RBG code (first three characters) and the level of transparency
hist(male$EPDSsum, breaks=20, col=rgb(0,1,0,0.25), add=TRUE) # add=TRUE tells R to add this onto the last plot
legend("topright", # Add a legend
       legend=c("Female","Male"), # The labels
       col=c(rgb(1,0,0,0.5), rgb(0,1,0,0.5)), # The colours corresponding to the labels
       pt.cex=2, pch=15) # pt.cex = the size of the symbol, pch = the shape of the symbol


## SEE ACTIVITY FILE 







## Numeric: scatter
plot(x=data$HADSsum, y=data$EPDSsum) # Scatter plot command

plot(x=data$HADSsum, y=data$EPDSsum,
     xlim=c(0,25) , ylim=c(0,30), # The maximum and minimum values on your axis
     pch=3, # This changes the image used for the scatter points 
     cex=1, # The size of your shape (larger number = larger shape)
     col="purple",# The colour of your shapes, which can be one of R's in-built colours or codes (e.g. RGB codes or hex, for example #69b3a2)
     xlab="Age", ylab="Sum of EPDS scores", # Axis labels
     main="Age vs EPDS scores" # Graph title
)





## Numeric: box plot
# Boxplot of participant age
boxplot(data$Age)

# Can summarise the distribution by groups, for example education level
boxplot(data$Age ~ data$Education)


# We can also add plot titles and axis titles
boxplot(data$Age ~ data$Education,
        xlab="Age",
        ylab="Education level",
        main = "Boxplot of participant age, by education level")





## Categorical: bar plot
# Barplots in base R require two inputs: the categories, the frequencies. i.e. they do not take a vector of values and automatically make a barplot with the frequency of these
# Step 1: Use the table function to obtain frequency values
table_plot <- table(data$Education)
table_plot 
# Step 2: feed this into the plotting function
barplot(table_plot)

# Add useful settings
barplot(table_plot,
        ylim=c(0,200), # Make sure y axis goes up to the max value
        xlab = "Education level",
        ylab = "Number of participants",
        main = "Bar plot of participant education")

# We can also create a relative frequency bar plot
table_plot <- prop.table(table_plot)
table_plot 

barplot(table_plot*100, # Multiple values by 100 to get a percentage
        ylim=c(0,100), # As it's a percentage, the axis changes to 0-100
        xlab = "Education level",
        ylab = "% of participants",
        main = "Bar plot of participant education",
        angle=45)


# Can also perform a grouped barchart, whereby the bar charts are split across two groups
table_plot <- table(data$Education, data$sex_baby1)
barplot(table_plot,
        ylim=c(0,100),
        legend.text = rownames(table_plot),
        beside=TRUE)







##### Ggplot example #####


## Install package
install.packages("ggplot2")
library(ggplot2)

## Histogram example: basic
plot <- ggplot(data,
               aes(x=EPDSsum)) +
  geom_histogram()
plot

# Changing aesthetic values
plot <- ggplot(data,
               aes(x=EPDSsum)) +
  geom_histogram(color="#69b3a2", fill="#404080", # Changes the colour of the bin outlines and insides respectively
                 alpha=0.8) + # Alpha make it translucent 
  theme_bw() + # Themes can change global visual parameters
  xlab("Total EPDS score") + # Adding axis labels and a title
  ylab("Frequency density") +
  ggtitle("Histogram of total EPDS scores") 
plot

# Adding a vertical line for the mean into the plot
plot <- plot  +
  geom_vline(aes(xintercept=mean(EPDSsum)),
             color="blue", linetype="dashed", size=1)

plot

# Adding a mean label
plot <- plot + geom_label(
  label=paste0("Mean: ", round(mean(data$EPDSsum),2)), 
  x=20,  y=30,
  label.padding = unit(0.55, "lines"), # Rectangle size around label
  label.size = 0.35,
  color = "black",
  fill="#69b3a2"
)

plot

# Plotting several histograms on the same plot
plot <- ggplot(data,
               aes(x=EPDSsum, fill=sex_baby1)) +
  geom_histogram(alpha=0.8) + # Alpha make it translucent 
  scale_fill_manual(values=c("#69b3a2", "#404080")) +
  theme_bw() + # Themes can change global visual parameters
  xlab("Total EPDS score") + # Adding axis labels and a title
  ylab("Frequency density") +
  ggtitle("Histogram of total EPDS score, by infant sex") + 
  labs(fill='Infant sex') 
plot

# Have them overlapped instead of stacked
plot <- ggplot(data,
               aes(x=EPDSsum, fill=sex_baby1)) +
  geom_histogram(alpha=0.8, position="identity") + # Alpha make it translucent 
  scale_fill_manual(values=c("#69b3a2", "#404080")) +
  theme_bw() + # Themes can change global visual parameters
  xlab("Total EPDS score") + # Adding axis labels and a title
  ylab("Frequency density") +
  ggtitle("Histogram of total EPDS scores, by infant sex") + 
  labs(fill='Infant sex') 
plot




## Scatterplot example: basic
plot <- ggplot(data,
               aes(x=EPDSsum, y=night_awakening_number_bb1)) +
  geom_point(fill="#69b3a2",
             shape=21,
             alpha=0.5, # Transparency - allows you to see overlaps!
             size=5) + # Size of dots
  xlab("Total EPDS score") + # Adding axis labels and a title
  ylab("Number of times infant wakes") +
  ggtitle("Total EPDS score vs infant waking") 

plot




# Save any changes that were made...
write.csv(data, file = "data_cleaned.csv", row.names=FALSE) # Will overwrite the file we saved previously




#####







###########################################
## HYPOTHESIS TESTING
###########################################




##### Comparing two means ##### 

##  Parametric - T test - two sided
# H0: There is no difference in the HADS score across different sexes
t.test(HADSsum ~ sex_baby1, data = data)

## Parametric - T test - one sided
t.test(HADSsum ~ sex_baby1, data = data, alternative = "greater")
t.test(HADSsum ~ sex_baby1, data = data, alternative = "less")

# Be careful with one sided t tests - R will the comparison group of X greater/less than Y based on alphabetical order. ALWAYS check your output to ensure R has done what you think it's done...


## Non parametric - Mann-Whitney
wilcox.test(HADSsum ~ sex_baby1, data = data) 





##### Comparing two categorical variables ##### 

## Chi square test
# H0: no association between the two variables
table_test <- table(data$Education, data$Marital_status) 
table_test
chisq.test(table_test) # Warning whenever a cell count is <5 


## Fisher's exact

fisher.test(table_test) 



## SEE ACTIVITY FILE 






#####





###########################################
## ANALYSIS
###########################################



##### Correlation #####

## Between two continuous variables
cor(data$CBTSsum, data$night_awakening_number_bb1, method="pearson")
cor(data$CBTSsum, data$night_awakening_number_bb1, method="spearman")


## SEE ACTIVITY FILE 


## Correlation plot
install.packages("corrplot")
library(corrplot)
corrplot(cor(data[, c("CBTSsum", "HADSsum", "EPDSsum")]))
corrplot(cor(data[, c("CBTSsum", "HADSsum", "EPDSsum")]), method="number") # Visualise with numbers instead of circles
corrplot(cor(data[, c("CBTSsum", "HADSsum", "EPDSsum")]), method="number", type="upper") # Mirrored info - only keep upper triangle






##### Linear regression #####

## lm function
lm(night_awakening_number_bb1 ~ EPDSsum, data = data)

# Using the summary function much improves the output...
model <- lm(night_awakening_number_bb1 ~ EPDSsum, data = data)
summary(model)


## SEE ACTIVITY FILE 


## glm function
model <- glm(night_awakening_number_bb1 ~ EPDSsum, data = data, family="gaussian")
summary(model)


## SEE ACTIVITY FILE 


## Scatterplot example: adding a regression line
plot <- ggplot(data,
               aes(x=EPDSsum, y=night_awakening_number_bb1)) +
  geom_point(fill="#69b3a2",
             shape=21,
             alpha=0.5, # Transparency - see overlaps!
             size=5) + # Size of dots
  geom_smooth(method='lm', formula= y~x)

plot







##### Logistic regression  #####


## SEE ACTIVITY FILE 


# Tidy model output with readily available odds ratios
install.packages("broom")
library(broom)
tidy(model, exponentiate = TRUE) # Exponentiate coefficients to get odds ratios
tidy(model, exponentiate = TRUE, conf.int=TRUE) # Add odds ratio confidence intervals

