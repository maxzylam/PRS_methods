# WRAPPER SCRIPT FOR POLYGENIC RISK SCORE ANALYSIS

This wrapper consists of several helper scripts that would help the user carry out polygenic risk prediction in their own datasets give a set of summary statistics. The methods that the helper scripts are based on include tradtional polygenic risk scoring methods reported in Purcell et al., 2007 as part of the PLINK software, PRSCS reported by Ge et al., 2019, and the forthcoming PRSCSx - a cross ancestry version of PRSCS developed by Yunfeng, Ruan, Ge Tian and Hailiang Huang. All functions of the wrapper are consolidated in a single script, but would require various software and dependencies to be installed. 

## Dependencies 

- PLINK 1.9x
- PRSCS 
- PRSCSx
- Python 2.7x
    -  SciPy
    -  H5Py
- R
    - tidyverse
    - data.table
    - pROC

As there are multiple dependencies to set up to get the wrapper working, we have tried to streamline the process by providing a docker image with these dependencies installed. (https://personal.broadinstitute.org/hhuang//public//MDD-SCZ-prs/). With the docker image, all the user is required to do is to download the reference files for PRS CS and PRS CSx which are also found in the same link above. 

## Helper script functions

The functions of the wrapper could be exposed by the --help flag within the script

```
 ./polygenic_risk_scores_pred_.sh [OPTIONS]
                
                General file definition 
                
                --sumstats) :   Input summary statistics - Please make sure it is gzipped
                --sumstats_pop1) : Input summary statistics - PRSCSx population 1 summaty statistics
                --sumstats_pop2) : Input summary statistics - PRSCSx population 2 summary statistics 
                --target)   :   Target prediction file - plink binary files
                                ^ Users are highly adviced to have QC-ed their target file via RICOPILI
                --output)   :   output prefix for PRS analysis
                --path2plink : Path to plink <--- This is score computeing allele scores 

                Polygenic Risk - P-value Thresholding 
                
                --prspt) : if Y, runs PRS-PT analysis
                --clump_p1) : Primary P value 
                --clump_p2) : Secondary P value
                --clump_r2) : LD threshold
                --clump_kb) : Genomic window for clumping
                --range_file) : (optional) - See plink instructions --q-range-file

                PRS-CS options 

                --prscs_WT) : Stage1 - Run weighting step of PRS-CS. 
                --prscs_ASC) : Stage 2 - Run Allelic scoring step of PRS-CS 
                --prscs_env) : Path to PRSCS environment 
                --path2prscs) : Path to PRSCS .py script 
                --phi)  : PRSCS tuning parameter (defaults to 1e-2)
                --path2prscsref) : Path to reference folders 
                --path2bim) : Path to target file (defaults to present working directory)
                --path2sumstats) : Path to sumstats ( defaults to present workding directory)
                --path2output) : Path to output (defaults to present working directory) 
                --n_gwas)   :   sample size  
                --qsub)     :   if Y, submits parallel jobs to a HPC cluster. If N, runs parallel jobs using xargs

                PRS-CSx options 

                --prscsx_WT) : Stage 1 - Run weighting step of PRS-CSx 
                --prscsx_ASC) : Stage 2 - Run Allelic scoring step of PRS-CSx 
                --prscs_env) : (Not a typo) This will be the same as PRS-CS 
                --path2prscsx) : Path to PRSCSx .py script
                --pop1) : Population for sumstats 1 
                --pop2) : Population for sumstats 2 
                --n_gwas_pop1)   :   sample size for population 1 
                --n_gwas_pop2)   :   sample size for population 2 

                PRS Modelling 

                --prsmodelling) :   if Y, runs modelling module 
                --prsfile)  :   PRS file that consists of allelic scores from previous steps. Note unique ID is FID 
                --pcafile)  :   PCA file generated based on individual level genotype, Note unique ID is FID
                --coco)     :   PCs <--- C1,C2,C3,... comma delkmited with no white space
                --prs_predictors : PRS predictors, these are columns with SCORE prefix
                --trait     :   [Binary|Quantitative], Binary = case control DV, Quantitative = continuous DV
                --prev      :   If --trait=Binary, --prev=[population prevalence of the disease]
```
**IMPORTANT**

Prior to running polygenic risk prediction analysis one should familiarize the PRS scoring approaches here (https://pubmed.ncbi.nlm.nih.gov/32709988/). This wrapper assumes 
    
    a) The genotype data, in PLINK binary files, used for computing polygenic risk scores have gone through at least minimal GWAS QC. If not, consult the PLINK manual on how to process PLINK binary files here (https://www.cog-genomics.org/plink/). We recommend filtering the genotype files with at least 98% non-missing rate and retain variants with at least MAF of 0.01 if the dataset is relatively small, and 0.005 if the dataset is reasonably large (> 100K) 
    
    b) We highly recommend users to process their data through RICOPILI (https://sites.google.com/a/broadinstitute.org/ricopili/) that allows GWAS data processing to be standardized and imputed. The current wrapper does not carry out PCA on the genotype data, and users could either carry out in PLINK or RICOPILI. In downstream data merging, it would necessary to note that **FID would be used as the unique ID**. 


As users would see, the options exposed in the helpscript involves PRSPT, PRSCS and PRSCSx. Here, we would go through each option in detail. 

## GENERAL OPTIONS

--sumstats={name of sumstats file} <-- This option is pretty much self-explanatory. The user would provide the summmary statistics witih this option. The --sumstats flag allows users to specifiy the base sumstats for PRS allelic scoring procedures. This option is used for PRSPT and PRSCS procedures. 

Summary statistics input format for the current helper script takes the form of 

| SNP    	|  A1 	| A2  	| beta     	| SE     	| P      	|
|--------	|:---:	|-----	|----------	|--------	|--------	|
| rs1234 	| A   	| G   	| -0.00725 	| 0.0273 	| 0.142  	|
| rs457  	| C   	| T   	| 0.9351   	| 0.0351 	| 0.0729 	|
| ...    	| ... 	| ... 	| ..       	| ..     	| ..     	|

--sumstats_pop1 & --sumstats_pop2 <--- These two flags are for PRSCSx. If the user is performing PRSCSx, these options would allow summary statistics derived from two ancestries to be used for prediction into the target genotype file. And would be useful in enchancing the power of polygenic risk score prediction. 

--target <--- prefix for PLINK binary file i.e. {prefix.bed/.bim/.fam}

--output <--- output suffix for files that are generated from the current set of helper scripts 

--path2plink <--- The plink software is used in all instances for allelic scoring. The idea behind allelic scoring is summing up the genotype of 