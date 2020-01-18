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

## Copy and run in R outside of R studio - R studio has a memory allocation bug running zonal and freq
#OutDir <- '/Users/Morgan/Dropbox (BVRC)/_dev/GBMortality/out'
#dataOutDir <- file.path(OutDir,'data')
#DataDir <- '/Users/Morgan/Dropbox (BVRC)/_dev/GBMortality/data'
#StrataDir <- file.path('/Users/Morgan/Dropbox (BVRC)/_dev/GB_Data/out/Strata')
#library(raster)
#setwd('/Users/Morgan/Dropbox (BVRC)/_dev/GBMortality')

source("header.R")

Threat_file <- file.path("tmp/ThreatBrick")
ThreatBrick <- readRDS(file = Threat_file)

GBPU_StrataL <- c('GBPUr','GBPUr_NonHab')
WMU_StrataL <- c('GB_WMU_id','GB_WMU_id_NonHab')
GBPU_lut<-readRDS(file.path(StrataDir,'GBPU_lut'))

# First do GBPU cases
num<-length(GBPU_StrataL)
i<-1
for (i in 1:num) {
  # Originally strata was in a brick, but freq and zonal had memory issues
  GBStrata<-raster(file.path(StrataDir,paste(GBPU_StrataL[i], ".tif", sep="")))

  ThreatZoneF<-freq(GBStrata, parellel=FALSE)

    colnames(ThreatZoneF)<-c('GRIZZLY_BEAR_POP_UNIT_ID','Area')
    ThreatGBPU<-merge(GBPU_lut,ThreatZoneF,by='GRIZZLY_BEAR_POP_UNIT_ID')

      ThreatZ1<-zonal(ThreatBrick,GBStrata,'sum', na.rm=TRUE)

  ThreatZone<-merge(ThreatGBPU,ThreatZ1,by.x='GRIZZLY_BEAR_POP_UNIT_ID',by.y='zone')

  saveRDS(ThreatZone, file = (file.path(dataOutDir,GBPU_StrataL[i])))
}

for (i in 1:num) {
  GBStrata<-raster(file.path(StrataDir,paste(StrataL[i], ".tif", sep="")))
  Freqs<-data.frame(freq(GBStrata, parellel=FALSE))
  colnames(Freqs)<-c('GBPUid','AreaHa')
  GBPUrF[[i]]<-Freqs
}

# Second do WMU cases
num<-length(WMU_StrataL)
i<-1
for (i in 1:num) {
  GBStrata<-raster(file.path(StrataDir,paste(WMU_StrataL[i], ".tif", sep="")))

  ThreatZoneF<-freq(GBStrata, parellel=FALSE)

    colnames(ThreatZoneF)<-c('GBPU_MU_LEH_uniqueID','Area')
    ThreatGBPU<-ThreatZoneF

  ThreatZ1<-zonal(ThreatBrick,GBStrata,'sum', na.rm=TRUE)

  ThreatZone<-merge(ThreatGBPU,ThreatZ1,by.x='GBPU_MU_LEH_uniqueID',by.y='zone')

  saveRDS(ThreatZone, file = (file.path(dataOutDir,WMU_StrataL[i])))
}

