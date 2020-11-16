# beer_1.R
# accompanying lecture notes for KFoster class ECO B2000 at CCNY

# -----------------------------------------
# Beer  
# following Cesur & Kelly (2013), "Who Pays the Bar Tab? Beer Consumption and Economic Growth in the United States," Economic Inquiry. 
# -----------------------------------------
# of course, those authors are judged innocent of anything I do!

rm(list = ls(all = TRUE))

setwd("C:\\Users\\Kevin\\Documents\\CCNY\\data for classes\\beer_data")
# each csv has years 1997-2011 as columns, 51 states (incl DC) as rows
growth_rates <- as.matrix(read.csv("growth.csv", header = FALSE))
beertax <- as.matrix(read.csv("beertax.csv", header = FALSE))
gdp_pc <- as.matrix(read.csv("gdp_pc.csv", header = FALSE))
spirits_pc <- as.matrix(read.csv("spirits_pc.csv", header = FALSE))
wine_pc <- as.matrix(read.csv("wine_pc.csv", header = FALSE))
beer_pc <- as.matrix(read.csv("beer_pc.csv", header = FALSE))
spirits_tax <- as.matrix(read.csv("spiritstax1.csv", header = TRUE))
# spirits tax info from  Distilled Spirits Council of the United States, Tax Foundation 

# this data from NCDC NOAA web
july_temp <- as.matrix(read.csv("july_temp.csv", header = FALSE))
CDD <- as.matrix(read.csv("CDD.csv", header = FALSE))
# 

# make lags - long coding but a bit more evident what's going on
gdp_L <- c(rep(999999,51),gdp_pc[,1],gdp_pc[,2],gdp_pc[,3],gdp_pc[,4],gdp_pc[,5],gdp_pc[,6],gdp_pc[,7],gdp_pc[,8],gdp_pc[,9],gdp_pc[,10],gdp_pc[,11],gdp_pc[,12],gdp_pc[,13],gdp_pc[,14])
is.na(gdp_L) <- (gdp_L == 999999)

spirits_L <- c(rep(999999,51),spirits_pc[,1],spirits_pc[,2],spirits_pc[,3],spirits_pc[,4],spirits_pc[,5],spirits_pc[,6],spirits_pc[,7],spirits_pc[,8],spirits_pc[,9],spirits_pc[,10],spirits_pc[,11],spirits_pc[,12],spirits_pc[,13],spirits_pc[,14])
is.na(spirits_L) <- (spirits_L == 999999)
wine_L <- c(rep(999999,51),wine_pc[,1],wine_pc[,2],wine_pc[,3],wine_pc[,4],wine_pc[,5],wine_pc[,6],wine_pc[,7],wine_pc[,8],wine_pc[,9],wine_pc[,10],wine_pc[,11],wine_pc[,12],wine_pc[,13],wine_pc[,14])
is.na(wine_L) <- (wine_L == 999999)
beer_L <- c(rep(999999,51),beer_pc[,1],beer_pc[,2],beer_pc[,3],beer_pc[,4],beer_pc[,5],beer_pc[,6],beer_pc[,7],beer_pc[,8],beer_pc[,9],beer_pc[,10],beer_pc[,11],beer_pc[,12],beer_pc[,13],beer_pc[,14])
is.na(beer_L) <- (beer_L == 999999)

vec_miss <- rep(999999,51) # since missing 1997-2000
spirits_tax <- cbind(vec_miss,vec_miss,vec_miss,vec_miss,spirits_tax)

# this vectorizes the matrixes
NN_TT <- dim(growth_rates)
tot_N <- NN_TT[1]*NN_TT[2]

dim(growth_rates) <- c(tot_N,1)
dim(gdp_pc) <- c(tot_N,1)
dim(beertax) <- c(tot_N,1)
dim(spirits_pc) <- c(tot_N,1)
dim(wine_pc) <- c(tot_N,1)
dim(beer_pc) <- c(tot_N,1)
dim(spirits_tax) <- c(tot_N,1)
dim(july_temp) <- c(tot_N,1)
dim(CDD) <- c(tot_N,1)

# state fixed effects
st_fixedeff <- rep(1:51,15)

frac_metal <- as.matrix(read.csv("frac_metal.csv", header = FALSE))
frac_glass <- as.matrix(read.csv("frac_glass.csv", header = FALSE))
frac_refill <- as.matrix(read.csv("frac_refill.csv", header = FALSE))
frac_draft <- as.matrix(read.csv("frac_draft.csv", header = FALSE))

#beer_states <- data.frame(cbind(growth_rates, gdp_pc, beertax, spirits_pc, wine_pc, beer_pc, spirits_tax, gdp_L, spirits_L, wine_L, beer_L, frac_metal, frac_glass, frac_refill, frac_draft))


is.na(frac_metal) <- (frac_metal == 999999)
is.na(frac_glass) <- (frac_glass == 999999)
is.na(frac_refill) <- (frac_refill == 999999)
is.na(frac_draft) <- (frac_draft == 999999)
is.na(growth_rates) <- (growth_rates == 999999)
is.na(gdp_pc) <- (gdp_pc == 999999)
is.na(beertax) <- (beertax == 999999)
is.na(spirits_pc) <- (spirits_pc == 999999)
is.na(wine_pc) <- (wine_pc == 999999)
is.na(beer_pc) <- (beer_pc == 999999)
is.na(spirits_tax) <- (spirits_tax == 999999)
is.na(gdp_L) <- (gdp_L == 999999)
is.na(spirits_L) <- (spirits_L == 999999)
is.na(wine_L) <- (wine_L == 999999)
is.na(beer_L) <- (beer_L == 999999)
is.na(july_temp) <- (july_temp == 999999)
is.na(CDD) <- (CDD == 999999)

beer_iv_dat <- data.frame(growth_rates,gdp_pc,beertax,beer_pc,wine_pc,spirits_pc,gdp_L,spirits_L,wine_L,beer_L,july_temp,CDD,frac_metal,frac_glass,frac_refill,frac_draft,spirits_tax,st_fixedeff)

save(beer_iv_dat, file = "beer_iv_data.RData")


