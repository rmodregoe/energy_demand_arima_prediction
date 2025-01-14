library(R.matlab)
library(xts)
library(lubridate)
library(dygraphs)

dat0 = readMat("Demanda_PENR2.mat")
dat = as.data.frame(dat0$Demanda)
colnames(dat)=c("fecha","hora","dem","nose")

## corrijo cambio de horas
sel = which(dat$dem ==0)
dat$dem[sel] = dat$dem[sel+1]

i=which(diff(dat$dem)>10000)
dat$dem[i+1] = dat$dem[i+1]/2


head(dat)
ti <- seq(from = as.POSIXct("2000-01-01 01:00"), 
          to = as.POSIXct("2022-01-26 10:00"), by = "hour")
n = length(ti)
xt = xts(dat$dem[1:n],order.by = ti)
dygraph(xt) %>% dyRangeSelector()

## Por horas

f0  = dat$fecha[dat$hora == 1]
n = length(f0)
dem = matrix(0,n-1,25)
dem[,1] = f0[-n]
for (h in 1:24){
  x  = dat$dem[dat$hora == h]
  dem[(1:(n-1)),h+1] = x[1:(n-1)]
}
# el último día no está completo, cojo n-1 días
dem = as.data.frame(dem)
names(dem) = c("fecha",paste0("h",1:24))

## selección de una hora


f1 = ymd(f0[-n]) #quito el último

yt = xts(dem$h10,order.by = f1)
dygraph(yt) %>% dyRangeSelector()

