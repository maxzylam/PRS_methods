# Run Polygenic Risk Score Analysis for TMI1

The following will document the PRS analysis carried out for the TMIM1 database. Database QC and Imputation is first carried out via RICOPILI on the Broad Institute UGER SGE cluster

## Quality Control

```
#!/bin/sh
cd /stanley/huang_lab/shared/data/sc-asia/Ricopili/tmim1/PRSCSx_Target_Data_run2
preimp_dir --dis scz --pop asn --out tmi1_data1_run2
```

## GWAS Imputation 

```
#!/bin/sh
cd /stanley/huang_lab/shared/data/sc-asia/Ricopili/tmim1/PRSCSx_Target_Data_run2/qc/imputation
impute_dirsub --outname tmi1_data1_run1 --refdir /psych/genetics_data/ripke/1000Genomes_reference/1KG_Oct14/1000GP_Phase3_sr_0517d --popname EAS --multi 8 --minilong --sjamem_incr 24000 --impwallinc 200 --chunk T3
```

## PCA 

```
#!/bin/sh
cd /stanley/huang_lab/shared/data/sc-asia/Ricopili/tmim1/PRSCSx_Target_Data_run2/qc/imputation/pcaer_sub
pcaer --prefercase --preferfam --out cobg_gw.tmi1_data1_run1 scz_tmi1_asn_ml-qc1.hg19.ch.fl.bgs
```

# Preliminary steps 

Create a results folder to store results. 
```
mkdir PRS_results
```
The sample size information for each set of summary statistics could be obtained here https://personal.broadinstitute.org/hhuang//public//MDD-SCZ-prs/Sumstats.README.txt

Plesae make sure that after each PRS run is complete, the output folder should be shifted into the PRS_results folder

# trait 1a

## prscs compute weights - Run 1 EUR 
```
bash polygenic_risk_score_pred_.sh --sumstats=trait-1-a.txt.gz --target=scz_tmi1_asn_ml-qc1.hg19.ch.fl.bg --output=trait1-a-tmi1-run1 --path2plink=/home/unix/mlam/mlam/max_bin/plink/ --prscs_env=/home/unix/mlam/mlam/max_bin/envs/prscs/bin --path2prscs=/home/unix/mlam/mlam/max_bin/PRS_CS/PRScs/ --path2prscsref=/home/unix/mlam/mlam/max_bin/PRS_CS/PRScs/prscs_reffiles/ldblk_1kg_eur/ --n_gwas=8828 --qsub=Y --prscs_WT=Y
```

## prscs allelic scoring / prs modelling - Run 1 EUR    
```                                   
bash polygenic_risk_score_pred_.sh --sumstats=trait-1-a.txt.gz --target=scz_tmi1_asn_ml-qc1.hg19.ch.fl.bg --output=trait1-a-tmi1-run1 --path2plink=/home/unix/mlam/mlam/max_bin/plink/ --prscs_env=/home/unix/mlam/mlam/max_bin/envs/prscs/bin --path2prscs=/home/unix/mlam/mlam/max_bin/PRS_CS/PRScs/ --path2prscsref=/home/unix/mlam/mlam/max_bin/PRS_CS/PRScs/prscs_reffiles/ldblk_1kg_eur/ --n_gwas=8828 --prscs_ASC=Y --prsmodelling=Y --pcafile=cobg_gw.tmi1_data1_run1.menv.mds_cov --prsfile=trait1-a-tmi1-run1.prscs.file.txt --coco=C1,C2,C3,C4,C5,C6,C7,C8,C9,C10,C17 --prs_predictors=SCORE_prscs --trait=Binary --prev=0.01
```

## prscs compute weights - Run 2 EAS 
```
bash polygenic_risk_score_pred_.sh --sumstats=trait-1-a.txt.gz --target=scz_tmi1_asn_ml-qc1.hg19.ch.fl.bg --output=trait1-a-tmi1-run2 --path2plink=/home/unix/mlam/mlam/max_bin/plink/ --prscs_env=/home/unix/mlam/mlam/max_bin/envs/prscs/bin --path2prscs=/home/unix/mlam/mlam/max_bin/PRS_CS/PRScs/ --path2prscsref=/home/unix/mlam/mlam/max_bin/PRS_CS/PRScs/prscs_reffiles/ldblk_1kg_eas/ --n_gwas=8828 --qsub=Y --prscs_WT=Y
```

