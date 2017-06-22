GP_estables45 <- subset(estables45, ecoregiones == 9)
GP_estables45.mexbio <- GP_estables45[which(GP_estables45$MEXBIO_2010_gw_pr <= 0.3627301),]
GP_cambio45 <- subset(cambio45, ecoregiones == 9)
GP_cambio45.mexbio <- GP_cambio45[which(GP_cambio45$MEXBIO_2010_gw_pr <= 0.3627301),]

DAN_estables45 <- subset(estables45, ecoregiones == 10)
DAN_estables45.mexbio <- DAN_estables45[which(DAN_estables45$MEXBIO_2010_gw_pr <= 0.5311693),]
DAN_cambio45 <- subset(cambio45, ecoregiones == 10)
DAN_cambio45.mexbio <- DAN_cambio45[which(DAN_cambio45$MEXBIO_2010_gw_pr <= 0.5311693),]

CM_estables45 <- subset(estables45, ecoregiones == 11)
CM_estables45.mexbio <- CM_estables45[which(CM_estables45$MEXBIO_2010_gw_pr <= 0.5061778),]
CM_cambio45 <- subset(cambio45, ecoregiones == 11)
CM_cambio45.mexbio <- CM_cambio45[which(CM_cambio45$MEXBIO_2010_gw_pr <= 0.5061778),]

ESM_estables45 <- subset(estables45, ecoregiones == 12)
ESM_estables45.mexbio <- ESM_estables45[which(ESM_estables45$MEXBIO_2010_gw_pr <= 0.4290649),]
ESM_cambio45 <- subset(cambio45, ecoregiones == 12)
ESM_cambio45.mexbio <- ESM_cambio45[which(ESM_cambio45$MEXBIO_2010_gw_pr <= 0.4290649),]

ST_estables45 <- subset(estables45, ecoregiones == 13)
ST_estables45.mexbio <- ST_estables45[which(ST_estables45$MEXBIO_2010_gw_pr <= 0.4782820),]
ST_cambio45 <- subset(cambio45, ecoregiones == 13)
ST_cambio45.mexbio <- ST_cambio45[which(ST_cambio45$MEXBIO_2010_gw_pr <= 0.4782820),]

SCS_estables45 <- subset(estables45, ecoregiones == 14)
SCS_estables45.mexbio <- SCS_estables45[which(SCS_estables45$MEXBIO_2010_gw_pr <= 0.3381729),]
SCS_cambio45 <- subset(cambio45, ecoregiones == 14)
SCS_cambio45.mexbio <- SCS_cambio45[which(SCS_cambio45$MEXBIO_2010_gw_pr <= 0.3381729),]

SCH_estables45 <- subset(estables45, ecoregiones == 15)
SCH_estables45.mexbio <- SCH_estables45[which(SCH_estables45$MEXBIO_2010_gw_pr <= 0.2804518),]
SCH_cambio45 <- subset(cambio45, ecoregiones == 15)
SCH_cambio45.mexbio <- SCH_cambio45[which(SCH_cambio45$MEXBIO_2010_gw_pr <= 0.2804518),]


alto.mexbio.estables45<-rbind(GP_estables45.mexbio,DAN_estables45.mexbio,
                         CM_estables45.mexbio,ESM_estables45.mexbio,
                         ST_estables45.mexbio,SCS_estables45.mexbio,
                         SCH_estables45.mexbio)
write.csv(alto.mexbio.estables45, "Resample/MPI_ESM_LR_rcp45_2075_2099_bio/alto_mexbio_estables45.csv")

alto.mexbio.cambio45<-rbind(GP_cambio45.mexbio,DAN_cambio45.mexbio,
                       CM_cambio45.mexbio,ESM_cambio45.mexbio,
                       ST_cambio45.mexbio,SCS_cambio45.mexbio,
                       SCH_cambio45.mexbio)
write.csv(alto.mexbio.cambio45, "Resample/MPI_ESM_LR_rcp45_2075_2099_bio/alto_mexbio_cambio45.csv")

