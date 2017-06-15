# Script for calculating basic statistics for ecoregions and protected areas inside ecoregions
# Author: D. Ramírez-Mejía
# Date: 04.2017

rm(list=ls(all=TRUE))


setwd("Z:/CoberturasRestringidas/Mexbio_corregido/Old_version/")
getwd()
list.files(getwd())

#--- Packages ---

library(rgeos)
library(raster)
library(maptools)
library(sp)


# --- Read MEXBIO raster files ---

projLambert_WSG84 <- "+proj=lcc +lat_1=17.5 +lat_2=29.5 +lat_0=12 +lon_0=-102 +x_0=2500000 +y_0=0 +datum=WGS84 +units=m +no_defs" #Mexico
edos <- readShapePoly("Z:/Coberturas/DEST_2012/DEst_2012.shp", IDvar=NULL, proj4string=CRS(projLambert_WSG84))
dem <- raster("Z:/CoberturasRestringidas/DEM/DEM_Mex_1km.tif")
mexbio_01 <- raster("MEXBIO_2001_cw.tif")
mexbio_07 <- raster("MEXBIO_2007_cw.tif")
mexbio_10 <- raster("MEXBIO_2010_cw.tif")
mexbio <- list(mexbio_01, mexbio_07, mexbio_10)

set_extent_fun <- function(raster_stack, shape_file){
  
  prj_raster <- list()
  res_raster <- list()
  crop_raster <- list()
  set_raster <- list()
  
  for (i in 1:length(raster_stack)) {
    prj_raster[[i]] <- projectRaster(raster_stack[[i]], crs=projLambert_WSG84, res=1000)
    res_raster[[i]] <- resample(prj_raster[[i]], dem, "bilinear")
    crop_raster[[i]] <- crop(res_raster[[i]], extent(shape_file))
    set_raster[[i]] <- mask(crop_raster[[i]], shape_file)
  }
  
  return(set_raster)
  
}

set_extent_mexbio <- set_extent_fun(mexbio, edos)

# --- save MEXBIO raster files  ---

setwd("Z:/CoberturasRestringidas/Mexbio_corregido/Old_version/Set_extent")
for (i in 1:length(set_extent_mexbio)){
  writeRaster(set_extent_mexbio[[i]], filename=paste(names(set_extent[[i]]), "_mx.tif", sep=""), 
              datatype="FLT4S", NAflag=3.4e+38,  format="GTiff", overwrite=TRUE)
}


# --- Read ECOREGIONS and ANP shape files ---
ecoreg <- readShapePoly("Z:/Coberturas/Ecorre_terr_2008/ecorregiones_2008_c/ecort08cw.shp", IDvar=NULL, proj4string=CRS(projLambert_WSG84))
anp <- readShapePoly("Z:/Coberturas/ANP_2017_federales/181ANP_WGS1984_c.shp", IDvar=NULL, proj4string=CRS(projLambert_WSG84))

### Extract protected areas by year 
anp_t <- crop(anp, edos)
anp_t@data$YEAR <- gsub("-.*","",anp_t@data$PRIM_DEC)
anp_t@data <- (arrange(anp_t@data, YEAR))
anp_t@data$ID <- seq.int(nrow(anp_t@data))

anp_t_2001 <- anp_t[anp_t@data$YEAR <= "2001",]
anp_t_2007 <- anp_t[anp_t@data$YEAR <= "2007",]
anp_t_2010 <- anp_t[anp_t@data$YEAR <= "2010",]

anpT <- c(anp_t_2001,anp_t_2007,anp_t_2010)

# --- Dissolve to ecoregion level N1 ---
ecoreg_n1 <- gUnaryUnion(ecoreg, id = ecoreg@data$CVEECON1)
levels(ecoreg@data$DESECON1)

calif_med <- gUnaryUnion(ecoreg[ecoreg@data$DESECON1=="California Mediterranea",])
des_am_norte <- gUnaryUnion(ecoreg[ecoreg@data$DESECON1=="Desiertos de America del Norte",])
elev_semar_meri <- gUnaryUnion(ecoreg[ecoreg@data$DESECON1=="Elevaciones Semiaridas Meridionales",])
grandes_plan <- gUnaryUnion(ecoreg[ecoreg@data$DESECON1=="Grandes Planicies",])
selvas_cal_hum <- gUnaryUnion(ecoreg[ecoreg@data$DESECON1=="Selvas Calido-Humedas",])
selvas_cal_sec <- gUnaryUnion(ecoreg[ecoreg@data$DESECON1=="Selvas Calido-Secas",])
sierras_tem <- gUnaryUnion(ecoreg[ecoreg@data$DESECON1=="Sierras Templadas",])

ecoN1 <- c(calif_med, des_am_norte, elev_semar_meri, grandes_plan, selvas_cal_hum, selvas_cal_sec, sierras_tem)

# --- Erase ANP from Ecoregion shape ---