## prscs allelic scoring / prs modelling - Run 2 EAS         
```                              
bash polygenic_risk_score_pred_.sh --sumstats=trait-1-a.txt.gz --target=scz_tmi1_asn_ml-qc1.hg19.ch.fl.bg --output=trait1-a-tmi1-run2 --path2plink=/home/unix/mlam/mlam/max_bin/plink/ --prscs_env=/home/unix/mlam/mlam/max_bin/envs/prscs/bin --path2prscs=/home/unix/mlam/mlam/max_bin/PRS_CS/PRScs/ --path2prscsref=/home/unix/mlam/mlam/max_bin/PRS_CS/PRScs/prscs_reffiles/ldblk_1kg_eas/ --n_gwas=8828 --prscs_ASC=Y --prsmodelling=Y --pcafile=cobg_gw.tmi1_data1_run1.menv.mds_cov --prsfile=trait1-a-tmi1-run2.prscs.file.txt --coco=C1,C2,C3,C4,C5,C6,C7,C8,C9,C10,C17 --prs_predictors=SCORE_prscs --trait=Binary --prev=0.01
```

## prspt run 1 
```
bash polygenic_risk_score_pred_.sh --sumstats=trait-1-a.txt.gz --target=scz_tmi1_asn_ml-qc1.hg19.ch.fl.bg --output=trait1-a-tmi1-run1 --path2plink=/home/unix/mlam/mlam/max_bin/plink/ --prspt=Y --prsmodelling=Y --pcafile=cobg_gw.tmi1_data1_run1.menv.mds_cov --prsfile=trait1-a-tmi1-run1.prs.file.txt --coco=C1,C2,C3,C4,C5,C6,C7,C8,C9,C10,C17 --prs_predictors=SCORE_1,SCORE_2,SCORE_3,SCORE_4,SCORE_5,SCORE_6,SCORE_7,SCORE_8,SCORE_9,SCORE_10,SCORE_11,SCORE_12,SCORE_13,SCORE_14,SCORE_15,SCORE_16,SCORE_17 --trait=Binary --prev=0.01
```

# trait 1b

## prscs compute weights - Run 1 EUR 
```
bash polygenic_risk_score_pred_.sh --sumstats=trait-1-b.txt.gz --target=scz_tmi1_asn_ml-qc1.hg19.ch.fl.bg --output=trait1-b-tmi1-run1 --path2plink=/home/unix/mlam/mlam/max_bin/plink/ --prscs_env=/home/unix/mlam/mlam/max_bin/envs/prscs/bin --path2prscs=/home/unix/mlam/mlam/max_bin/PRS_CS/PRScs/ --path2prscsref=/home/unix/mlam/mlam/max_bin/PRS_CS/PRScs/prscs_reffiles/ldblk_1kg_eur/ --n_gwas=721315 --qsub=Y --prscs_WT=Y
```

## prscs allelic scoring / prs modelling - Run 1 EUR                                       
```
bash polygenic_risk_score_pred_.sh --sumstats=trait-1-b.txt.gz --target=scz_tmi1_asn_ml-qc1.hg19.ch.fl.bg --output=trait1-b-tmi1-run1 --path2plink=/home/unix/mlam/mlam/max_bin/plink/ --prscs_env=/home/unix/mlam/mlam/max_bin/envs/prscs/bin --path2prscs=/home/unix/mlam/mlam/max_bin/PRS_CS/PRScs/ --path2prscsref=/home/unix/mlam/mlam/max_bin/PRS_CS/PRScs/prscs_reffiles/ldblk_1kg_eur/ --n_gwas=721315 --prscs_ASC=Y --prsmodelling=Y --pcafile=cobg_gw.tmi1_data1_run1.menv.mds_cov --prsfile=trait1-b-tmi1-run1.prscs.file.txt --coco=C1,C2,C3,C4,C5,C6,C7,C8,C9,C10,C17 --prs_predictors=SCORE_prscs --trait=Binary --prev=0.01
```

