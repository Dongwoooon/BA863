library(dplyr)
library(sqldf)

data <- read.csv("J:\\데이터\\thompson_clean3.csv")

data <- subset(data, select = -c(X.1, X_1, X_1.1, X, Capped_Participating_Preferred, 
                                 Company_Accountant, Company_Area_Code, Company_Legal_Counsel, Company_MoneyTree_Region,
                                 Company_Number_of_Employees, Company_Zip_Code, Company_Zip_Code_Branch_Office, Deal_Value_USD_Mil, 
                                 Debt_Amount_USD_Mil, Firm__First_Investment_Date, Firm__Last_Investment_Date, Firm__Total_Number_of_Deals,
                                 Firm_Latest_Fund_Closing_Date, Firm_Latest_Fund_Name, Firm_Latest_Fund_Size_USD_Mil, Firm_MoneyTree_Region,
                                 Firm_Nation, Firm_Preferred_Investment_Role, Firm_Preferred_Maximum_Investment_USD_Mil,
                                 Firm_Preferred_Minimum_Investment_USD_Mil))

               
data <- subset(data, select = -c(Firm_Industry_Focus, Firm_Status, Firm_Zip_Code, Fund__First_Investment_Date,
                                 Fund__Last_Investment_Date, Fund__Total_Number_of_Deals, Fund_City, Fund_Founded_Year,
                                 Fund_Industry_Focus, Fund_Investor_Type, Fund_Nation, Fund_Size_USD_Mil, Fund_Size_Category_USD_Mil,
                                 Fund_Size_Target_USD_Mil, Fund_Stage, Fund_Status, Fund_Type, Fund_Zip_Code, Investment_Date_1,
                                 Investment_Location__World_Sub_Location))

data <- subset(data, select = -c(MoneyTree_Industry, NAIC_Code, NAIC_Description, New_or_Follow_on_Investment, No_of_Firms_in_Total,
                                 No_of_Funds_Managed_by_Firm, No_of_Funds_at_Investment_Date, No_of_Funds_in_Total,
                                 Total_Estimated_Equity_Invested_by_Firm_to_Date_USD_Mil, Total_Estimated_Equity_Invested_by_Fund_to_Date_USD_Mil,
                                 Total_Known_Equity_Invested_by_Firm_to_Date_USD_Mil, Total_Known_Equity_Invested_by_Fund_to_Date_USD_Mil, Total_Number_of_Companies_Invested_in_by_Firm,
                                 Total_Number_of_Companies_Invested_in_by_Fund, Type_of_Preferred_Stock, Valuation_Direction))

write.csv(data, "J:\\데이터\\thompson_clean4.csv", row.names=FALSE)


# IT만 뽑아와야지
IT <- sqldf("select * from data where Company_VE_Primary_Industry_Class like 'Information%'")
IT <- subset(IT, Company_Technology_Application!='Non-Internet Related')

# cleantech, nanotech 뭔지 거슬린다 확인 ㄱㄱ
Cleanano <- subset(IT, Company_Technology_Application=='Clean Technology' | Company_Technology_Application=='Nanotechnology')
arng.clna<-arrange(Cleanano, Company_Technology_Application, Company_VE_Primary_Industry_Sub_Group_3)
# Cleanano 전부 다 인터넷이랑 상관이 없네 그럼 제거
IT2 <- subset(IT, Company_Technology_Application!='Clean Technology' & Company_Technology_Application!='Nanotechnology')

# B2B 회사는 안 맞아서 제거
IT3 <- subset(IT2, Company_Primary_Customer_Type!='Business' & Company_Technology_Application!='Business Process Outsourcing (BPO)')  

# 이제 뭐 있나 보자
unique(IT3[22]) 

# 인터넷 달린거랑 e-commerce만 추려내야지
IT4 <- sqldf("select * from IT3 where Company_VE_Primary_Industry_Sub_Group_1 like 'Internet%'")
### 하고 봤더니 IT3[21]에 internet specific만 골라 놓은거네... 진작 이걸로 할걸

# IPO 한 놈들만 골라보자
IT.ipo <- subset(IT4, IT4[11]!='-')
count(unique(IT.ipo[15]))   # ipo 회사 몇 개니 - 344개

write.csv(IT4, "J:\\데이터\\internet_with_sic.csv",row.names=FALSE)
write.csv(IT.ipo, "J:\\데이터\\internet_ipo_with_sic.csv",row.names=FALSE)