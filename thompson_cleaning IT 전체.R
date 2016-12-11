library(dplyr)
library(sqldf)

data <- read.csv("J:\\데이터\\thompson_clean4.csv")

# IT 만 뽑기
IT <- sqldf("select * from data where Company_VE_Primary_Industry_Class like 'Information%'")
IT2 <- subset(IT, Company_Technology_Application!='Clean Technology' & Company_Technology_Application!='Nanotechnology')

# IPO 골라내기
IT_ipo <- subset(IT2, IT2[11]!='-')
US.IT <- sqldf("select * from IT_ipo where Company_Nation=='United States'")
count(unique(US.IT[15]))   # IT, IPO 한 기업들 830개
unique(US.IT[19])
unique(US.IT[20])
US_BM = distinct(US.IT, Company_VE_Primary_Industry_Sub_Group_3)
write.csv(US.IT, "J:\\데이터\\US_IT_ipo_with_sic.csv",row.names=FALSE)