eco_noANP <- function (eco_stack, anp_file) {
  
  eco_buffer <- list()
  eco_diff <- list()
  anp_buff <- gBuffer(anp_file, byid=TRUE, width=0)
  
  for (i in 1:length(eco_stack)){
    eco_buffer[[i]] <- gBuffer(eco_stack[[i]], byid=TRUE, width=0)
    eco_diff[[i]] <- gDifference(eco_buffer[[i]], anp_buff)
  }
  
  return(eco_diff)
  
}

ecoN1_noANP_2001 <- eco_noANP(ecoN1, anpT[[1]])
ecoN1_noANP_2007 <- eco_noANP(ecoN1, anpT[[2]])
ecoN1_noANP_2010 <- eco_noANP(ecoN1, anpT[[3]])

# --- Extract ANP by Ecoregion ---

eco_ANP <- function (eco_stack, anp_file) {
  
  eco_buffer <- list()
  eco_anp <- list()
  anp_buff <- gBuffer(anp_file, byid=TRUE, width=0)
  
  for (i in 1:length(eco_stack)){
    eco_buffer[[i]] <- gBuffer(eco_stack[[i]], byid=TRUE, width=0)
    eco_anp[[i]] <- gIntersection(eco_buffer[[i]], anp_buff)
  }
  
  return(eco_anp)
  
}

ecoN1_ANP_2001 <- eco_ANP(ecoN1, anpT[[1]])
ecoN1_ANP_2007 <- eco_ANP(ecoN1, anpT[[2]])
ecoN1_ANP_2010 <- eco_ANP(ecoN1, anpT[[3]])


# --- MEXBIO: Ecoregion (without Protected Areas) --- 

set_extent_eco <- function(raster, shps_stack){
  
  crop_x <- list()
  set_x <- list()
  for (i in 1:length(shps_stack)) {
    crop_x[[i]] <- crop(raster, extent(shps_stack[[i]]))
    set_x[[i]] <- mask(crop_x[[i]], shps_stack[[i]])
  }
  
  return(set_x)
  
}

mexbio01_eco <- set_extent_eco(mexbio_01, ecoN1_noANP_2001)
mexbio07_eco <- set_extent_eco(mexbio_07, ecoN1_noANP_2007)
mexbio10_eco <- set_extent_eco(mexbio_10, ecoN1_noANP_2010)


# --- MEXBIO: Protected Areas by Ecoregion --- 

mexbio01_eco_anp <- set_extent_eco(mexbio_01, ecoN1_ANP_2001)
mexbio07_eco_anp <- set_extent_eco(mexbio_07, ecoN1_ANP_2007)
mexbio10_eco_anp <- set_extent_eco(mexbio_10, ecoN1_ANP_2010)

# --- STATS ---
# Set ecoregion name
names_eco <- c("calif_med","des_am_norte","elev_semar_meri","grandes_plan","selvas_cal_hum","selvas_cal_sec","sierras_tem")
eco_name <-  function(raster_stack){
  for (i in 1:length(raster_stack)){
    names(raster_stack[[i]]) <- names_eco[i]
  }
  return(raster_stack)
}


mexbio01_eco <- eco_name(mexbio01_eco)
mexbio07_eco <- eco_name(mexbio07_eco)
mexbio10_eco <- eco_name(mexbio10_eco)
mexbio01_eco_anp <- eco_name(mexbio01_eco_anp)
mexbio07_eco_anp <- eco_name(mexbio07_eco_anp)
mexbio10_eco_anp <- eco_name(mexbio10_eco_anp)


### Function to calculate stats

mexbio_eco_anp_stats <- function (raster_stack) {

  mexbio_anp_mean <- c()
  mexbio_anp_median <- c()
  mexbio_anp_quantile <- c()
  mexbio_anp_sd <- c()
  
  for (i in 1:length(raster_stack)){
    
    mexbio_anp_mean[[i]] <- unlist(data.matrix(cellStats(raster_stack[[i]], 'mean')))
    mexbio_anp_median[[i]] <- unlist(data.matrix(median(raster_stack[[i]], na.rm = TRUE)))
    mexbio_anp_quantile[[i]] <- unlist(data.matrix(quantile(raster_stack[[i]])))
    mexbio_anp_sd[[i]] <- unlist(data.matrix(cellStats(raster_stack[[i]], 'sd')))
  }
  
  return(list(mexbio_anp_mean, mexbio_anp_median, mexbio_anp_quantile, mexbio_anp_sd))
  
}

mexbio01_eco_stats <- mexbio_eco_anp_stats(mexbio01_eco)
mexbio07_eco_stats <- mexbio_eco_anp_stats(mexbio07_eco)
mexbio10_eco_stats <- mexbio_eco_anp_stats(mexbio10_eco)
mexbio01_eco_anp_stats <- mexbio_eco_anp_stats(mexbio01_eco_anp)
mexbio07_eco_anp_stats <- mexbio_eco_anp_stats(mexbio07_eco_anp)
mexbio10_eco_anp_stats <- mexbio_eco_anp_stats(mexbio10_eco_anp)

