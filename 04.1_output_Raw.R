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

GBPU_StrataL <- c('GBPUr','GBPUr_NonHab')
WMU_StrataL <- c('GB_WMU_id','GB_WMU_id_NonHab')
numGBPU<-length(GBPU_StrataL)
numWMU<-length(WMU_StrataL)

#Read in xls file with multiple worksheets - one for each strata - created in 03.3_analysis_integrate.R
path <- file.path(dataOutDir, paste('GBThreats.xls',sep=''))

ThreatLZR <- path %>%
  excel_sheets() %>%
  set_names() %>%
  map(read_excel, path = path)

UnreportL<-list()

#For GBPUs
for (i in 1:numGBPU) {
  GBThreat<-subset(ThreatLZR[[i]], !(GBPU == 'extirpated'))
  GBunreported<-GBThreat
  StratName<-StrataL[i]
  UnreportL[[StratName]]<-data.frame(GBPU=GBunreported$GBPU,
                                     AreaHa=GBunreported$AreaHa,
                                     EST_POP_2018=GBunreported$EST_POP_2018,
                                     #GBDensity=GBunreported$GBDensity,
                                     GBDensity=GBunreported$DensityGBPUnonHab,
                                     RoadDensity=round(GBunreported$RoadDensity,2),
                                     UnSecureHabitat=100-round(GBunreported$SecureHabitat,0),
                                     SecureHabitat=round(GBunreported$SecureHabitat,0),
                                     FrontCountry=round(GBunreported$FrontCountry/100,2), # change percent to between 0 and 1
                                     HumanDensity=round(GBunreported$HumanDensity*1000,0), #report per 1000km2
                                     LivestockDensity=round(GBunreported$LivestockDensity*1000,0), #report per 1000km2
                                     HunterDensity=round(GBunreported$HunterDensity*1000,0) #report per 1000km2
  )
}

#For WMUs
start<-numGBPU+1
end<-numGBPU+numWMU
for (i in start:end) {
  GBThreat<-subset(ThreatLZR[[i]])
  GBunreported<-GBThreat
  StratName<-StrataL[i]
  UnreportL[[StratName]]<-data.frame(WMUid=GBunreported$id,
                                     MU=GBunreported$MU,
                                     LEH=GBunreported$LEH,
                                     AreaHa=GBunreported$AreaHa,
                                     EST_POP_2018=GBunreported$EST_POP_2018,
                                     #GBDensity=GBunreported$GBDensity,
                                     GBDensity=GBunreported$DensityWMUnonHab,
                                     RoadDensity=round(GBunreported$RoadDensity,2),
                                     UnSecureHabitat=100-round(GBunreported$SecureHabitat,0),
                                     SecureHabitat=round(GBunreported$SecureHabitat,0),
                                     FrontCountry=round(GBunreported$FrontCountry/100,2), # change percent to between 0 and 1
                                     HumanDensity=round(GBunreported$HumanDensity*1000,0), #report per 1000km2
                                     LivestockDensity=round(GBunreported$LivestockDensity*1000,0), #report per 1000km2
                                     HunterDensity=round(GBunreported$HunterDensity*1000,0) #report per 1000km2
  )
}
WriteXLS(UnreportL, file.path(dataOutDir,paste('GBUnreported.xls',sep='')),SheetNames=StrataL)

