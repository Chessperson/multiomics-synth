library(tidyverse)
library(synthpop)
library(readxl)

# Load layers (update paths to your samples)
prote_real <- read_excel("proteomics layer.xlsx") %>% 
  select(Subject_ID, `Study ID`, `Time point`, everything(), -starts_with("c"))

metab_real <- read_csv("metabolomics portal.csv") %>%  
  select(Study_ID, `Time point`, age, gender, icu_los, iss, traumatic_brain_injury, 
         ais_head, ais_face, ais_chest, ais_abdomen, ais_extremity, ais_external, 
         everything(), -contains("shock_index"))

clin_ids <- read_excel("clinical data.xlsx", sheet = "IDs Dictionary")

set.seed(42)
n_patients <- 30

# Synthetic clinical (90 rows: 30 patients x 3 timepoints)
synth_clin <- data.frame(
  Study_ID = paste0("SYN", sprintf("%04d", 1:n_patients)),
  Subject_ID = paste0("SYN", sprintf("%04d", 1:n_patients)),
  Time_point = rep(c(0, 24, 72), n_patients),
  age = rnorm(n_patients*3, mean=45, sd=15) %>% pmax(18) %>% pmin(90),
  gender = sample(c(0,1), n_patients*3, replace=TRUE, prob=c(0.7, 0.3)),
  icu_los = rgamma(n_patients*3, shape=3, rate=0.3) %>% round(1),
  iss = sample(9:75, n_patients*3, replace=TRUE),
  traumatic_brain_injury = sample(c(0,1,2), n_patients*3, replace=TRUE, prob=c(0.6, 0.3, 0.1)),
  ais_head = sample(c(0,1,2,3), n_patients*3, replace=TRUE, prob=c(0.4, 0.3, 0.2, 0.1)),
  ais_chest = sample(c(0,1,2,3), n_patients*3, replace=TRUE, prob=c(0.5, 0.3, 0.15, 0.05)),
  ais_abdomen = sample(c(0,1,2,3), n_patients*3, replace=TRUE, prob=c(0.6, 0.25, 0.1, 0.05)),
  ais_extremity = sample(c(0,1,2), n_patients*3, replace=TRUE, prob=c(0.3, 0.5, 0.2))
) 

# Proteomics layer
synth_prote <- synth_clin
prote_cols <- setdiff(names(prote_real), c("Subject_ID", "Study ID", "Time point"))
for(col in prote_cols) {
  real_vals <- prote_real[[col]] %>% na.omit()
  synth_prote[[col]] <- if(length(real_vals)>0) rnorm(nrow(synth_prote), mean=mean(real_vals), sd=sd(real_vals)) else rnorm(nrow(synth_prote), 1000, 500)
}

# Metabolomics layer  
synth_metab <- synth_clin
metab_cols <- setdiff(names(metab_real), c("Study_ID", "Time point", "age", "gender", "icu_los", "iss", "traumatic_brain_injury", "ais_head", "ais_face", "ais_chest", "ais_abdomen", "ais_extremity", "ais_external"))
for(col in metab_cols) {
  real_vals <- metab_real[[col]] %>% na.omit()
  synth_metab[[col]] <- if(length(real_vals)>0) exp(rnorm(nrow(synth_metab), mean=mean(real_vals), sd=sd(real_vals))) else rnorm(nrow(synth_metab), 0, 1)
}

# Export (spaces only)
write_csv(synth_clin, "synthetic clinical data.csv")
write_csv(synth_prote, "synthetic proteomics merged style.csv")
write_csv(synth_metab, "synthetic metabolomics portal style.csv")

cat("✅ 30-cohort multi-omics pipeline complete!\nFiles: synthetic clinical data.csv | proteomics | metabolomics\n")
