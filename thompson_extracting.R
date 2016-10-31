library(dplyr)
library(sqldf)

data <- read.csv("J:\\데이터\\thompson_clean3.csv")

ub <- sqldf("select * from data where Company_Name like 'Uber%'")
ubt = subset(ub, Company_Name=='Uber Technologies Inc')
write.csv(ubt, "J:\\데이터\\uber.csv")