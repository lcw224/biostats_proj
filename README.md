Biomarkers of Aging Challenge Proteomics

3 datasets exploring plasma protein expression in 503 adult participants aged 20-90 yrs old.
Each participant is measured for ~5,000 plasma protein biomarkers.

Protein categories:
Immune & inflammatory
Neuro-related (CNS)

For each protein, the dataset provides: Protein name, NPX (normalized protein expression) value, Detection rate

Metadata:Age, Sex, Race/Ethnicity, Sample ID / Plate ID

Focus of this analysis: Top 10 highest-variance age-related proteins

The project uses three datasets:
BoAC_Inflammation_Alamar.xlsx
BoAC_CNS_Alamar.xlsx
BoAC_plasma_metadata.xlsx
These files are included in the repository.

Developer instructions
This project is organised as a Makefile:
Run everything (analysis + plots + report):
make
Run only the preprocessing step:
make analysis
Generate all plots:
make plots
Run only the Sex classifier:
make sex_classifier
Build the final PDF report:
make report
Remove all generated output files:
make clean
See the Makefile for full details of the workflow.

Running the Docker container
1. Build the container
docker build -t biostats_proj 
2. Run the container
docker run -it biostats_proj
Once inside the container, use the Makefile normally:
make

The final report is generated from report.Rmd.
To build a PDF report:
make report
The Makefile runs:
rmarkdown::render("report.Rmd", output_format = "pdf_document")
The output report.pdf will appear in the project directory.
