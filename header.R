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


library(sf)
library(dplyr)
library(plyr)
library(readr)
library(raster)
library(bcmaps)
library(fasterize)
library(tidyr)
library(rio)
library(WriteXLS)
library(readxl)
library(openxlsx)
library(rgdal)
library(RColorBrewer)
library(stringr)
library(formattable)
library(purrr)

OutDir <- 'out'
dataOutDir <- file.path(OutDir,'data')
StrataOutDir <- file.path(dataOutDir,'Strata')
figsOutDir <- file.path(OutDir,'figures')
DataDir <- 'data'
HunterSpatialDir <- file.path('../HunterDensity/out/spatial')
HumanLivestockSpatialDir <- file.path('../HumanLivestockDensity/out/spatial')
StrataDir <- file.path('../GB_Data/out/Strata')
GBspatialDir <- file.path('../GB_Data/out/spatial')
GBDataDir <- file.path('../GB_Data/data')
GBDataOutDir <- file.path('../GB_Data/out/data')
Rdkmkm2Dir <- file.path('../bc-raster-roads/out')

dir.create(file.path(OutDir), showWarnings = FALSE)
dir.create(file.path(dataOutDir), showWarnings = FALSE)
dir.create(file.path(StrataOutDir), showWarnings = FALSE)
dir.create(file.path(figsOutDir), showWarnings = FALSE)
dir.create(DataDir, showWarnings = FALSE)
dir.create("tmp", showWarnings = FALSE)



