# beer_2.R
# accompanying lecture notes for KFoster class ECO B2000 at CCNY

load("beer_iv_data.RData")
# this dataset has the following variables
# was created by beer_1.R program (in this directory)
# all of the variables started with matrix years 1997-2011 as columns, 51 states (incl DC) as rows
# then these matrices were stacked into a single long vector
# --
# growth_rates - growth of state GDP
# gdp_pc, gdp_L - level and lagged level of state GDP
# beertax,spirits_tax - tax on beer & spirits (spirits is fewer years though so wrong length)
# beer_pc,wine_pc,spirits_pc - per-capita consumption of beer wine spirits
# spirits_L,wine_L,beer_L - lagged per-capita consumtion
# july_temp,CDD - highest temp in July (usually hottest month) that year, also Cooling Degree Days
# frac_metal,frac_glass,frac_refill,frac_draft - fraction of beer in each type of container
# st_fixedeff - state fixed effects

regression1 <- lm(growth_rates ~ beer_pc + gdp_L + as.factor(st_fixedeff), data = beer_iv_dat)
summary(regression1)

# but want instruments for beer consumption per capita (beer_pc), authors suggest beertax
# simple summary in http://www.r-bloggers.com/a-simple-instrumental-variables-problem/
iv_reg1 <- lm(beer_pc ~ beertax, data = beer_iv_dat)
summary(iv_reg1)
pred_beer <- predict(iv_reg1)
# iv_reg2 <- lm(beer_pc ~ beertax + CDD + july_temp)
# summary(iv_reg2)

iv_reg2 <- lm(growth_rates ~ pred_beer + gdp_L + as.factor(st_fixedeff), data = beer_iv_dat)
summary(iv_reg2)

library(AER)
iv_reg_package1 <- ivreg(growth_rates ~ beer_pc + gdp_L + as.factor(st_fixedeff) | beertax + gdp_L + as.factor(st_fixedeff), data = beer_iv_dat)
summary(iv_reg_package1)


# more details

# beer tax is weak instrument - state fixed effects explain 94% of var
reg1 <- lm(beertax ~ as.factor(st_fixedeff), data = beer_iv_dat)
summary(reg1)

# what if weather is important so add Cooling Degree Days (number of hot days requiring AC)
iv_reg4 <- lm(beer_pc ~ beertax + CDD, data = beer_iv_dat)
summary(iv_reg4)
pred_beer2 <- predict(iv_reg4)
iv_reg5 <- lm(growth_rates ~ pred_beer2 + gdp_L + as.factor(st_fixedeff), data = beer_iv_dat)
summary(iv_reg5)


iv_reg3 <- lm(beer_pc ~ beertax + beer_L + spirits_L + wine_L, data = beer_iv_dat)
summary(iv_reg3)
pred_beer3 <- predict(iv_reg3)
pred_beer4 <- c(rep(999999,51),pred_beer3)
is.na(pred_beer4) <- (pred_beer4 == 999999)

iv_reg4 <- lm(growth_rates ~ pred_beer4 + beer_L + spirits_L + wine_L + gdp_L + as.factor(st_fixedeff), data = beer_iv_dat)
summary(iv_reg4)

# what if instrument instead for fraction sold on draft not cans or bottles?
iv_reg5 <- lm(frac_draft ~ beertax, data = beer_iv_dat)
summary(iv_reg5)
pred_beer5 <- predict(iv_reg5)

iv_reg6 <- lm(growth_rates ~ pred_beer5 + gdp_L + as.factor(st_fixedeff), data = beer_iv_dat)
summary(iv_reg6)

# iv_reg7 <- lm(spirits_pc ~ spirits_tax)
# summary(iv_reg7)
# pred_spr <- predict(iv_reg7)
# iv_reg8 <- lm(growth_rates ~ pred_beer + pred_spr + gdp_L + as.factor(st_fixedeff))
# summary(iv_reg8)

# try other variations: logs? interactions? lags of packaging? get data for other variables? More years?
