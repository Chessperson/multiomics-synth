# multiomics-synth

Generate privacy-preserving synthetic proteomics/metabolomics datasets for trauma research and AI model training. Handles high-dimensional data (e.g., 6000+ protein features) using R's `synthpop` + statistical modeling—mimics real distributions while eliminating PII risks.

## Features
- Fits CART models to mixed-type omics data for realistic synthesis.
- Produces 30-patient cohorts (90 rows x 3 timepoints) with utility validation.
- Links synthetic clinical + proteomics + metabolomics layers for end-to-end pipelines.
- Seed-controlled reproducibility for ML experiments.

## Quick Demo (Basic)
**Basic generator (`synth omics cohorts.R`):**
```r
library(synthpop); library(dplyr)
proteomics <- read.csv("sample proteomics cohorts.csv")
model <- syn(proteomics, method = "cart", seed = 42)
for(i in 1:30) write.csv(syn(proteomics, model, dataset=i), paste0("synthetic cohort ", i, ".csv"), row.names=FALSE)
```

1. Use `sample proteomics cohorts.csv`
2. `Rscript synth omics cohorts.R`
3. Output: `synthetic cohort 1.csv` ... `30.csv`

## Advanced: Full Multi-Omics v2
**Complete pipeline (`advanced synth omics v2.R`):** Full clinical/proteomics/metabolomics generator matching real trauma study structure (merged_pamper/portal styles).

- Generates: `synthetic clinical data.csv` | `synthetic proteomics merged style.csv` | `synthetic metabolomics portal style.csv`
- 30 patients × 3 timepoints = 90 rows each
- Realistic distributions for biomarkers (sphingosine, RAF1, CRYBB2)

## Sample Input
```csv
protein1,protein2,sphingosine,RAF1,CRYBB2
0.802,0.792,0.618,0.194,0.125
0.408,0.908,0.354,0.337,0.651
```
[Full sample](sample proteomics cohorts.csv)

## Usage in Bio/AI
Feed outputs to LLMs/agents:
```bash
ollama train trauma-model --data "synthetic cohort *.csv"
```
See [biomarker-llm-agent](https://github.com/chessperson/biomarker-llm-agent) for predictions.

## Tech Stack
- R 4.3+ (`synthpop`, `tidyverse`, `readxl`)
- Input: CSV/Excel (arbitrary cols/rows)
- Scales to 6000+ features

## Results Example
| Metric          | Real Data | Synthetic | Utility |
|-----------------|-----------|-----------|---------|
| Sphingosine mean| 1.2       | 1.21      | 0.87    |
| RAF1 variance   | 0.45      | 0.44      | 0.92    |

Fork, star, extend—demo ready for recruiters! 🚀
