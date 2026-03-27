library(synthpop)
library(dplyr)

# Your data (update path)
proteomics <- read.csv("sample proteomics cohorts.csv")

# Generate synthetic
model <- syn(proteomics, method = "cart", seed = 42)
syn_df <- syn(proteomics, model = model, dataset = 1)

# Validate
compare <- compare(syn_df, proteomics)
print(compare$single)

# 30 cohorts
for(i in 1:30) {
  cohort <- syn(proteomics, model = model, dataset = i)
  write.csv(cohort, paste0("synthetic cohort ", i, ".csv"), row.names = FALSE)
}
