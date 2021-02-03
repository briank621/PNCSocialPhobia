## Resting State Analysis of Social Phobia in the Philadelphia Neurodevelopment Cohort Dataset

This repository hosts code to facilitate resting state analysis.

### Getting Started

1) Go to `BrainGraphTest.Rmd` and run the first three code blocks (up to and including "Loading Covariates"). You will need to change the `datadir` variable to point to your current directory. This should load all of the subject data. The other code in that file does not need to be run, as the results have been stored in .rds files and will be loaded in other files.

2) Go to `GraphAnalyses.Rmd` and run the code blocks in order. Make sure to change the `savedir` directory to match your current directory. The code will load the graphs for each subject and run graph theory analyses. This notebook calls the following files
	- `ComputeAUC.R`: Computes the AUC for each subject for a given graph theory metric. The code returns a data table with a row for each subject and the corresponding AUC.
	- `ComputeRegionalAUC.R`: Computes the AUC for each node for a regional graph theory metric (ex. nodal global efficiency). The code returns a list of significant p-values after FDR correction, which can then be used to identify the node index.
	- `ComputeSingleRegionAUC.R`: Computes the AUC for a single node for a regional graph theory metric. The code returns a datatable with a row for each subject and corersponding AUC.

3) Go to `StatisticalAnalyses.Rmd` and run the code blocks in order. The first part checks differences in demographic data and then runs a two sample permutation t-test to check for functional connectivity differences. The FC analysis takes a long time, so the result of the analysis has been stored in the file `pvalues.rds`, which can be loaded (there is a code block which does this). 

4) Go to `VisualizeResults.Rmd` which contains all the code for generating plots using ggplot.

5) `DefineGroups.Rmd` contains code on the selection of the social phobia and control conditions. The code writes the results to `Groups.csv`, which is read by `BrainGraphTest.rmd` to define the `covars.fmri` variable.