## prscs compute weights - Run 2 EAS 
```
bash polygenic_risk_score_pred_.sh --sumstats=trait-1-b.txt.gz --target=scz_tmi1_asn_ml-qc1.hg19.ch.fl.bg --output=trait1-b-tmi1-run2 --path2plink=/home/unix/mlam/mlam/max_bin/plink/ --prscs_env=/home/unix/mlam/mlam/max_bin/envs/prscs/bin --path2prscs=/home/unix/mlam/mlam/max_bin/PRS_CS/PRScs/ --path2prscsref=/home/unix/mlam/mlam/max_bin/PRS_CS/PRScs/prscs_reffiles/ldblk_1kg_eas/ --n_gwas=721315 --qsub=Y --prscs_WT=Y
```

## prscs allelic scoring / prs modelling - Run 2 EAS                                       
```
bash polygenic_risk_score_pred_.sh --sumstats=trait-1-b.txt.gz --target=scz_tmi1_asn_ml-qc1.hg19.ch.fl.bg --output=trait1-b-tmi1-run2 --path2plink=/home/unix/mlam/mlam/max_bin/plink/ --prscs_env=/home/unix/mlam/mlam/max_bin/envs/prscs/bin --path2prscs=/home/unix/mlam/mlam/max_bin/PRS_CS/PRScs/ --path2prscsref=/home/unix/mlam/mlam/max_bin/PRS_CS/PRScs/prscs_reffiles/ldblk_1kg_eas/ --n_gwas=721315 --prscs_ASC=Y --prsmodelling=Y --pcafile=cobg_gw.tmi1_data1_run1.menv.mds_cov --prsfile=trait1-b-tmi1-run2.prscs.file.txt --coco=C1,C2,C3,C4,C5,C6,C7,C8,C9,C10,C17 --prs_predictors=SCORE_prscs --trait=Binary --prev=0.01
```

## prspt run 1 
```
bash polygenic_risk_score_pred_.sh --sumstats=trait-1-b.txt.gz --target=scz_tmi1_asn_ml-qc1.hg19.ch.fl.bg --output=trait1-b-tmi1-run1 --path2plink=/home/unix/mlam/mlam/max_bin/plink/ --prspt=Y --prsmodelling=Y --pcafile=cobg_gw.tmi1_data1_run1.menv.mds_cov --prsfile=trait1-b-tmi1-run1.prs.file.txt --coco=C1,C2,C3,C4,C5,C6,C7,C8,C9,C10,C17 --prs_predictors=SCORE_1,SCORE_2,SCORE_3,SCORE_4,SCORE_5,SCORE_6,SCORE_7,SCORE_8,SCORE_9,SCORE_10,SCORE_11,SCORE_12,SCORE_13,SCORE_14,SCORE_15,SCORE_16,SCORE_17 --trait=Binary --prev=0.01
```

# trait 2a

## prscs compute weights - Run 1 EUR 
```
bash polygenic_risk_score_pred_.sh --sumstats=trait-2-a.txt.gz --target=scz_tmi1_asn_ml-qc1.hg19.ch.fl.bg --output=trait2-a-tmi1-run1 --path2plink=/home/unix/mlam/mlam/max_bin/plink/ --prscs_env=/home/unix/mlam/mlam/max_bin/envs/prscs/bin --path2prscs=/home/unix/mlam/mlam/max_bin/PRS_CS/PRScs/ --path2prscsref=/home/unix/mlam/mlam/max_bin/PRS_CS/PRScs/prscs_reffiles/ldblk_1kg_eur/ --n_gwas=77140 --qsub=Y --prscs_WT=Y
```

## prscs allelic scoring / prs modelling - Run 1 EUR                                       
```
bash polygenic_risk_score_pred_.sh --sumstats=trait-2-a.txt.gz --target=scz_tmi1_asn_ml-qc1.hg19.ch.fl.bg --output=trait2-a-tmi1-run1 --path2plink=/home/unix/mlam/mlam/max_bin/plink/ --prscs_env=/home/unix/mlam/mlam/max_bin/envs/prscs/bin --path2prscs=/home/unix/mlam/mlam/max_bin/PRS_CS/PRScs/ --path2prscsref=/home/unix/mlam/mlam/max_bin/PRS_CS/PRScs/prscs_reffiles/ldblk_1kg_eur/ --n_gwas=77140 --prscs_ASC=Y --prsmodelling=Y --pcafile=cobg_gw.tmi1_data1_run1.menv.mds_cov --prsfile=trait2-a-tmi1-run1.prscs.file.txt --coco=C1,C2,C3,C4,C5,C6,C7,C8,C9,C10,C17 --prs_predictors=SCORE_prscs --trait=Binary --prev=0.01
```

