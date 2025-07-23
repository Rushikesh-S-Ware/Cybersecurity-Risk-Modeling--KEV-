# Load necessary libraries
# Install required packages if not already installed
install.packages(c("tidyverse", "ggplot2", "DataExplorer", "corrplot", "lubridate"))
install.packages("rmarkdown")
install.packages("knitr")
install.packages("ggcorrplot")  # For correlation visualization
install.packages("vcd")  # For categorical correlation

library(tidyverse)
library(ggplot2)
library(DataExplorer)
library(corrplot)
library(lubridate)

# Define file path
file_path <- "C:/Data analytic engineering/Projects/SYST_568_Final_proj/Processed_Dataset1.csv"
# Read the CSV file
df <- read.csv(file_path, stringsAsFactors = FALSE)

# Display first few rows
head(df)

# Check structure of the dataset
str(df)

# Display a few rows before transformation
head(df$published_date)




# This step is done for preprocessing the date and time column which was one single column(Don't have to run this everytime, just during the first time)
df <- df %>%
  mutate(
    # Remove "T" and "Z" from the timestamp to make it "YYYY-MM-DD HH:MM:SS"
    clean_published_date = str_replace_all(published_date, "[TZ]", " "),
    
    # Debug: Print unique formats (Run this separately to check formats)
    # print(unique(clean_published_date)),
    
    # Convert cleaned string to POSIXct using explicit format
    full_datetime = as.POSIXct(clean_published_date, format = "%Y-%m-%d %H:%M", tz = "UTC"),
    
    # Extract Date (YYYY-MM-DD)
    date = as.Date(full_datetime),
    
    # Extract Time (HH:MM:SS) while keeping it character format
    time = format(full_datetime, "%H:%M:%S")
  )


str(df$date)
summary(df)
head(df)

# Define output file path
output_file_path <- "C:/Data analytic engineering/Projects/SYST_568_Final_proj/Processed_Dataset1.csv"

# Save the cleaned dataset
write.csv(df, output_file_path, row.names = FALSE)

# Confirm the file was saved
print(paste("Processed dataset saved at:", output_file_path))




#cleaning the unwanted column(irrelavant column)
# Remove unnecessary columns
df <- df %>% select(-clean_published_date, -full_datetime)

# Save the updated dataset
file_path <- "C:/Data analytic engineering/Projects/SYST_568_Final_proj/Processed_Dataset1.csv"
write.csv(df, file_path, row.names = FALSE)

# Confirm the columns are removed and the file is saved
print(paste("Updated dataset saved at:", file_path))
head(df)
str(df)

#checking missing values
# Convert empty strings ("") to NA for proper missing value handling
df[df == ""] <- NA

# Count missing values in each column
missing_values <- colSums(is.na(df))

# Display missing value count per column
print(missing_values)
#Now starting with some exploratory analysis

# Convert missing values into a dataframe
missing_values_df <- data.frame(Column = names(missing_values), Missing_Count = missing_values)

# Filter only columns where missing values > 0
missing_values_df <- missing_values_df %>% filter(Missing_Count > 0)
# Plot the bar chart
ggplot(missing_values_df, aes(x = Missing_Count, y = reorder(Column, -Missing_Count))) +
  geom_bar(stat = "identity", fill = "steelblue", color = "black") +
  theme_minimal() +
  labs(title = "Missing Values per Column", x = "Column Name", y = "Number of Missing Values") +
  coord_flip()  # Flip axis for better readability

# Define threshold for missing values (e.g., 90% of rows)
threshold <- 0.9 * nrow(df)

# Identify columns with missing values above the threshold
high_missing_cols <- names(missing_values[missing_values > threshold])

# Remove those columns from the dataframe
df <- df %>% select(-all_of(high_missing_cols))

# Save the cleaned dataset
cleaned_file_path <- "C:/Data analytic engineering/Projects/SYST_568_Final_proj/Cleaned_Dataset.csv"
write.csv(df, cleaned_file_path, row.names = FALSE)

# Print confirmation message
print(paste("Columns removed:", paste(high_missing_cols, collapse = ", ")))
print(paste("Cleaned dataset saved at:", cleaned_file_path))

head(df)
summary(df)
str(df)



#RUN FROM THIS LINE****
# Define file path
file_path <- "C:/Data analytic engineering/Projects/SYST_568_Final_proj/Cleaned_Dataset.csv"
# Read the CSV file
df <- read.csv(file_path, stringsAsFactors = FALSE)
str(df)

#Exploratoery analysis
# Convert necessary columns
df$base_severity <- as.factor(df$base_severity)
df$published_date <- as.Date(df$date)
df$base_score <- as.numeric(df$base_score)
df$exploitability_score <- as.numeric(df$exploitability_score)
df$impact_score <- as.numeric(df$impact_score)
df$epss_score <- as.numeric(df$epss_score)
df$epss_perc <- as.numeric(df$epss_perc)

# 1. Bar Chart - Distribution of Base Severity
ggplot(df, aes(x = base_severity, fill = base_severity)) +
  geom_bar() +
  theme_minimal() +
  labs(title = "Distribution of Base Severity", x = "Base Severity", y = "Count")

# 2. Histogram - Distribution of Base Scores
ggplot(df, aes(x = base_score)) +
  geom_histogram(binwidth = 1, fill = "steelblue", color = "black") +
  theme_minimal() +
  labs(title = "Distribution of Base Scores", x = "Base Score", y = "Count")

# 3. Boxplot - Exploitability Score
ggplot(df, aes(y = exploitability_score)) +
  geom_boxplot(fill = "tomato", color = "black") +
  theme_minimal() +
  labs(title = "Boxplot of Exploitability Score", y = "Exploitability Score")

# 4. Correlation Heatmap - Numeric Variables
numeric_cols <- c("base_score", "exploitability_score", "impact_score", "epss_score", "epss_perc")
corr_matrix <- cor(df[numeric_cols], use = "complete.obs")
corrplot(corr_matrix, method = "color", type = "upper", tl.col = "black", tl.srt = 45)

# 5. Time Series Analysis - Number of Vulnerabilities Over Time
df_time_series <- df %>%
  group_by(published_date) %>%
  summarise(count = n())
ggplot(df_time_series, aes(x = published_date, y = count)) +
  geom_line(color = "purple") +
  theme_minimal() +
  labs(title = "Vulnerabilities Published Over Time", x = "Date", y = "Count")

#Filter data from the year 2015 onwards
df_filtered <- df %>% filter(published_date >= as.Date("2015-01-01"))

# Group by published_date to count vulnerabilities per day
df_time_series <- df_filtered %>%
  group_by(published_date) %>%
  summarise(count = n())

# Plot the time series
ggplot(df_time_series, aes(x = published_date, y = count)) +
  geom_line(color = "purple") +
  theme_minimal() +
  labs(title = "Vulnerabilities Published Over Time (2015-Present)", 
       x = "Date", y = "Count")

# 6. Bar Chart - Attack Vector Distribution
ggplot(df, aes(x = attack_vector, fill = attack_vector)) +
  geom_bar() +
  theme_minimal() +
  coord_flip() +
  labs(title = "Distribution of Attack Vectors", x = "Attack Vector", y = "Count")
