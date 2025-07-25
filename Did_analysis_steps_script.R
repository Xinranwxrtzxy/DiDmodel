
# Load required libraries
library(tidyverse)
library(car)
library(stargazer)

# Load pre-combined long-format data
# Expected columns: SRVYID, treatment, time, Q3, demographics (e.g., age, gender, region, etc.)
data <- read.csv("data/combined_long_data.csv")  # <-- Update this path

# Rename time points
data$time <- recode(data$time, "'base'='timeA'; 'mid'='timeB'; 'post'='timeC'")

# Create dummy variables for time periods
data$timeB <- ifelse(data$time == "timeB", 1, 0)
data$timeC <- ifelse(data$time == "timeC", 1, 0)

# Numeric time variable for general interaction
data$time_num <- recode(data$time, "'timeA'=1; 'timeB'=2; 'timeC'=3")

# Difference-in-Differences interaction terms
data$did_B <- data$treatment * data$timeB
data$did_C <- data$treatment * data$timeC
data$did_all <- data$treatment * data$time_num

# Recode Q3 as binary outcome: 1 = "Yes", 0 = "Not Yes"
data$Q3_bin <- recode(data$Q3, "2=1; 3=0; 4=0; 5=0")

# OPTIONAL: Convert demographics to factor or binary if needed
# Example demographic variables: gender (Q_gender), age group (Q_agegrp), region (Q_region)
data$Q_gender <- factor(data$Q_gender)
data$Q_agegrp <- factor(data$Q_agegrp)
data$Q_region <- factor(data$Q_region)

# Subsets for modeling
mod_data_B <- data %>% filter(time != "timeC")
mod_data_C <- data %>% filter(time != "timeB")
mod_data_BC <- data %>% filter(time %in% c("timeB", "timeC"))

# Logistic regression with demographics
mod_Q3_B <- glm(Q3_bin ~ treatment + timeB + did_B + Q_gender + Q_agegrp + Q_region,
                data = mod_data_B, family = binomial)

mod_Q3_C <- glm(Q3_bin ~ treatment + timeC + did_C + Q_gender + Q_agegrp + Q_region,
                data = mod_data_C, family = binomial)

mod_Q3_BC <- glm(Q3_bin ~ treatment + timeC + did_C + Q_gender + Q_agegrp + Q_region,
                 data = mod_data_BC, family = binomial)

# Output model summaries
summary(mod_Q3_B)
summary(mod_Q3_C)
summary(mod_Q3_BC)

# Confidence intervals for odds ratios
mod_Q3_B_CI <- exp(confint(mod_Q3_B))
mod_Q3_C_CI <- exp(confint(mod_Q3_C))

# Export DiD model results to HTML
stargazer(mod_Q3_B, mod_Q3_C,
          type = "html",
          column.labels = c("TimeA–TimeB", "TimeA–TimeC"),
          dep.var.labels = "Q3 Binary Outcome",
          covariate.labels = c(
            "Intercept", "Treatment",
            "Time: A to B", "Treatment × B",
            "Time: A to C", "Treatment × C",
            "Gender (ref)", levels(data$Q_gender)[-1],
            "Age Group (ref)", levels(data$Q_agegrp)[-1],
            "Region (ref)", levels(data$Q_region)[-1]
          ),
          apply.coef = exp,
          ci.custom = list(mod_Q3_B_CI, mod_Q3_C_CI),
          t.auto = FALSE,
          p.auto = FALSE,
          ci = TRUE,
          single.row = TRUE,
          out = "output/DiD_Q3_demographics.html")
