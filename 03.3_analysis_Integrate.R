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

Strata<-c('GRIZZLY_BEAR_POP_UNIT_ID','POPULATION_NAME')
StrataL <- c('GBPUr','GBPUr_NonHab','GBPUr_BEI_1_2','GBPUr_BEI_1_5')
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
    cbind(data.frame(ThreatZone[ , (names(ThreatZone) %in% Strata)], AreaHa,GBA, GBD, GBDK)) %>%
    dplyr::select(-Area, -Area.1,-Area.2)

  #Save individual Strata
  ThreatZ_file <- file.path(dataOutDir,paste("ThreatZ_",StrataL[i], sep=""))
  saveRDS(ThreatZ, file = ThreatZ_file)

  ThreatL[[StratName]]<-ThreatZ
}

#For each strata pull out the relevant attributes and build an ordered data frame for inspection

#For each strata pull out the relevant attributes and build an ordered data frame for inspection
#Add in density from entire GBPU
gbDensity<-data.frame(read_xls(file.path(dataOutDir,'gbDensity.xls'), sheet=NULL))
gbDensitySmall<-data.frame(GBPU=gbDensity$GBPU,pop2018=gbDensity$pop2018,GBDensity=gbDensity$DensityGBPU)


ThreatLZR<-list()

for (i in 1:num) {
         StratName<-StrataL[i]
         ThreatLZR[[StratName]]<-
           data.frame(GBPU=ThreatL[[StrataL[i]]]$POPULATION_NAME,
                                            AreaHa=ThreatL[[StrataL[i]]]$Area,
                                            SecureHabitat=ThreatL[[StrataL[i]]]$SecureHabitat,
                                            FrontCountry=ThreatL[[StrataL[i]]]$FrontCountry,
                                            HumanDensity=ThreatL[[StrataL[i]]]$HumanDensity,
                                            LivestockDensity=ThreatL[[StrataL[i]]]$LivestockDensity,
                                            HunterDensity=ThreatL[[StrataL[i]]]$HunterDensity,
                                            RoadDensity=ThreatL[[StrataL[i]]]$RoadDensity
         ) %>%
         merge(gbDensitySmall, by='GBPU')
}
# write out the list of threat strata data frames to a multi-tab excel spreadsheet
WriteXLS(ThreatLZR, file.path(dataOutDir,paste('GBThreats.xls',sep='')),SheetNames=StrataL)