## prscs compute weights - Run 2 EAS 
```
bash polygenic_risk_score_pred_.sh --sumstats=trait-2-a.txt.gz --target=scz_tmi1_asn_ml-qc1.hg19.ch.fl.bg --output=trait2-a-tmi1-run2 --path2plink=/home/unix/mlam/mlam/max_bin/plink/ --prscs_env=/home/unix/mlam/mlam/max_bin/envs/prscs/bin --path2prscs=/home/unix/mlam/mlam/max_bin/PRS_CS/PRScs/ --path2prscsref=/home/unix/mlam/mlam/max_bin/PRS_CS/PRScs/prscs_reffiles/ldblk_1kg_eas/ --n_gwas=77140 --qsub=Y --prscs_WT=Y
```

## prscs allelic scoring / prs modelling - Run 2 EAS      
```                                 
bash polygenic_risk_score_pred_.sh --sumstats=trait-2-a.txt.gz --target=scz_tmi1_asn_ml-qc1.hg19.ch.fl.bg --output=trait2-a-tmi1-run2 --path2plink=/home/unix/mlam/mlam/max_bin/plink/ --prscs_env=/home/unix/mlam/mlam/max_bin/envs/prscs/bin --path2prscs=/home/unix/mlam/mlam/max_bin/PRS_CS/PRScs/ --path2prscsref=/home/unix/mlam/mlam/max_bin/PRS_CS/PRScs/prscs_reffiles/ldblk_1kg_eas/ --n_gwas=77140 --prscs_ASC=Y --prsmodelling=Y --pcafile=cobg_gw.tmi1_data1_run1.menv.mds_cov --prsfile=trait2-a-tmi1-run2.prscs.file.txt --coco=C1,C2,C3,C4,C5,C6,C7,C8,C9,C10,C17 --prs_predictors=SCORE_prscs --trait=Binary --prev=0.01
```

## prspt run 1 
```
bash polygenic_risk_score_pred_.sh --sumstats=trait-2-a.txt.gz --target=scz_tmi1_asn_ml-qc1.hg19.ch.fl.bg --output=trait2-a-tmi1-run1 --path2plink=/home/unix/mlam/mlam/max_bin/plink/ --prspt=Y --prsmodelling=Y --pcafile=cobg_gw.tmi1_data1_run1.menv.mds_cov --prsfile=trait2-a-tmi1-run1.prs.file.txt --coco=C1,C2,C3,C4,C5,C6,C7,C8,C9,C10,C17 --prs_predictors=SCORE_1,SCORE_2,SCORE_3,SCORE_4,SCORE_5,SCORE_6,SCORE_7,SCORE_8,SCORE_9,SCORE_10,SCORE_11,SCORE_12,SCORE_13,SCORE_14,SCORE_15,SCORE_16,SCORE_17 --trait=Binary --prev=0.01
```
# trait 2b

## prscs compute weights - Run 1 EUR 
```
bash polygenic_risk_score_pred_.sh --sumstats=trait-2-b.txt.gz --target=scz_tmi1_asn_ml-qc1.hg19.ch.fl.bg --output=trait2-b-tmi1-run1 --path2plink=/home/unix/mlam/mlam/max_bin/plink/ --prscs_env=/home/unix/mlam/mlam/max_bin/envs/prscs/bin --path2prscs=/home/unix/mlam/mlam/max_bin/PRS_CS/PRScs/ --path2prscsref=/home/unix/mlam/mlam/max_bin/PRS_CS/PRScs/prscs_reffiles/ldblk_1kg_eur/ --n_gwas=109346 --qsub=Y --prscs_WT=Y
```

