# Copyright 2018 Province of British Columbia
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and limitations under the License.

source("header.R")

#Calculate %indicator area of total strata area for certain indicators
IndsPCArea<-c("Area","SecureHabitat","FrontCountry")
IndsDensity<-c("Area","HumanDensity","LivestockDensity","HunterDensity")
KmDensity<-c("Area","RoadDensity")

Strata<-c('GRIZZLY_BEAR_POP_UNIT_ID','GBPU_MU_LEH_uniqueID')
StrataL <- c('GBPUr','GBPUr_NonHab','GB_WMU_id','GB_WMU_id_NonHab')

ThreatL<-list()
num<-length(StrataL)

# Loop through each Strata concatenate and generate a Strata list of data frames
i<-1
for (i in 1:num) {
  StratName<-StrataL[i]
  ThreatZone <- data.frame(readRDS(file = (file.path(dataOutDir,StratName))))
  ThreatZone$SecureHabitat<-ThreatZone$SecureHabitat/2

  # Area indicators expressed as % indicator of strata
  AreaHa<-ThreatZone$Area

  # Area indicators expressed as % indicator of strata
  GBlistA<-ThreatZone[ , (names(ThreatZone) %in% IndsPCArea)]
  GBA<-data.frame(lapply(GBlistA, function(x) round(x*100/GBlistA$Area,4)))

  # Density indicators expressed as #/ha in Strata
  GBlistD<-ThreatZone[ , (names(ThreatZone) %in% IndsDensity)]
  GBD<-data.frame(lapply(GBlistD, function(x) round((x)/GBlistD$Area,4)))#density summed to area of zone/area of unit to get density per/km2

  # Density indicators expressed as km/km2 in Strata
  GBlistDK<-ThreatZone[ , (names(ThreatZone) %in% KmDensity)]
  GBDK<-data.frame(lapply(GBlistDK, function(x) round((x)/GBlistDK$Area,4)))#km of rds/km2

  ThreatZ<-
    cbind(data.frame(id=ThreatZone[ , (names(ThreatZone) %in% Strata)], AreaHa,GBA, GBD, GBDK)) %>%
    dplyr::select(-Area, -Area.1,-Area.2)

  #Save individual Strata
  ThreatZ_file <- file.path(dataOutDir,paste("ThreatZ_",StrataL[i], sep=""))
  saveRDS(ThreatZ, file = ThreatZ_file)

  ThreatL[[StratName]]<-ThreatZ
}

#For each strata pull out the relevant attributes and build an ordered data frame for inspection

#For each strata pull out the relevant attributes and build an ordered data frame for inspection
#Add in density from entire GBPU
gbGBPUDensity<-data.frame(read_xls(file.path(dataOutDir,'gbGBPUDensity.xls'), sheet=NULL))
gbGBPUDensitySmall<-data.frame(GBPUid=gbGBPUDensity$GBPUid,
                               GBPU=gbGBPUDensity$POPULATION_NAME,
                               #EST_POP_2018=gbGBPUDensity$EST_POP_2018,
                               EST_POP_2018=gbGBPUDensity$pop2018,
                               GBDensity=gbGBPUDensity$Density,
                               DensityGBPUnonHab=gbGBPUDensity$Density_noWaterIce)
                               #GBDensity=gbGBPUDensity$DensityGBPU,
                               #DensityGBPUnonHab=gbGBPUDensity$DensityGBPUnonHab)

#and for WMU
gbWMUDensity<-data.frame(read_xls(file.path(dataOutDir,'gbWMUDensity.xls'), sheet=NULL))
gbWMUDensitySmall<-data.frame(WMUid=gbWMUDensity$GBPU_MU_LEH_uniqueID,
                              MU=gbWMUDensity$MU,
                              LEH=gbWMUDensity$LEH_Zone2_fix,
                              EST_POP_2018=gbWMUDensity$EST_POP_DENSITY_2018, #note density is calculated only on noWaterIce
                              GBDensity=gbWMUDensity$EST_POP_DENSITY_2018,
                              DensityWMUnonHab=gbWMUDensity$Density_noWaterIce)

ThreatLZR<-list()

for (i in 1:num) {
         StratName<-StrataL[i]
         ThreatLZR[[StratName]]<-
           data.frame(id=ThreatL[[StrataL[i]]]$id,
                                            AreaHa=ThreatL[[StrataL[i]]]$Area,
                                            SecureHabitat=ThreatL[[StrataL[i]]]$SecureHabitat,
                                            FrontCountry=ThreatL[[StrataL[i]]]$FrontCountry,
                                            HumanDensity=ThreatL[[StrataL[i]]]$HumanDensity,
                                            LivestockDensity=ThreatL[[StrataL[i]]]$LivestockDensity,
                                            HunterDensity=ThreatL[[StrataL[i]]]$HunterDensity,
                                            RoadDensity=ThreatL[[StrataL[i]]]$RoadDensity
         )

         ThreatLZR[[StratName]]<-
           if (grepl('WMU',StrataL[i])) {
              merge(ThreatLZR[[StratName]],gbWMUDensitySmall, by.x='id',by.y='WMUid')
            } else {
              merge(ThreatLZR[[StratName]],gbGBPUDensitySmall, by.x='id',by.y='GBPUid')
            }

}
# write out the list of threat strata data frames to a multi-tab excel spreadsheet
WriteXLS(ThreatLZR, file.path(dataOutDir,paste('GBThreats.xls',sep='')),SheetNames=StrataL)



