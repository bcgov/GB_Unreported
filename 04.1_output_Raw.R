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

StrataL <- c('GBPUr','GBPUr_NonHab','GBPUr_BEI_1_2','GBPUr_BEI_1_5')
num<-length(StrataL)

#Read in xls file with multiple worksheets - one for each strata - created in 03.3_analysis_integrate.R
path <- file.path(dataOutDir, paste('GBThreats.xls',sep=''))

ThreatLZR <- path %>%
  excel_sheets() %>%
  set_names() %>%
  map(read_excel, path = path)

UnreportL<-list()

for (i in 1:num) {
  GBThreat<-subset(ThreatLZR[[i]], !(GBPU == 'extirpated'))
  GBunreported<-GBThreat
  StratName<-StrataL[i]
  UnreportL[[StratName]]<-data.frame(GBPU=GBunreported$GBPU,
                            AreaHa=GBunreported$AreaHa,
                            pop2018=GBunreported$pop2018,
                            GBDensity=GBunreported$GBDensity,
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