## prscs allelic scoring / prs modelling - Run 1 EUR     
```                                  
bash polygenic_risk_score_pred_.sh --sumstats=trait-2-b.txt.gz --target=scz_tmi1_asn_ml-qc1.hg19.ch.fl.bg --output=trait2-b-tmi1-run1 --path2plink=/home/unix/mlam/mlam/max_bin/plink/ --prscs_env=/home/unix/mlam/mlam/max_bin/envs/prscs/bin --path2prscs=/home/unix/mlam/mlam/max_bin/PRS_CS/PRScs/ --path2prscsref=/home/unix/mlam/mlam/max_bin/PRS_CS/PRScs/prscs_reffiles/ldblk_1kg_eur/ --n_gwas=109346 --prscs_ASC=Y --prsmodelling=Y --pcafile=cobg_gw.tmi1_data1_run1.menv.mds_cov --prsfile=trait2-b-tmi1-run1.prscs.file.txt --coco=C1,C2,C3,C4,C5,C6,C7,C8,C9,C10,C17 --prs_predictors=SCORE_prscs --trait=Binary --prev=0.01
```

## prscs compute weights - Run 2 EAS 
```
bash polygenic_risk_score_pred_.sh --sumstats=trait-2-b.txt.gz --target=scz_tmi1_asn_ml-qc1.hg19.ch.fl.bg --output=trait2-b-tmi1-run2 --path2plink=/home/unix/mlam/mlam/max_bin/plink/ --prscs_env=/home/unix/mlam/mlam/max_bin/envs/prscs/bin --path2prscs=/home/unix/mlam/mlam/max_bin/PRS_CS/PRScs/ --path2prscsref=/home/unix/mlam/mlam/max_bin/PRS_CS/PRScs/prscs_reffiles/ldblk_1kg_eas/ --n_gwas=109346 --qsub=Y --prscs_WT=Y
```

## prscs allelic scoring / prs modelling - Run 2 EAS    
```                                   
bash polygenic_risk_score_pred_.sh --sumstats=trait-2-b.txt.gz --target=scz_tmi1_asn_ml-qc1.hg19.ch.fl.bg --output=trait2-b-tmi1-run2 --path2plink=/home/unix/mlam/mlam/max_bin/plink/ --prscs_env=/home/unix/mlam/mlam/max_bin/envs/prscs/bin --path2prscs=/home/unix/mlam/mlam/max_bin/PRS_CS/PRScs/ --path2prscsref=/home/unix/mlam/mlam/max_bin/PRS_CS/PRScs/prscs_reffiles/ldblk_1kg_eas/ --n_gwas=109346 --prscs_ASC=Y --prsmodelling=Y --pcafile=cobg_gw.tmi1_data1_run1.menv.mds_cov --prsfile=trait2-b-tmi1-run2.prscs.file.txt --coco=C1,C2,C3,C4,C5,C6,C7,C8,C9,C10,C17 --prs_predictors=SCORE_prscs --trait=Binary --prev=0.01
```

## prspt run 1 
```
bash polygenic_risk_score_pred_.sh --sumstats=trait-2-b.txt.gz --target=scz_tmi1_asn_ml-qc1.hg19.ch.fl.bg --output=trait2-b-tmi1-run1 --path2plink=/home/unix/mlam/mlam/max_bin/plink/ --prspt=Y --prsmodelling=Y --pcafile=cobg_gw.tmi1_data1_run1.menv.mds_cov --prsfile=trait2-b-tmi1-run1.prs.file.txt --coco=C1,C2,C3,C4,C5,C6,C7,C8,C9,C10,C17 --prs_predictors=SCORE_1,SCORE_2,SCORE_3,SCORE_4,SCORE_5,SCORE_6,SCORE_7,SCORE_8,SCORE_9,SCORE_10,SCORE_11,SCORE_12,SCORE_13,SCORE_14,SCORE_15,SCORE_16,SCORE_17 --trait=Binary --prev=0.01
```

# trait 3a

