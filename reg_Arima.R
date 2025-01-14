library(forecast)
library(fpp2)
library(fpp3)
data("elecdaily")
head(elecdaily)

demanda = elecdaily[,1]
temp = elecdaily[,3]
temp2 = elecdaily[,3]^2
fest = 1 - elecdaily[,2] 

## Modelo 1

plot(temp,demanda,pch=19,cex=1.2)

m1 = lm(demanda ~ temp + temp2)

summary(m1)
#Nos permite predecir la demanda de un día teniendo T con un error de 19 GWh

t = seq(from=10,to=45,by=.1)
y1 = 387.7 - 15.28*t +0.3237*t^2
lines(t,y1,col="black",lw=2)

# Modelo 2

plot(temp,demanda,
     col=fest+1,pch=19,cex=1.2)
#Separamos dia laboral y festivo

m2 = lm(demanda ~
          temp + temp2 + fest)
summary(m2)
#A igualdad de horas, el festivo tiene un consumo de 35 GWH menor. Menos error, el festivo diferencia bien. 

y1 = 361.54 - 15.16*t +0.3223*t^2
lines(t,y1,col="red",lwd=2)
y2 = 361.54 - 15.16*t +0.3223*t^2 +35.2
lines(t,y2,col="black",lwd=2)
#El error es la distancia del punto a la recta
u=residuals(m2)
#vemos si son ruido blanco
tsdisplay(u) #no son ruido blanco, buscamos modelo arima


# Modelo 3
#Para trabajar con fechas

f1=as.Date("2014-01-01") #Las declaras como fechas
f2=as.Date("2014-12-31")
fechas=seq(from=f1,to=f2,by="day")
diasem = factor(wday(fechas)) #wday da el día de la semana-->1 es domingo
dom = as.numeric(diasem ==1)
sab = as.numeric(diasem ==7)
fiesta = fest - dom -sab
m3 = lm(demanda ~ temp + temp2 + dom + sab + fiesta)
summary(m3)
#Aunque el error global no cambie mucho (10.52) al estimar en un festivo ves que sí afecta

# Modelo 4
m4 = lm(log(demanda) ~ temp + temp2 + dom + sab + fiesta)
summary(m4)
#Es muy habitual trabajar con logaritmos
#El domingo respecto a un dia laborable hay un 18% menos de demanda
#El error es 4.17%, para normalizarlo --> mean(demanda)*0.0487. Si la demanda es muy alta habría más error y si
#es baja pues menos
mean(demanda)*0.0487


# Modelo 5 : reg-Arima

X = cbind(temp, temp2,dom,sab,fiesta)
View(cbind(X,demanda))

m5 = auto.arima(demanda,xreg=X)
m5
sqrt(m5$sigma2) #mejora bastante
checkresiduals(m5) #vemos que el modelo no es perfecto, que fallan cositas

pred1=forecast(m5,xreg = cbind(temp=26,temp2=26^2,dom=0,sab=0,fiesta=0))

pred2=forecast(m5,xreg = cbind(temp=rep(26,7),
                         temp2=rep(26^2,7),
                         dom=c(0,0,0,1,0,0,0),
                         sab=c(0,0,1,0,0,0,0),
                         fiesta=c(1,0,0,0,0,0,0)))
pred1
plot(pred2)
autoplot(pred2)

# Modelo 6 : reg-Arima
#Con influencia de la temperatura
temp_r = c(24,temp[1:364]) #temperatura del día anterior
temp_r2=temp_r^2
X1 = cbind(temp,temp2,temp_r,temp_r2,sab,dom,fiesta)

m6 = auto.arima(demanda,xreg=X1)
m6
