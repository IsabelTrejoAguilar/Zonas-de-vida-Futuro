library(raster)
library(reshape)

#### Preparacion de matrices ####
#Importat raster de las zonas de vida de cada tiempo
zv <- raster("~/zvh.tif") #presente
zvrcp45c <- raster("~/zvhrcp45c.tif") #2013-2039 rcp 4.5
zvrcp85c <- raster("~/zvhrcp85c.tif") #2013-2039 rcp 8.5

compareRaster(zv, zvrcp45c,zvrcp85c) 

matriz<-rasterToPoints(zv) #area de estudio
m<-matriz[,1:2]
zonas<-stack(zv,zvrcp45c,zvrcp85c) 
m.zonas<-extract(zonas,m) #matriz con zv del presente y futuro por pixel
coor.m.zonas<-as.data.frame(cbind(m,m.zonas))

#para separar los numeros del ID en columnas; LatReg (biotemperatura), 
#Ppt_P (Precipitación) y Phum(Piso de Humedad):

zvh<-as.factor(coor.m.zonas$zvh)
zvh <- colsplit(zvh, names=c("LatReg_P","Ppt_P","Phum_P"))

zvh45c<-as.factor(coor.m.zonas$zvhrcp45c)
zvh45c <- colsplit(zvh45c, names=c("LatReg_45c","Ppt_45c","Phum_45c"))

zvh85c<-as.factor(coor.m.zonas$zvhrcp85c)
zvh85c <- colsplit(zvh85c, names=c("LatReg_85c","Ppt_85c","Phum_85c"))

#Matriz con coordenadas (x y), codigos de las zonas de vida en el presente y futuro (Rcp 4.5 y 8.5)
# más las las columnas de las tres variables para cada tiempo

m_final <-as.data.frame(cbind(coor.m.zonas,zvh,zvh45c,zvh85c))

#Rcp 4.5 - Calcular la diferencia entre los vectores de cada variable entre tiempos.
Lat.vector45<-abs(data.frame(m_final$LatReg_P - m_final$LatReg_45c))
Ppt.vector45<-abs(data.frame(m_final$Ppt_P - m_final$Ppt_45c))
Phum.vector45<-abs(data.frame(m_final$Phum_P - m_final$Phum_45c))

#Rcp 4.5 -Se adiciona una columna: suma.vec45, con la cual es posible identificar 
#las zonas que cambian (suma.vec45 = número diferente a 0)
#o que se mantienen estables (suma.vec45 = 0)
suma.vec45<-(Lat.vector45+Ppt.vector45+Phum.vector45)
suma.vec45<-rename(suma.vec45,c(m_final.LatReg_P...m_final.LatReg_45c ="suma.vec45"))

#Rcp 8.5 - Calcular la diferencia entre los vectores de cada variable entre tiempos.
Lat.vector85<-abs(data.frame(m_final$LatReg_P - m_final$LatReg_85c))
Ppt.vector85<-abs(data.frame(m_final$Ppt_P - m_final$Ppt_85c))
Phum.vector85<-abs(data.frame(m_final$Phum_P - m_final$Phum_85c))

#Rcp 8.5 -Se adiciona una columna: suma.vec45, con la cual es posible identificar 
#las zonas que cambian (suma.vec45 = número diferente a 0)
#o que se mantienen estables (suma.vec85 = 0)
suma.vec85<-(Lat.vector85+Ppt.vector85+Phum.vector85)
suma.vec85<-rename(suma.vec85,c(m_final.LatReg_P...m_final.LatReg_85c ="suma.vec85"))

m_final<-as.data.frame(cbind(m_final,Lat.vector45,Ppt.vector45,Phum.vector45,suma.vec45,
                             Lat.vector85,Ppt.vector85,Phum.vector85,suma.vec85))

m_final<-rename(m_final, c(m_final.LatReg_P...m_final.LatReg_45c="Lat.vec45",
                           m_final.Ppt_P...m_final.Ppt_45c="Ppt.vec45",
                           m_final.Phum_P...m_final.Phum_45c="Phum45.vec",
                           m_final.LatReg_P...m_final.LatReg_85c="Lat.vec85",
                           m_final.Ppt_P...m_final.Ppt_85c="Ppt.vec85",
                           m_final.Phum_P...m_final.Phum_85c="Phum.vec85"))

#Identificar zonas de clima estable (suma.vec45 = 0)
estables45c <-subset(m_final, suma.vec45 == 0)
estables45c <-estables45c[,1:7]
write.csv(estables45c,"estables45c.csv")
estables85c <-subset(m_final, suma.vec85 == 0) 
estables85c <-estables85c[,1:7]
write.csv(estables45c,"estables85c.csv")

#Identificar zonas de clima que cambian (suma.vec45 != 0)
cambio45c <-subset(m_final, suma.vec45 != 0)
cambio.45c<-select(cambio45c,x,y,mexbio2007,zvh,zvhrcp45c,
                   eco_reg,Lat.vec45,Ppt.vec45,Phum45.vec,suma.vec45)
write.csv(cambio.45c,"cambio45c.csv")

cambio85c <-subset(m_final, suma.vec85 != 0) 
cambio.85c<-select(cambio85c,x,y,mexbio2007,zvh,zvhrcp85c,
                   eco_reg,Lat.vec85,Ppt.vec85,Phum.vec85,suma.vec85)
write.csv(cambio85c,"cambio85c.csv")