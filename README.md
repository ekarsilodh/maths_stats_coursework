# MSc Bioinformatics – Mathematics & Statistics Coursework

This repository contains my **Mathematics and Statistics coursework** completed as part of the **MSc Bioinformatics** programme at the **University of Birmingham**.

The coursework is implemented in **R / R Markdown** and includes simulation-based analysis, statistical modelling, and visualisation.

---

## Repository Structure

```text
.
├── cw_ekarsi.Rmd        # Main R Markdown coursework report
├── cw_functions.R      # Helper / utility functions used in the analysis
├── data/               # Input data (.Rdata files) – see notes below
├── assets/             # Assets (e.g., University logo) – see notes below
├── README.md
└── LICENSE
```

---

## Requirements

- R (>= 4.2 recommended)
- R packages used in the coursework include:
  - `ggplot2`
  - `dplyr`
  - `tidyr`
  - `knitr`
  - `rmarkdown`

(Exact packages and usage are documented within the R Markdown file.)

---

## How to Reproduce the Results

1. Clone the repository:
   ```bash
   git clone https://github.com/<your-username>/<repo-name>.git
   cd <repo-name>
   ```

2. Ensure the required data file is present:
   ```text
   data/assess_data_1225.Rdata
   ```

3. Render the coursework report:
   ```r
   source("cw_functions.R")
   rmarkdown::render(
     input = "cw_ekarsi.Rmd"
   )
   ```

4. The rendered HTML/PDF will be available in the `~` directory.

---

## Data and Asset Notes

- The `data/` directory contains coursework-specific `.Rdata` files.

- The `assets/` directory contain the University of Birmingham logo.
  - This is used strictly for academic presentation purposes.

---

## Academic Integrity Notice

This repository is shared **for learning, reference, and portfolio purposes only**.

If you are a current student:
- **Do not copy or submit this work** as part of any assessment.
- Refer to your institution’s academic integrity policies.

---

## Author

**Ekarsi Lodh**  
MSc Bioinformatics  
University of Birmingham  

---

## License

This project is released under the **MIT License**.  
See the `LICENSE` file for details.
