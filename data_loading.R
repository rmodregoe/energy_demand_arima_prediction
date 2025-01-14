library(R.matlab)
library(xts)
library(lubridate)
library(dygraphs)

dat0 = readMat("Demanda_PENR2.mat")
dat = as.data.frame(dat0$Demanda)
colnames(dat)=c("fecha","hora","dem","nose")
plot(dat$dem) #vemos valores atípicos-->cambios de hora

## corrijo cambio de horas
sel = which(dat$dem ==0)
dat$dem[sel] = dat$dem[sel+1]

i=which(diff(dat$dem)>10000)
dat$dem[i+1] = dat$dem[i+1]/2


head(dat)

## Por horas

f0  = dat$fecha[dat$hora == 1]
n = length(f0)
dem = matrix(0,n-1,25)
dem[,1] = f0[-n]
for (h in 1:24){
  x  = dat$dem[dat$hora == h]
  dem[(1:(n-1)),h+1] = x[1:(n-1)]
}
# el Último día no está no está completo, cojo n-1 días
dem = as.data.frame(dem)
names(dem) = c("fecha",paste0("h",1:24))
View(dem)
 #HORA 18

## elegimos de 2010 a 2018
#Para trabajar con fechas
inicio = which(dem$fecha==20110101)
fin = which(dem$fecha==20181231)
dem = dem[inicio:fin,]
View(dem)
yh = ts(dem$h18,frequency = 7) #a las 18 
m0 = auto.arima(yh,approximation = FALSE,stepwise = FALSE,lambda = 0)
m0
sqrt(m0$sigma2)
# El autoarima da ARIMA(0,0,4)(0,1,1)[7], lambda 0

## Temperaturas

dat0 = readMat("TempPrev_PenR2.mat")
fecha=dat0$TempPrev[[1]][,1]
tmax=dat0$TempPrev[[1]][,2]
tmin=dat0$TempPrev[[2]][,2]
temp = data.frame(fecha,tmax,tmin)
inicio2 = which(temp$fecha==20110101)
fin2 = which(temp$fecha==20181231)
temp = temp[inicio2:fin2,]
View(temp) #tengo para cada día la tmaxi y tmin
plot(temp$tmax,type="l")
lines(temp$tmin, col="red")
checkresiduals(m0)#vemos que se ajusta mal y eso que es el autoarima
#el problema son los residuos de los festivos que bajan mucho la demanda
#Tenemos que limpiar los lados de la zona normal de la grafica residuals
dygraph(xt) %>% dyRangeSelector()

## Fiestas

fiesta = readMat("Fiestas_PENR2.mat")
fiestas = fiesta$Fiestas

w = weekdays(ymd(temp$fecha))
sab = ( w == "sábado")
dom = (w == "domingo")


plot(temp$tmax,dem$h14,col="blue")
points(temp$tmax[sab],dem$h14[sab],col="green")
points(temp$tmax[dom],dem$h14[dom],col="red")
m = lm(dem$h14 ~ temp$tmax + I(temp$tmax^2))
summary(m)
