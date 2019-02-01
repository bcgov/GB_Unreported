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
StrataL <- c('GBPUr','GBPUr_NonHab')
GBPUrF<-list()

num<-length(StrataL)

for (i in 1:num) {
  GBStrata<-raster(file.path(StrataDir,paste(StrataL[i], ".tif", sep="")))
  Freqs<-data.frame(freq(GBStrata, parellel=FALSE))
  colnames(Freqs)<-c('GBPUid','AreaHa')
  GBPUrF[[i]]<-Freqs
}

#Combine GBPU LUT to get ids in population database
gb2018pop<-merge(GBPU_lut,gb2018popIN, by='GBPU')

ComboArea<-
  merge(GBPUrF[[1]],GBPUrF[[2]], by='GBPUid') %>%
  dplyr::select(GBPUid,AreaHa=AreaHa.x,AreaHaNonHab=AreaHa.y)

gbDensity<-
  merge(ComboArea,gb2018pop,by='GBPUid') %>%
  mutate(DensityGBPU = round(pop2018/AreaHa*100000,2)) %>%
  mutate(DensityGBPUnonHab = round(pop2018/AreaHaNonHab*100000,2))

WriteXLS(gbDensity, file.path(dataOutDir,paste('gbDensity.xls',sep='')))

gbDensitySmall<-data.frame(GBPU=gbDensity$GBPU,pop2018=gbDensity$pop2018,GBDensity=gbDensity$DensityGBPU)
#GBPop_NonHab<-subs(GBPUr_NonHab,gb2018pop, by='GBPUid',which='pop2018')



