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

#FemaleMort

#GBThreat<-subset(ThreatLZR[[1]], !(GBPU == 'extirpated'))

#GBunreported<-merge(GBThreat,Unreport2004,by='GBPU',all=TRUE)
# Notes -
# North Purcells = North Purcells + Spillamacheen
# Central-South Purcells = South Purcells + Central Purcells

UnreportL<-list()

for (i in 1:num) {
  GBThreat<-subset(ThreatLZR[[i]], !(GBPU == 'extirpated'))
  GBunreported<-merge(GBThreat,Unreport2004,by='GBPU',all=TRUE)
  StratName<-StrataL[i]
  UnreportL[[StratName]]<-data.frame(GBPU=GBunreported$GBPU,
                            AreaHa=GBunreported$AreaHa,
                            UnreportedMort_unbound2004=GBunreported$UnreportedMort_unbound,
                            RoadDensity=round(GBunreported$RoadDensity,2),
                            UnSecureHabitat=100-round(GBunreported$SecureHabitat,0),
                            SecureHabitat=round(GBunreported$SecureHabitat,0),
                            FrontCountry=round(GBunreported$FrontCountry/100,2), # change percent to between 0 and 1
                            pcHab_gt5000_win50km2004=GBunreported$pcHab_gt5000_win50km,
                            pcHab_gt5000_PropBench=GBunreported$pcHab_gt5000_PropBench,
                            pcHab_gt0_kmperkm2=GBunreported$pcHab_gt0_kmperkm2,
                            pcHab_gt0_PropBenchmark=GBunreported$pcHab_gt0_PropBenchmark,
                            HumanDensity=round(GBunreported$HumanDensity*1000,0), #report per 1000km2
                            LivestockDensity=round(GBunreported$LivestockDensity*1000,0), #report per 1000km2
                            HunterDensity=round(GBunreported$HunterDensity*1000,0), #report per 1000km2
                            HunterDensity2004=GBunreported$HunterDensity_1000km2,
                            HuntDens_PorpBenchmark=GBunreported$HuntDens_PorpBenchmark,
                            UngHarvDensity_Ungperyearper1000km2_2004=GBunreported$UngHarvDensity_Ungperyearper1000km2,
                            UngDen_PropBenchmark=GBunreported$UngDen_PropBenchmark

)
}

WriteXLS(UnreportL, file.path(dataOutDir,paste('GBUnreported.xls',sep='')),SheetNames=StrataL)

#plot(UnreportL[[1]]$FrontCountry,UnreportL[[1]]$pcHab_gt5000_win50km2004,type='p')

TestData<-subset(UnreportL[[1]], AreaHa>0)
TestData[is.na(TestData)] <- 0

pdf(file.path(dataOutDir,"GBMortPlots.pdf"))
# Front Country - pcHab_gt5000_win50km2004 - habitat wihin 50km of towns>5000 people
x=TestData$FrontCountry
y=TestData$pcHab_gt5000_win50km2004

cor(x,y)
scatter.smooth(x=x, y=y, main="Front Country - pcHabgt5000", sub=paste('Correlation=',round(cor(x,y),2)))
linearMod <- lm(x ~ y)  # build linear regression model on full data
print(linearMod)

# Unsecure Habitat - pcHab_gt0_kmperkm2 - habitat wihtin areas >0 road density
x=TestData$UnSecureHabitat
y=TestData$pcHab_gt0_kmperkm2

cor(x,y)
scatter.smooth(x=x, y=y, main="Unsecure Habitat - pcHab_gt0_kmperkm2", sub=paste('Correlation=',round(cor(x,y),2)))
linearMod <- lm(x ~ y)  # build linear regression model on full data
print(linearMod)

x=TestData$HunterDensity
y=TestData$HunterDensity2004

cor(x,y)
scatter.smooth(x=x, y=y, main="HunterDensity 2017 - HunterDenstiy 2004", sub=paste('Correlation=',round(cor(x,y),2)))
linearMod <- lm(x ~ y)  # build linear regression model on full data
print(linearMod)
dev.off()
