.PHONY: all analysis plots classifier report clean

all: analysis plots classifier report

analysis: analysis.R
	Rscript analysis.R
	touch analysis.done


plots: \
    plot_age_proteins \
    plot_age_regression \
    plot_age_sex \
    plot_corr_heatmap \
    plot_sex_box \
    plot_sex_classifier

plot_age_proteins: analysis.done
	Rscript age_proteins.R

plot_age_regression: analysis.done
	Rscript age_regression.R

plot_age_sex: analysis.done
	Rscript age_sex.R

plot_corr_heatmap: analysis.done
	Rscript corr_heatmap.R

plot_sex_box: analysis.done
	Rscript sex_box.R

plot_sex_classifier: analysis.done
	Rscript sex_classifier.R

report:
	Rscript -e "rmarkdown::render('report.Rmd', output_format = 'pdf_document')"

clean:
	rm -f *.png
	rm -f report.pdf
	rm -f *.txt
	rm -f *.rds