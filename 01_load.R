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

# Repo estimates unreported mortality for each GBPU based on:
# 1. core security (in % by GBPU). Note: replaces previous statistic of % capable within 50km of areas with >5000 people
# 2. Hunter day density -> HunterDensity repo: https://github.com/bcgov/HunterDensity
# Note: previously used Large Ungulate harvest replaced by hunter day density above
# 3. frontcountry (in % by GBPU) - from provincial CE Grizzly protocol. Note: replaces previous statistic of % capable habitat with roads

source("header.R")

#Load the Info to estimate unreported mortality

# Hunter Density - for MU - rock, ice included
# from HunterDensity repo: https://github.com/bcgov/HunterDensity
HuntDDensR<-raster(file.path(HunterSpatialDir,"HuntDDensR.tif"))
# Hunter Density - for MU - rock, ice not included
HuntDDensNonHabR<-raster(file.path(HunterSpatialDir,"HuntDDensNonHabR.tif"))

#Human & Livestock Denisty - for entire census area - rock, ice included
# from HumanLivestock repo: https://github.com/bcgov/HumanLivestockDensity
HumanDensityR<-raster(file.path(HumanLivestockSpatialDir,"HumanDensityR.tif"))
LivestockDensityR<-raster(file.path(HumanLivestockSpatialDir,"LSDensityR.tif"))

#GB Security Areas, Human Access and Road Density
# from GB_Data repo: https://github.com/bcgov/GB_Data
#Security Areas
SecureR<-raster(file.path(GBspatialDir,"Securer.tif"))

#Human access- raw raster of classes
FrontCountryR<-raster(file.path(GBspatialDir,"FrontCountryr.tif"))

#Road Density - ras raster of classes
RdDensR<-raster(file.path(Rdkmkm2Dir,"Roadkmkm2Raw.tif"))

#Load Strata
# from GB_Data repo: https://github.com/bcgov/GB_Data
NonHab<-raster(file.path(StrataDir,"NonHab.tif"))
GBPUr<-raster(file.path(StrataDir,"GBPUr.tif"))
GBPUr_NonHab<-raster(file.path(StrataDir,"GBPUr_NonHab.tif"))
GB_WMU_id<-raster(file.path(StrataDir,"GB_WMU_id.tif"))
GB_WMU_id_NonHab<-raster(file.path(StrataDir,"GB_WMU_id_NonHab.tif"))

# read the gbpu LUT to get ids so density file can be merged
GBPU_lut<-readRDS(file = file.path(StrataDir,'GBPU_lut'))
colnames(GBPU_lut)<-c('GBPUid','GBPU')

#read in updated 2018 population numbers by GBPU
#gb2018GBPUpopIN <- data.frame(read_xls(file.path(GBDataOutDir, "gb2018GBPUpop.xls"), sheet=NULL))
#read in revised populations with gb density already calculated
gb2018GBPUpopIN <- data.frame(read_xls(file.path(GBDataOutDir, "GBPUpop.xls"), sheet=NULL))

#BY WMU
#gb2018WMUpopIN <- data.frame(read_xls(file.path(GBDataOutDir, "gb2018WMUpop.xls"), sheet=NULL))
#read in revised populations with assigned gb density
gb2018WMUpopIN <- data.frame(read_xls(file.path(GBDataOutDir, "WMUpop.xls"), sheet=NULL))