### Create stats data frame for ECOREGION without Protected Areas 
# Mean
mean01 <- data.frame(mexbio01_eco_stats[[1]])
colnames(mean01) <- "Mean_01"
mean07 <- data.frame(mexbio07_eco_stats[[1]])
colnames(mean07) <- "Mean_07"
mean10 <- data.frame(mexbio10_eco_stats[[1]])
colnames(mean10) <- "Mean_10"

# Median
median01 <- data.frame(mexbio01_eco_stats[[2]])
colnames(median01) <- "Median_01"
median07 <- data.frame(mexbio07_eco_stats[[2]])
colnames(median07) <- "Median_07"
median10 <- data.frame(mexbio10_eco_stats[[2]])
colnames(median10) <- "Median_10"

# Quantile
Q01 <- data.frame(mexbio01_eco_stats[[3]])
colnames(Q01) <- names_eco
Q01 <- t(Q01)
colnames(Q01) <- c("Q0_01","Q25_01","Q50_01","Q75_01","Q100_01")
Q07 <- data.frame(mexbio07_eco_stats[[3]])
colnames(Q07) <- names_eco
Q07 <- t(Q07)
colnames(Q07) <- c("Q0_07","Q25_07","Q50_07","Q75_07","Q100_07")
Q10 <- data.frame(mexbio10_eco_stats[[3]])
colnames(Q10) <- names_eco
Q10 <- t(Q10)
colnames(Q10) <- c("Q0_10","Q25_10","Q50_10","Q75_10","Q100_10")

# sd
sd01 <- data.frame(mexbio01_eco_stats[[4]])
colnames(sd01) <- "sd_01"
sd07 <- data.frame(mexbio07_eco_stats[[4]])
colnames(sd07) <- "sd_07"
sd10 <- data.frame(mexbio10_eco_stats[[4]])
colnames(sd10) <- "sd_10"

Mexbio_eco_stats <- cbind(Q01,Q07,Q10,mean01,mean07,mean10, median01, median07, median10,sd01,sd07,sd10)
write.table(Mexbio_eco_stats, 
            "J:/USUARIOS/ANALISIS/SubCoord_Evaluacion_Ecosistemas/Biblioteca_codigosR/Mexbio_Ecorregiones_ANP/Mexbio_eco_stats.CSV", 
            sep = ",",  col.names = NA, row.names = TRUE)


### Create stats data frame for Protected Areas by ECOREGION 
# Mean
mean01 <- data.frame(mexbio01_eco_anp_stats[[1]])
colnames(mean01) <- "Mean_01"
mean07 <- data.frame(mexbio07_eco_anp_stats[[1]])
colnames(mean07) <- "Mean_07"
mean10 <- data.frame(mexbio10_eco_anp_stats[[1]])
colnames(mean10) <- "Mean_10"

# Median
median01 <- data.frame(mexbio01_eco_anp_stats[[2]])
colnames(median01) <- "Median_01"
median07 <- data.frame(mexbio07_eco_anp_stats[[2]])
colnames(median07) <- "Median_07"
median10 <- data.frame(mexbio10_eco_anp_stats[[2]])
colnames(median10) <- "Median_10"

# Quantile
Q01 <- data.frame(mexbio01_eco_anp_stats[[3]])
colnames(Q01) <- names_eco
Q01 <- t(Q01)
colnames(Q01) <- c("Q0_01","Q25_01","Q50_01","Q75_01","Q100_01")
Q07 <- data.frame(mexbio07_eco_anp_stats[[3]])
colnames(Q07) <- names_eco
Q07 <- t(Q07)
colnames(Q07) <- c("Q0_07","Q25_07","Q50_07","Q75_07","Q100_07")
Q10 <- data.frame(mexbio10_eco_anp_stats[[3]])
colnames(Q10) <- names_eco
Q10 <- t(Q10)
colnames(Q10) <- c("Q0_10","Q25_10","Q50_10","Q75_10","Q100_10")

# sd
sd01 <- data.frame(mexbio01_eco_anp_stats[[4]])
colnames(sd01) <- "sd_01"
sd07 <- data.frame(mexbio07_eco_anp_stats[[4]])
colnames(sd07) <- "sd_07"
sd10 <- data.frame(mexbio10_eco_anp_stats[[4]])
colnames(sd10) <- "sd_10"

Mexbio_eco_anp_stats <- cbind(Q01,Q07,Q10,mean01,mean07,mean10, median01, median07, median10,sd01,sd07,sd10)
write.table(Mexbio_eco_anp_stats, 
            "J:/USUARIOS/ANALISIS/SubCoord_Evaluacion_Ecosistemas/Biblioteca_codigosR/Mexbio_Ecorregiones_ANP/Mexbio_anp_stats.CSV", 
            sep = ",",  col.names = NA, row.names = TRUE)

