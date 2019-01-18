# Copyright 2019 Province of British Columbia
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

#Make a Threat brick for analysis
ThreatBrick <- stack(HumanDensityR,LivestockDensityR,HuntDDensR,SecureR,FrontCountryR,RdDensR)
names(ThreatBrick) <- c('HumanDensity','LivestockDensity','HunterDensity','SecureHabitat','FrontCountry','RoadDensity')
Threat_file <- file.path("tmp/ThreatBrick")
saveRDS(ThreatBrick, file = Threat_file)

#Clean up GBPU names in Unreport2004 data base
Unreport2004$GBPU<-gsub("\\s+(?=\\p{Pd})|(?<=\\p{Pd})\\s+", "", (str_to_title(Unreport2004$GBPU)), perl=TRUE)
#Change values read in as % to standard
Unreport2004$UnreportedMort_unbound<-Unreport2004$UnreportedMort_unbound*100
Unreport2004$UnreportedMort_bound_0.3_3<-Unreport2004$UnreportedMort_bound_0.3_3*100
