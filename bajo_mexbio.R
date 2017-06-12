#Ecoregion ID and names 
#9 = Grandes Planicies (GP)
#10 = Desiertos de America de Norte (DAN)
#11 = California Mediterranea (CM)
#12 = Elevaciones Semiaridas Meridionales (ESM)
#13 = Sierras Templadas (ST)
#14 = Selvas Calido-secas (SCS)
#15 = Selvas Calido-humedas (SCH)

mexbio.ecoanp<-read.csv("Mexbio_eco_stats.csv", header = T)
mexbio.ecoanp.sel<-c("X","Mean_10")
mexbio.mean <-mexbio.ecoanp[mexbio.ecoanp.sel]
head(mexbio.mean)

GP_estables45 <- subset(estables45, ecoregiones == 9)
GP_estables45.mexbio <- GP_estables45[which(GP_estables45$MEXBIO_2010_gw_pr >= 0.3627301),]
GP_cambio45 <- subset(cambio45, ecoregiones == 9)
GP_cambio45.mexbio <- GP_cambio45[which(GP_cambio45$MEXBIO_2010_gw_pr >= 0.3627301),]

DAN_estables45 <- subset(estables45, ecoregiones == 10)
DAN_estables45.mexbio <- DAN_estables45[which(DAN_estables45$MEXBIO_2010_gw_pr >= 0.5311693),]
DAN_cambio45 <- subset(cambio45, ecoregiones == 10)
DAN_cambio45.mexbio <- DAN_cambio45[which(DAN_cambio45$MEXBIO_2010_gw_pr >= 0.5311693),]

CM_estables45 <- subset(estables45, ecoregiones == 11)
CM_estables45.mexbio <- CM_estables45[which(CM_estables45$MEXBIO_2010_gw_pr >= 0.5061778),]
CM_cambio45 <- subset(cambio45, ecoregiones == 11)
CM_cambio45.mexbio <- CM_cambio45[which(CM_cambio45$MEXBIO_2010_gw_pr >= 0.5061778),]

ESM_estables45 <- subset(estables45, ecoregiones == 12)
ESM_estables45.mexbio <- ESM_estables45[which(ESM_estables45$MEXBIO_2010_gw_pr >= 0.4290649),]
ESM_cambio45 <- subset(cambio45, ecoregiones == 12)
ESM_cambio45.mexbio <- ESM_cambio45[which(ESM_cambio45$MEXBIO_2010_gw_pr >= 0.4290649),]

ST_estables45 <- subset(estables45, ecoregiones == 13)
ST_estables45.mexbio <- ST_estables45[which(ST_estables45$MEXBIO_2010_gw_pr >= 0.4782820),]
ST_cambio45 <- subset(cambio45, ecoregiones == 13)
ST_cambio45.mexbio <- ST_cambio45[which(ST_cambio45$MEXBIO_2010_gw_pr >= 0.4782820),]

SCS_estables45 <- subset(estables45, ecoregiones == 14)
SCS_estables45.mexbio <- SCS_estables45[which(SCS_estables45$MEXBIO_2010_gw_pr >= 0.3381729),]
SCS_cambio45 <- subset(cambio45, ecoregiones == 14)
SCS_cambio45.mexbio <- SCS_cambio45[which(SCS_cambio45$MEXBIO_2010_gw_pr >= 0.3381729),]

SCH_estables45 <- subset(estables45, ecoregiones == 15)
SCH_estables45.mexbio <- SCH_estables45[which(SCH_estables45$MEXBIO_2010_gw_pr >= 0.2804518),]
SCH_cambio45 <- subset(cambio45, ecoregiones == 15)
SCH_cambio45.mexbio <- SCH_cambio45[which(SCH_cambio45$MEXBIO_2010_gw_pr >= 0.2804518),]


bajo.mexbio.estables45<-rbind(GP_estables45.mexbio,DAN_estables45.mexbio,
                         CM_estables45.mexbio,ESM_estables45.mexbio,
                         ST_estables45.mexbio,SCS_estables45.mexbio,
                         SCH_estables45.mexbio)
write.csv(bajo.mexbio.estables45, "bajo_mexbio_estables45.csv")

bajo.mexbio.cambio45<-rbind(GP_cambio45.mexbio,DAN_cambio45.mexbio,
                       CM_cambio45.mexbio,ESM_cambio45.mexbio,
                       ST_cambio45.mexbio,SCS_cambio45.mexbio,
                       SCH_cambio45.mexbio)
write.csv(bajo.mexbio.cambio45, "bajo_mexbio_cambio45.csv")