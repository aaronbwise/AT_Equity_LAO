library(haven)
library(anthro)
library(tidyverse)
library(lubridate)
library(dplyr)

setwd("C:/Users/Lindsey/OneDrive - A3DI/Alive & Thrive/3_Country_II")

df <- read_sav("./data/2000/children/ch_2000.sav")

# Create age in days
df$doi <- make_date(year = df$DOIY, month = df$DOIM, day = df$DOID)
df$dob <- make_date(year = df$BR3Y, month = df$BR3M, day = df$BR3D)
df$age_in_days <- as.numeric(difftime(ymd(df$doi), ymd(df$dob), units = 'days'))

# Update length/height variable
df <- df %>% mutate(measure = ifelse(AN2A == 1, "L", "H"))

# remove NA values
df_min <- df %>%
  select(HHMID, HL3, age_in_days, WEIGHT, HEIGHT, measure)

df_min <- df_min %>% drop_na()

zscores <- with(
  df_min,
  anthro_zscores(
    sex = HL3,
    age = age_in_days,
    is_age_in_month = FALSE,
    weight = WEIGHT,
    lenhei = HEIGHT,
    measure = measure
  )
)

zscores <- cbind(HHMID = df_min$HHMID, zscores)

write.csv(zscores, "./data/2000/children/zscores.csv")
