library(dplyr)
library(sqldf)

data <- read.csv("J:\\데이터\\thompson_clean2.csv")

data <- subset(data, select = -Company_City_Branch_Office)
data <- subset(data, select = -Company_Founded_Date)
data <- subset(data, select = -Company_Business_Description_Short)
data <- subset(data, select = -Firm_Founded_Year__Real_Estate)
data <- subset(data, select = -Firm_Congressional_District)
data <- subset(data, select = -Firm_Founded_Date)
data <- subset(data, select = -Firm_Website)
data <- subset(data, select = -c(Fund_Congressional_District, Fund_Founded_Date))
data <- subset(data, select = -c(Firm_State__Region,Company__Real_Estate, Company_Banking_Relationships, 
                                 Company_Alias_es, Company_Congressional_District, Company_MSA, Company_Metropolitan_Location,
                                 Company_North_American_Location, Company_State__Region,Company_State__Region__Branch_Office,
                                 Company_World_Location, Company_World_Location_Branch_Office, Company_World_Sub_Location, 
                                 Company_World_Sub_Location_Branch_Office, Cumulative_Dividends, Firm_Affiliations, Firm_Area_Code))

data <- subset(data, select = -c(Firm_MSA, Firm_Latest_Fund_Year, Firm_Metropolitan_Location, Firm_North_American_Location,
                                 Firm_World_Location, Firm_World_Sub_Location, First_Investment_Received_Date,
                                 Fund_Area_Code, Fund_County, Fund_MSA, Fund_Metropolitan_Location, Fund_MoneyTree_Region))

data <- subset(data, select = -c(Fund_North_American_Location, Fund_Sequence, Fund_State__Region, 
                                 Fund_World_Location, Fund_World_Sub_Location, Investment_Location__City,
                                 Investment_Location__Nation, Investment_Location__State, Investment_Location__World_Location,
                                 Investment_Location__Zip_Code, Liquidation_Preference, Last_Investment_Received_Date,
                                 Multiple_of_the_Liquidation_Preference, Pay_to_Play_Penalties, Portfolio_Status, Real_Estate_Sector,
                                 Redemption_at_Investor_s_Option, Reorganization_or_Recapitalization))

write.csv(data, "J:\\데이터\\thompson_clean3.csv")