## prscs compute weights - Run 1 EUR 
```
bash polygenic_risk_score_pred_.sh --sumstats=trait-3-a.txt.gz --target=scz_tmi1_asn_ml-qc1.hg19.ch.fl.bg --output=trait3-a-tmi1-run1 --path2plink=/home/unix/mlam/mlam/max_bin/plink/ --prscs_env=/home/unix/mlam/mlam/max_bin/envs/prscs/bin --path2prscs=/home/unix/mlam/mlam/max_bin/PRS_CS/PRScs/ --path2prscsref=/home/unix/mlam/mlam/max_bin/PRS_CS/PRScs/prscs_reffiles/ldblk_1kg_eur/ --n_gwas=792016 --qsub=Y --prscs_WT=Y
```

## prscs allelic scoring / prs modelling - Run 1 EUR    
```                                   
bash polygenic_risk_score_pred_.sh --sumstats=trait-3-a.txt.gz --target=scz_tmi1_asn_ml-qc1.hg19.ch.fl.bg --output=trait3-a-tmi1-run1 --path2plink=/home/unix/mlam/mlam/max_bin/plink/ --prscs_env=/home/unix/mlam/mlam/max_bin/envs/prscs/bin --path2prscs=/home/unix/mlam/mlam/max_bin/PRS_CS/PRScs/ --path2prscsref=/home/unix/mlam/mlam/max_bin/PRS_CS/PRScs/prscs_reffiles/ldblk_1kg_eur/ --n_gwas=792016 --prscs_ASC=Y --prsmodelling=Y --pcafile=cobg_gw.tmi1_data1_run1.menv.mds_cov --prsfile=trait3-a-tmi1-run1.prscs.file.txt --coco=C1,C2,C3,C4,C5,C6,C7,C8,C9,C10,C17 --prs_predictors=SCORE_prscs --trait=Binary --prev=0.01
```

## prscs compute weights - Run 2 EAS 
```
bash polygenic_risk_score_pred_.sh --sumstats=trait-3-a.txt.gz --target=scz_tmi1_asn_ml-qc1.hg19.ch.fl.bg --output=trait3-a-tmi1-run2 --path2plink=/home/unix/mlam/mlam/max_bin/plink/ --prscs_env=/home/unix/mlam/mlam/max_bin/envs/prscs/bin --path2prscs=/home/unix/mlam/mlam/max_bin/PRS_CS/PRScs/ --path2prscsref=/home/unix/mlam/mlam/max_bin/PRS_CS/PRScs/prscs_reffiles/ldblk_1kg_eas/ --n_gwas=792016 --qsub=Y --prscs_WT=Y
```

## prscs allelic scoring / prs modelling - Run 2 EAS    
```                                   
bash polygenic_risk_score_pred_.sh --sumstats=trait-3-a.txt.gz --target=scz_tmi1_asn_ml-qc1.hg19.ch.fl.bg --output=trait3-a-tmi1-run2 --path2plink=/home/unix/mlam/mlam/max_bin/plink/ --prscs_env=/home/unix/mlam/mlam/max_bin/envs/prscs/bin --path2prscs=/home/unix/mlam/mlam/max_bin/PRS_CS/PRScs/ --path2prscsref=/home/unix/mlam/mlam/max_bin/PRS_CS/PRScs/prscs_reffiles/ldblk_1kg_eas/ --n_gwas=792016 --prscs_ASC=Y --prsmodelling=Y --pcafile=cobg_gw.tmi1_data1_run1.menv.mds_cov --prsfile=trait3-a-tmi1-run2.prscs.file.txt --coco=C1,C2,C3,C4,C5,C6,C7,C8,C9,C10,C17 --prs_predictors=SCORE_prscs --trait=Binary --prev=0.01

```

## prspt run 1 
```
bash polygenic_risk_score_pred_.sh --sumstats=trait-3-a.txt.gz --target=scz_tmi1_asn_ml-qc1.hg19.ch.fl.bg --output=trait3-a-tmi1-run1 --path2plink=/home/unix/mlam/mlam/max_bin/plink/ --prspt=Y --prsmodelling=Y --pcafile=cobg_gw.tmi1_data1_run1.menv.mds_cov --prsfile=trait3-a-tmi1-run1.prs.file.txt --coco=C1,C2,C3,C4,C5,C6,C7,C8,C9,C10,C17 --prs_predictors=SCORE_1,SCORE_2,SCORE_3,SCORE_4,SCORE_5,SCORE_6,SCORE_7,SCORE_8,SCORE_9,SCORE_10,SCORE_11,SCORE_12,SCORE_13,SCORE_14,SCORE_15,SCORE_16,SCORE_17 --trait=Binary --prev=0.01
```

