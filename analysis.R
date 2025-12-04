library(openxlsx)
library(stringr)
library(tidyverse)

#load sheets
raw_inf    <- read.xlsx("BoAC_Inflammation_Alamar.xlsx", sheet = 1)
plate_inf  <- read.xlsx("BoAC_Inflammation_Alamar.xlsx", sheet = 3)
detect_inf <- read.xlsx("BoAC_Inflammation_Alamar.xlsx", sheet = 2, colNames = FALSE)
colnames(detect_inf) <- c("Protein", "DetectionRate")

raw_cns    <- read.xlsx("BoAC_CNS_Alamar.xlsx", sheet = 1)
plate_cns  <- read.xlsx("BoAC_CNS_Alamar.xlsx", sheet = 3)
detect_cns <- read.xlsx("BoAC_CNS_Alamar.xlsx", sheet = "Target Detectability", colNames = FALSE)
colnames(detect_cns) <- c("Protein", "DetectionRate")

#remove SC samples
inf_clean <- raw_inf[ raw_inf$SampleType != "SC", ]
cns_clean <- raw_cns[ raw_cns$SampleType != "SC", ]

#remove proteins detected in < 90% samples
bad_inf <- detect_inf[ detect_inf$DetectionRate < 90, "Protein" ]
inf_clean <- inf_clean[ !(inf_clean$Target %in% bad_inf), ]

bad_cns <- detect_cns[ detect_cns$DetectionRate < 90, "Protein" ]
raw_cns <- raw_cns[ !(raw_cns$Target %in% bad_cns), ]

#convert INF data to WIDE format
inf_subset <- inf_clean[, c("SampleName", "Target", "NPQ")]

inf_wide <- reshape(
  inf_subset,
  idvar = "SampleName",
  timevar = "Target",
  direction = "wide"
)

#remove NPQ. prefix from column names
colnames(inf_wide) <- sub("^NPQ\\.", "", colnames(inf_wide))

#convert CNS data to WIDE format
cns_subset <- raw_cns[, c("SampleName", "Target", "NPQ")]

cns_wide <- reshape(
  cns_subset,
  idvar = "SampleName",
  timevar = "Target",
  direction = "wide"
)

colnames(cns_wide) <- sub("^NPQ\\.", "", colnames(cns_wide))

#merge inflammation and CNS datasets
full_wide <- merge(inf_wide, cns_wide, by = "SampleName", all = TRUE)

#extract Plasma.ID from SampleName
full_wide$Plasma.ID <- str_extract(full_wide$SampleName, "P\\d+")

#merge metadata with main dataset
meta <- read.xlsx("BoAC_plasma_metadata.xlsx")
merged <- merge(full_wide, meta, by = "Plasma.ID", all.x = TRUE)

#save objects to global environment
assign("inf_clean", inf_clean, envir = .GlobalEnv)
assign("inf_wide", inf_wide, envir = .GlobalEnv)
assign("cns_wide", cns_wide, envir = .GlobalEnv)
assign("full_wide", full_wide, envir = .GlobalEnv)
assign("merged", merged, envir = .GlobalEnv)