####RCP85####
GP_estables85 <- subset(estables85, ecoregiones == 9)
GP_estables85.mexbio <- GP_estables85[which(GP_estables85$MEXBIO_2010_gw_pr <= 0.3627301),]
GP_cambio85 <- subset(cambio85, ecoregiones == 9)
GP_cambio85.mexbio <- GP_cambio85[which(GP_cambio85$MEXBIO_2010_gw_pr <= 0.3627301),]

DAN_estables85 <- subset(estables85, ecoregiones == 10)
DAN_estables85.mexbio <- DAN_estables85[which(DAN_estables85$MEXBIO_2010_gw_pr <= 0.5311693),]
DAN_cambio85 <- subset(cambio85, ecoregiones == 10)
DAN_cambio85.mexbio <- DAN_cambio85[which(DAN_cambio85$MEXBIO_2010_gw_pr <= 0.5311693),]

CM_estables85 <- subset(estables85, ecoregiones == 11)
CM_estables85.mexbio <- CM_estables85[which(CM_estables85$MEXBIO_2010_gw_pr <= 0.5061778),]
CM_cambio85 <- subset(cambio85, ecoregiones == 11)
CM_cambio85.mexbio <- CM_cambio85[which(CM_cambio85$MEXBIO_2010_gw_pr <= 0.5061778),]

ESM_estables85 <- subset(estables85, ecoregiones == 12)
ESM_estables85.mexbio <- ESM_estables85[which(ESM_estables85$MEXBIO_2010_gw_pr <= 0.4290649),]
ESM_cambio85 <- subset(cambio85, ecoregiones == 12)
ESM_cambio85.mexbio <- ESM_cambio85[which(ESM_cambio85$MEXBIO_2010_gw_pr <= 0.4290649),]

ST_estables85 <- subset(estables85, ecoregiones == 13)
ST_estables85.mexbio <- ST_estables85[which(ST_estables85$MEXBIO_2010_gw_pr <= 0.4782820),]
ST_cambio85 <- subset(cambio85, ecoregiones == 13)
ST_cambio85.mexbio <- ST_cambio85[which(ST_cambio85$MEXBIO_2010_gw_pr <= 0.4782820),]

SCS_estables85 <- subset(estables85, ecoregiones == 14)
SCS_estables85.mexbio <- SCS_estables85[which(SCS_estables85$MEXBIO_2010_gw_pr <= 0.3381729),]
SCS_cambio85 <- subset(cambio85, ecoregiones == 14)
SCS_cambio85.mexbio <- SCS_cambio85[which(SCS_cambio85$MEXBIO_2010_gw_pr <= 0.3381729),]

SCH_estables85 <- subset(estables85, ecoregiones == 15)
SCH_estables85.mexbio <- SCH_estables85[which(SCH_estables85$MEXBIO_2010_gw_pr <= 0.2804518),]
SCH_cambio85 <- subset(cambio85, ecoregiones == 15)
SCH_cambio85.mexbio <- SCH_cambio85[which(SCH_cambio85$MEXBIO_2010_gw_pr <= 0.2804518),]


alto.mexbio.estables85<-rbind(GP_estables85.mexbio,DAN_estables85.mexbio,
                              CM_estables85.mexbio,ESM_estables85.mexbio,
                              ST_estables85.mexbio,SCS_estables85.mexbio,
                              SCH_estables85.mexbio)
write.csv(alto.mexbio.estables85, "Resample/MPI_ESM_LR_rcp45_2075_2099_bio/alto_mexbio_estables85.csv")

alto.mexbio.cambio85<-rbind(GP_cambio85.mexbio,DAN_cambio85.mexbio,
                            CM_cambio85.mexbio,ESM_cambio85.mexbio,
                            ST_cambio85.mexbio,SCS_cambio85.mexbio,
                            SCH_cambio85.mexbio)
write.csv(alto.mexbio.cambio85, "Resample/MPI_ESM_LR_rcp45_2075_2099_bio/alto_mexbio_cambio85.csv")