# trait 3b

## prscs compute weights - Run 1 EUR 
```
bash polygenic_risk_score_pred_.sh --sumstats=trait-3-b.txt.gz --target=scz_tmi1_asn_ml-qc1.hg19.ch.fl.bg --output=trait3-b-tmi1-run1 --path2plink=/home/unix/mlam/mlam/max_bin/plink/ --prscs_env=/home/unix/mlam/mlam/max_bin/envs/prscs/bin --path2prscs=/home/unix/mlam/mlam/max_bin/PRS_CS/PRScs/ --path2prscsref=/home/unix/mlam/mlam/max_bin/PRS_CS/PRScs/prscs_reffiles/ldblk_1kg_eur/ --n_gwas=126282 --qsub=Y --prscs_WT=Y
```

## prscs allelic scoring / prs modelling - Run 1 EUR      
```                                 
bash polygenic_risk_score_pred_.sh --sumstats=trait-3-b.txt.gz --target=scz_tmi1_asn_ml-qc1.hg19.ch.fl.bg --output=trait3-b-tmi1-run1 --path2plink=/home/unix/mlam/mlam/max_bin/plink/ --prscs_env=/home/unix/mlam/mlam/max_bin/envs/prscs/bin --path2prscs=/home/unix/mlam/mlam/max_bin/PRS_CS/PRScs/ --path2prscsref=/home/unix/mlam/mlam/max_bin/PRS_CS/PRScs/prscs_reffiles/ldblk_1kg_eur/ --n_gwas=126282 --prscs_ASC=Y --prsmodelling=Y --pcafile=cobg_gw.tmi1_data1_run1.menv.mds_cov --prsfile=trait3-b-tmi1-run1.prscs.file.txt --coco=C1,C2,C3,C4,C5,C6,C7,C8,C9,C10,C17 --prs_predictors=SCORE_prscs --trait=Binary --prev=0.01
```

## prscs compute weights - Run 2 EAS 
```
bash polygenic_risk_score_pred_.sh --sumstats=trait-3-b.txt.gz --target=scz_tmi1_asn_ml-qc1.hg19.ch.fl.bg --output=trait3-b-tmi1-run2 --path2plink=/home/unix/mlam/mlam/max_bin/plink/ --prscs_env=/home/unix/mlam/mlam/max_bin/envs/prscs/bin --path2prscs=/home/unix/mlam/mlam/max_bin/PRS_CS/PRScs/ --path2prscsref=/home/unix/mlam/mlam/max_bin/PRS_CS/PRScs/prscs_reffiles/ldblk_1kg_eas/ --n_gwas=126282 --qsub=Y --prscs_WT=Y
```

## prscs allelic scoring / prs modelling - Run 2 EAS       
```                                
bash polygenic_risk_score_pred_.sh --sumstats=trait-3-b.txt.gz --target=scz_tmi1_asn_ml-qc1.hg19.ch.fl.bg --output=trait3-b-tmi1-run2 --path2plink=/home/unix/mlam/mlam/max_bin/plink/ --prscs_env=/home/unix/mlam/mlam/max_bin/envs/prscs/bin --path2prscs=/home/unix/mlam/mlam/max_bin/PRS_CS/PRScs/ --path2prscsref=/home/unix/mlam/mlam/max_bin/PRS_CS/PRScs/prscs_reffiles/ldblk_1kg_eas/ --n_gwas=126282 --prscs_ASC=Y --prsmodelling=Y --pcafile=cobg_gw.tmi1_data1_run1.menv.mds_cov --prsfile=trait3-b-tmi1-run2.prscs.file.txt --coco=C1,C2,C3,C4,C5,C6,C7,C8,C9,C10,C17 --prs_predictors=SCORE_prscs --trait=Binary --prev=0.01
```

