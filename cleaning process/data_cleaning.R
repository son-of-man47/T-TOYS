library(tidyverse)
library(janitor)
library(dplyr)
library(readr)
library(stringr)
library(lubridate)


sales  <- "C:/Users/IROANYA/Documents/DATA ANALYSIS FILES/Data Sets/sales_data_sample.csv"

dt = read.csv(sales)
View(dt)

############cleaning the column names

df = clean_names(dt)
View(df)


###checking the datatype of each column

str(df)


####number of rows and column
print(paste(nrow(df), ncol(df), sep = " "))


######cleaning the data

###checking for na values and empty spaces

colSums(is.na(df))

empty_spaces(df, "")


#####dropping columns with empty values and na values bezause they are much

df = subset(df, select = -c (territory, state, addressline2, postalcode))
View(df)


#####joining the contactfirstname and lastname to create a new column and move it

##joining the columns because they are character columns
df$contactnames = paste(df$contactfirstname, df$contactlastname, sep = " ")
View(df)

##dropping the columns
df = subset(df, select = -c(contactfirstname, contactlastname))

##moving the created column
df = df %>% relocate(contactnames, .before = phone)



#################dropping the sales column and creating a new one

##Dropping the original ssales
df = df %>% subset(select = -c(sales))

##creating a new one using transform because they are numeric columns

df = df %>% transform(sales = ifelse(quantityordered != priceeach, quantityordered *
                                       priceeach))
View(df)

df = df %>% relocate(sales, .before = orderlinenumber)




#####moving msrp and productline

df = df %>% relocate(msrp, .before = orderlinenumber)
df = df %>% relocate(productline, .before = quantityordered)



######creating an expected sales column and a profit/loss column

df$expsales = df$msrp * df$quantityordered
df$profit_loss = df$sales - df$expsales

##moving the columns 
df = df %>% relocate(expsales, profit_loss, .before = orderlinenumber)


####converting the dates to extract the month da and year from the date

##3selecting out the date
dts = df %>% select(orderdate)

###splitting the date and the time
dts[c("date", "time")] = str_split_fixed(dts$orderdate, "\\ ", 2)

##converting the date to date format
dts$date  = mdy(dts$date)

##dropping the original date and time
dts = dts %>% subset(select = -c(time, orderdate))

##extravting the month
dts$monthordered = format(dts$date, "%B")

##extracting year and day

dts$yearorders = format(dts$date, "%Y")
dts$dayordered = format(dts$date, "%d")
View(dts)

###DROPPING THE DATE COLUMN IN DTS AND ORDERDATE COLUMN IN DF

df = df %>% subset(select = -c(orderdate))

dts = dts %>% subset(select = -c(date))


####joining df and dts together

df = cbind(df, dts)
View(df)


###moving the added columns

df = df %>% relocate(monthordered, dayordered, yearorders, .before = qtr_id)

###dropping year_id and month_id

df = df %>% subset(select = -c(month_id, year_id))

View(df)


####moving dealsize

df = df %>% relocate(dealsize, .before = priceeach)
