# HELPER SCRIPTS FOR POLYGENIC RISK SCORE ANALYSIS

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

## PRS-PT method

The PRS-PT approach is similar to what we have in PLINK. The *default* clumping options to extract LD independent SNPs for PRS are

- --clump_p1=1
- --clump_p2=1
- --clump_r2=0.1
- --clump_kb=500
- MHC region on chromosome 6 are removed post clumping 

## PRS-CS

Again, users are encouraged to familarize themselves with the function of PRS-CS @ https://github.com/getian107/PRScs. Most of the options available for PRSCS are self-explantory, and similar to what is available on the PRS-CS github as indicated. Nevetheless, it is worth mentioning that we have split the PRS-CS estimation into two steps 

    a) PRS-CS estimates weights for PRS-prediction. In the first step, the weights are estimated using the --prscs_WT=Y flag. In combination with the --prscs_WT=Y flag the --qsub option provides the user with several options. The fastest approach to computing weights is --qsub=Y. This approach sends the analysis per chromosome to a cluster. For now the wrapper is only tested for SGE (qsub) cluster. If users have access to a single high powered machine, or using the docker image provided with this wrapper on a suffciently powered computer, or if the user has a virtual machine set up on the cloud, --qsub=N, might be considered. The --qsub=N approach, parallelizes jobs using xargs, and will split the analysis into as many CPUs as the machine has. **WARNING** - while its possible to parallelize jobs, take care that there is enough memory on the system, or else the jobs would crash, or stall. Finally, users could run jobs in --qsub=S mode, which computes PRS-CS weights one chromosome at a time, using only 1 CPU for all jobs. This is useful for debugging, or if the user does not have access to a very high powered machine. The caveat is running PRS-CS with 1 CPU would take a couple of hours. 

    b) After step a) the script would exit to give time for PRS-CS weights to compute. After the weights are computed, user may resume the analysis using the --prscs_ASC=Y flag. This would invoke helper scripts that would carry out allelic scoring based on the PRS weights. For simplicity, users should simply swap out --prscs_WT=Y to --prscs_ASC=Y. All other options should stay the same. 

## PRS-CSx 

The procedures for PRS-CSx are largely similar to what was described in PRS-CS with a few notable differences. Users would notice that PRS-CSx requires input for two ancestries. Hence pop1 and pop2 are included as options and the suffixes for the n_gwas options and sumstats options include pop1 and pop2. 

**IMPORTANT**

In PRS-CS, --path2prscsref to point to the exact path to which the reference files are stored for each ancestry, while in PRS-CSx this same flag would point to the folder to which the folder are stored (one level up the directory tree). For example, 

    PRS-CS
        --path2prscsref=/home/user/reference/ldblk_1kg_eur

    PRS-CSx
        --path2prscsref=/home/user/reference/

In the reference directory, users are reminded to download the SNP manifest in the reference directory aside from the LD reference files. 