## prspt run 1 
```
bash polygenic_risk_score_pred_.sh --sumstats=trait-3-b.txt.gz --target=scz_tmi1_asn_ml-qc1.hg19.ch.fl.bg --output=trait3-b-tmi1-run1 --path2plink=/home/unix/mlam/mlam/max_bin/plink/ --prspt=Y --prsmodelling=Y --pcafile=cobg_gw.tmi1_data1_run1.menv.mds_cov --prsfile=trait3-b-tmi1-run1.prs.file.txt --coco=C1,C2,C3,C4,C5,C6,C7,C8,C9,C10,C17 --prs_predictors=SCORE_1,SCORE_2,SCORE_3,SCORE_4,SCORE_5,SCORE_6,SCORE_7,SCORE_8,SCORE_9,SCORE_10,SCORE_11,SCORE_12,SCORE_13,SCORE_14,SCORE_15,SCORE_16,SCORE_17 --trait=Binary --prev=0.01
```

# Test Run PRS-CSx
    

## prscsx trait 1 run 1
```
bash polygenic_risk_score_pred_.sh --sumstats_pop1=trait-1-a.txt.gz --sumstats_pop2=trait-1-b.txt.gz --pop1=EAS --pop2=EUR --target=scz_tmi1_asn_ml-qc1.hg19.ch.fl.bg --output=trait1-a-tmi1-run1 --path2plink=/home/unix/mlam/mlam/max_bin/plink/ --prscs_env=/home/unix/mlam/mlam/max_bin/envs/prscs/bin --path2prscsx=/home/unix/mlam/mlam/max_bin/PRS_CS/PRScsx/ --path2prscsref=/home/unix/mlam/mlam/max_bin/PRS_CS/PRScs/prscs_reffiles/ --n_gwas_pop1=8828 --n_gwas_pop2=721315 --qsub=Y --prscs_WT=Y
```
## prscsx stage 1 run 1  
```                                     
bash polygenic_risk_score_pred_.sh --sumstats_pop1=trait-1-a.txt.gz --sumstats_pop2=trait-1-b.txt.gz --pop1=EAS --pop2=EUR --target=scz_tmi1_asn_ml-qc1.hg19.ch.fl.bg --output=trait1-a-tmi1-run1 --path2plink=/home/unix/mlam/mlam/max_bin/plink/ --prscs_env=/home/unix/mlam/mlam/max_bin/envs/prscs/bin --path2prscsx=/home/unix/mlam/mlam/max_bin/PRS_CS/PRScsx/ --path2prscsref=/home/unix/mlam/mlam/max_bin/PRS_CS/PRScs/prscs_reffiles/ --n_gwas_pop1=8828 --n_gwas_pop2=721315 --prscs_ASC=Y
```

## prscsx trait 2 run 1
```
bash polygenic_risk_score_pred_.sh --sumstats_pop1=trait-2-a.txt.gz --sumstats_pop2=trait-2-b.txt.gz --pop1=EAS --pop2=EUR --target=scz_tmi1_asn_ml-qc1.hg19.ch.fl.bg --output=trait2-a-tmi1-run1 --path2plink=/home/unix/mlam/mlam/max_bin/plink/ --prscs_env=/home/unix/mlam/mlam/max_bin/envs/prscs/bin --path2prscsx=/home/unix/mlam/mlam/max_bin/PRS_CS/PRScsx/ --path2prscsref=/home/unix/mlam/mlam/max_bin/PRS_CS/PRScs/prscs_reffiles/ --n_gwas_pop1=77140 --n_gwas_pop2=109346 --qsub=Y --prscs_WT=Y
```
## prscsx stage 2 run 1  
```                                     
bash polygenic_risk_score_pred_.sh --sumstats_pop1=trait-2-a.txt.gz --sumstats_pop2=trait-2-b.txt.gz --pop1=EAS --pop2=EUR --target=scz_tmi1_asn_ml-qc1.hg19.ch.fl.bg --output=trait2-a-tmi1-run1 --path2plink=/home/unix/mlam/mlam/max_bin/plink/ --prscs_env=/home/unix/mlam/mlam/max_bin/envs/prscs/bin --path2prscsx=/home/unix/mlam/mlam/max_bin/PRS_CS/PRScsx/ --path2prscsref=/home/unix/mlam/mlam/max_bin/PRS_CS/PRScs/prscs_reffiles/ --n_gwas_pop1=77140 --n_gwas_pop2=109346 --prscs_ASC=Y
```

