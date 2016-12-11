library(dplyr)
library(sqldf)

# cik code 붙이기
data <- read.csv("J:\\데이터\\US_internet_ipo_collapsed.csv")
cik <- read.csv("J:\\데이터\\cik code.csv")
merged <- merge(x = data, y = cik, by = "company_name", all.x = TRUE)
data<-merged
remove(merged)

# ipoyear 붙이기
ipoyear <- read.csv("J:\\데이터\\US_internet_ipo_ipoyear.csv")
merged <- merge(x = data, y = ipoyear, by = "company_name", all.x = TRUE)
data<-merged
remove(merged)
write.csv(data, "J:\\데이터\\US_internet_ipo_collapsed_cik_ipoyear.csv", row.names=FALSE)

# Nasdaq 붙이기
nsdq <- read.csv("J:\\데이터\\NASDAQ_Yearly.csv")
names(nsdq)[1] <- 'company_ipo_year'
names(nsdq)[5] <- 'NASDAQ'
nsdq <- subset(nsdq, select=c(company_ipo_year,NASDAQ))
merged <- merge(x = data, y = nsdq, by = "company_ipo_year", all.x = TRUE)
merged <- arrange(merged, company_name)
data<-merged
remove(merged)

# months to ipo 붙이기
month<-read.csv("J:\\데이터\\monthtoipo.csv")
merged <- merge(x = data, y = month, by = "company_name", all.x = TRUE)
data<-merged
remove(merged)

# ipo, post-ipo sales, asset 뽑기
data <- read.csv("J:\\데이터\\US_internet_ipo_collapsed_cik_ipoyear.csv")
fin <- read.csv("J:\\데이터\\US_internet_ipo_revenue asset.csv")
merged <- merge(x = fin, y = data, by = "company_cik", all.x = TRUE)

merged <- subset(merged, select = c(company_cik, fyear, at, revt, company_name, company_ipo_year))
ipo.fin <- sqldf("select * from merged where fyear==company_ipo_year")
p.ipo1 <- sqldf("select * from merged where fyear==company_ipo_year+1")
p.ipo2 <- sqldf("select * from merged where fyear==company_ipo_year+2")
p.ipo3 <- sqldf("select * from merged where fyear==company_ipo_year+3")

ipo.fin <- subset(ipo.fin, select = c(company_cik,at,revt)) #ipo당시 at, revt
p.ipo1 <- subset(p.ipo1, select = c(company_cik,at,revt))   #ipo 1년 후 at, revt
p.ipo2 <- subset(p.ipo2, select = c(company_cik,at,revt))   #ipo 2년 후 at, revt
p.ipo3 <- subset(p.ipo3, select = c(company_cik,at,revt))   #ipo 3년 후 at, revt

names(ipo.fin)[2]="at0"        #하...ㅅㅂ 이름 바꿔줘야하ㄴ
names(ipo.fin)[3]="revt0"
names(p.ipo1)[2]="at1"
names(p.ipo1)[3]="revt1"
names(p.ipo2)[2]="at2"
names(p.ipo2)[3]="revt2"
names(p.ipo3)[2]="at3"
names(p.ipo3)[3]="revt3"

# 하...ㅅㅂ 중복 제거해야해
df_ipo0 <- data.frame(matrix(ncol = 3, nrow = 0))  # 중복 없앨 새 df 만들자
for (i in 1:3){
  names(df_ipo0)[i]=names(ipo.fin)[i]
}       
a=1      # 만약 밑에랑 이름 똑같다면 버리고 다르면 새 df에 넣자
for (i in 1:nrow(ipo.fin)){
  if (i<nrow(ipo.fin)){
    if (ipo.fin[i,1]!=ipo.fin[i+1,1]){
      df_ipo0[a,]<-ipo.fin[i,]
      a=a+1
    }
  }
  else{
    df_ipo0[a,]<-ipo.fin[i,]
  }
}
remove(ipo.fin)

df_ipo1 <- data.frame(matrix(ncol = 3, nrow = 0))
for (i in 1:3){
  names(df_ipo1)[i]=names(p.ipo1)[i]
} 
a=1
for (i in 1:nrow(p.ipo1)){
  if (i<nrow(p.ipo1)){
    if (p.ipo1[i,1]!=p.ipo1[i+1,1]){
      df_ipo1[a,]<-p.ipo1[i,]
      a=a+1
    }
  }
  else{
    df_ipo1[a,]<-p.ipo1[i,]
  }
}
remove(p.ipo1)

df_ipo2 <- data.frame(matrix(ncol = 3, nrow = 0))
for (i in 1:3){
  names(df_ipo2)[i]=names(p.ipo2)[i]
} 
a=1
for (i in 1:nrow(p.ipo2)){
  if (i<nrow(p.ipo2)){
    if (p.ipo2[i,1]!=p.ipo2[i+1,1]){
      df_ipo2[a,]<-p.ipo2[i,]
      a=a+1
    }
  }
  else{
    df_ipo2[a,]<-p.ipo2[i,]
  }
}
remove(p.ipo2)

df_ipo3 <- data.frame(matrix(ncol = 3, nrow = 0))
for (i in 1:3){
  names(df_ipo3)[i]=names(p.ipo3)[i]
} 
a=1
for (i in 1:nrow(p.ipo3)){
  if (i<nrow(p.ipo3)){
    if (p.ipo3[i,1]!=p.ipo3[i+1,1]){
      df_ipo3[a,]<-p.ipo3[i,]
      a=a+1
    }
  }
  else{
    df_ipo3[a,]<-p.ipo3[i,]
  }
}
remove(p.ipo3)

data <- merge(x = data, y = df_ipo0, by = "company_cik")  #ipo 당시 재무정보 무조건 필요
data <- merge(x = data , y = df_ipo1, by = "company_cik", all.x = TRUE)
data <- merge(x = data , y = df_ipo2, by = "company_cik", all.x = TRUE)
data <- merge(x = data , y = df_ipo3, by = "company_cik", all.x = TRUE)
data <- arrange(data,company_name)

# CAGR 계산
atcagr1 <- data$at1/data$at0-1
atcagr2 <- (data$at2/data$at0)^(1/2)-1
atcagr3 <- (data$at3/data$at0)^(1/3)-1
data$atcagr1 <- 100*atcagr1
data$atcagr2 <- 100*atcagr2
data$atcagr3 <- 100*atcagr3

revtcagr1 <- data$revt1/data$revt0-1
revtcagr2 <- (data$revt2/data$revt0)^(1/2)-1
revtcagr3 <- (data$revt3/data$revt0)^(1/3)-1
data$revtcagr1 <- 100*revtcagr1
data$revtcagr2 <- 100*revtcagr2
data$revtcagr3 <- 100*revtcagr3

write.csv(data, "J:\\데이터\\US_internet_ipo_merged.csv",row.names=FALSE)