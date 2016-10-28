library(dplyr)
library(sqldf)

data <- read.csv("J:\\데이터\\thompson_clean2.csv")

fb <- sqldf("select * from data where Company_Name like 'facebook%'")
write.csv(fb, "J:\\데이터\\facebook.csv")