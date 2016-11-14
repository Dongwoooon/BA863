library(dplyr)
library(sqldf)

data <- read.csv("J:\\데이터\\internet_ipo_with_sic.csv")

#uber 뽑기
ub <- sqldf("select * from data where Company_Name like 'Uber%'")
ubt = subset(ub, Company_Name=='Uber Technologies Inc')
write.csv(ubt, "J:\\데이터\\uber.csv")

names(data)  #sic code 어딨니
freq <- count(data, data[,43])   #sic 몇 종류 있니
freq <- arrange(freq,-n)

freq <- count(data, data[,15])   #nation 몇 종류 있ㄴ
freq <- arrange(freq,-n)

bynation <- group_by(data, Company_Nation)   #nation으로 묶어 봐
nation <- summarise(bynation, company=n_distinct(Company_Name))   #nation에 따른 회사 수 보자
nation <- arrange(nation, -company)

#역시 미국이 짱이었다...

US <- sqldf("select * from data where Company_Nation=='United States'")  #미국만 좀 골라보자
US_company = distinct(US, Company_Name)
US_company <- arrange(US_company, Company_Name)
US_BM = distinct(US, Company_VE_Primary_Industry_Sub_Group_3)
US_BM <- arrange(US_BM, Company_VE_Primary_Industry_Sub_Group_3)
write.csv(US, "J:\\데이터\\US_internet_ipo_with_sic.csv")

#회사 name 뽑기
data<- read.csv("J:\\데이터\\US_internet_ipo_with_sic.csv")기
US_name <- distinct(data, Company_Name)
write.table(US_name, "J:\\데이터\\US_internet_ipo_companyname.txt", quote=FALSE, row.names=FALSE, col.names=FALSE)