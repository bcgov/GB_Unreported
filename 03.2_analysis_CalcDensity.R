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

#First calculate the area of each GBPU for full GBPU and GBPU with habitat removed
GBPU_StrataL <- c('GBPUr','GBPUr_NonHab')
WMU_StrataL <- c('GB_WMU_id','GB_WMU_id_NonHab')

#Do on GBPUs first
GBPUrF<-list()

num<-length(GBPU_StrataL)

for (i in 1:num) {
  GBStrata<-raster(file.path(StrataDir,paste(GBPU_StrataL[i], ".tif", sep="")))
  Freqs<-data.frame(freq(GBStrata, parellel=FALSE))
  colnames(Freqs)<-c('GBPUid','AreaHa')
  #colnames(Freqs)<-c('GBPU_MU_LEH_uniqueID','AreaHa')
  GBPUrF[[i]]<-Freqs
}

#Combine GBPU LUT to get ids in population database
gb2018pop<-gb2018GBPUpopIN

#Combine the 2 GBPU strata into a single table, can modify later if more than 2
ComboArea<-
  merge(GBPUrF[[1]],GBPUrF[[2]], by='GBPUid') %>%
  dplyr::select(GBPUid,AreaHa=AreaHa.x,AreaHaNonHab=AreaHa.y)

gbDensity<-
  merge(ComboArea,gb2018pop,by.x='GBPUid', by.y='GRIZZLY_BEAR_POP_UNIT_ID') #%>%
  #mutate(DensityGBPU = round(EST_POP_2018/AreaHa*100000,2)) %>%
  #mutate(DensityGBPUnonHab = round(EST_POP_2018/AreaHaNonHab*100000,2))

WriteXLS(gbDensity, file.path(dataOutDir,paste('gbGBPUDensity.xls',sep='')))

#WMU based analysis
WMU_StrataL <- c('GB_WMU_id','GB_WMU_id_NonHab')
GBPUrF<-list()

num<-length(WMU_StrataL)

for (i in 1:num) {
  GBStrata<-raster(file.path(StrataDir,paste(WMU_StrataL[i], ".tif", sep="")))
  Freqs<-data.frame(freq(GBStrata, parellel=FALSE))
  colnames(Freqs)<-c('GBPU_MU_LEH_uniqueID','AreaHa')
  GBPUrF[[i]]<-Freqs
}

gb2018pop<-gb2018WMUpopIN

ComboArea<-
  merge(GBPUrF[[1]],GBPUrF[[2]], by='GBPU_MU_LEH_uniqueID') %>%
  dplyr::select(GBPU_MU_LEH_uniqueID,AreaHa=AreaHa.x,AreaHaNonHab=AreaHa.y)

gbDensity<-
  merge(ComboArea,gb2018pop,by.x='GBPU_MU_LEH_uniqueID',by.y='GBPU_MU_LEH_uniqueID') %>%
  mutate(Density_noWaterIce = EST_POP_DENSITY_2018) #%>%
  #mutate(DensityWMU = round(EST_POP_2018/AreaHa*100000,2)) %>%
  #mutate(DensityWMUnonHab = round(EST_POP_2018/AreaHaNonHab*100000,2))

WriteXLS(gbDensity, file.path(dataOutDir,paste('gbWMUDensity.xls',sep='')))


