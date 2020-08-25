##### Run PRS for TMI1

    # trait 1a

        # prscs compute weights - Run 1 EUR 
        bash polygenic_risk_score_pred_.sh --sumstats=trait-1-a.txt.gz --target=scz_tmi1_asn_ml-qc1.hg19.ch.fl.bg --output=trait1-a-tmi1-run1 --path2plink=/home/unix/mlam/mlam/max_bin/plink/ --prscs_env=/home/unix/mlam/mlam/max_bin/envs/prscs/bin --path2prscs=/home/unix/mlam/mlam/max_bin/PRS_CS/PRScs/ --path2prscsref=/home/unix/mlam/mlam/max_bin/PRS_CS/PRScs/prscs_reffiles/ldblk_1kg_eur/ --n_gwas=8828 --qsub=Y --prscs_WT=Y

        # prscs allelic scoring / prs modelling - Run 1 EUR                                       
        bash polygenic_risk_score_pred_.sh --sumstats=trait-1-a.txt.gz --target=scz_tmi1_asn_ml-qc1.hg19.ch.fl.bg --output=trait1-a-tmi1-run1 --path2plink=/home/unix/mlam/mlam/max_bin/plink/ --prscs_env=/home/unix/mlam/mlam/max_bin/envs/prscs/bin --path2prscs=/home/unix/mlam/mlam/max_bin/PRS_CS/PRScs/ --path2prscsref=/home/unix/mlam/mlam/max_bin/PRS_CS/PRScs/prscs_reffiles/ldblk_1kg_eur/ --n_gwas=8828 --prscs_ASC=Y --prsmodelling=Y --pcafile=cobg_gw.tmi1_data1_run1.menv.mds_cov --prsfile=trait1-a-tmi1-run1.prscs.file.txt --coco=C1,C2,C3,C4,C5,C6,C7,C8,C9,C10 --prs_predictors=SCORE_prscs --trait=Binary --prev=0.01

        # prscs compute weights - Run 2 EAS 
        bash polygenic_risk_score_pred_.sh --sumstats=trait-1-a.txt.gz --target=scz_tmi1_asn_ml-qc1.hg19.ch.fl.bg --output=trait1-a-tmi1-run2 --path2plink=/home/unix/mlam/mlam/max_bin/plink/ --prscs_env=/home/unix/mlam/mlam/max_bin/envs/prscs/bin --path2prscs=/home/unix/mlam/mlam/max_bin/PRS_CS/PRScs/ --path2prscsref=/home/unix/mlam/mlam/max_bin/PRS_CS/PRScs/prscs_reffiles/ldblk_1kg_eas/ --n_gwas=8828 --qsub=Y --prscs_WT=Y

        # prscs allelic scoring / prs modelling - Run 2 EAS                                       
        bash polygenic_risk_score_pred_.sh --sumstats=trait-1-a.txt.gz --target=scz_tmi1_asn_ml-qc1.hg19.ch.fl.bg --output=trait1-a-tmi1-run2 --path2plink=/home/unix/mlam/mlam/max_bin/plink/ --prscs_env=/home/unix/mlam/mlam/max_bin/envs/prscs/bin --path2prscs=/home/unix/mlam/mlam/max_bin/PRS_CS/PRScs/ --path2prscsref=/home/unix/mlam/mlam/max_bin/PRS_CS/PRScs/prscs_reffiles/ldblk_1kg_eas/ --n_gwas=8828 --prscs_ASC=Y --prsmodelling=Y --pcafile=cobg_gw.tmi1_data1_run1.menv.mds_cov --prsfile=trait1-a-tmi1-run1.prscs.file.txt --coco=C1,C2,C3,C4,C5,C6,C7,C8,C9,C10 --prs_predictors=SCORE_prscs --trait=Binary --prev=0.01

        # prspt run 1 
        bash polygenic_risk_score_pred_.sh --sumstats=trait-1-a.txt.gz --target=scz_tmi1_asn_ml-qc1.hg19.ch.fl.bg --output=trait1-a-tmi1-run1 --path2plink=/home/unix/mlam/mlam/max_bin/plink/ --prspt=Y --prsmodelling=Y --pcafile=cobg_gw.tmi1_data1_run1.menv.mds_cov --prsfile=trait1-a-tmi1-run1.prs.file.txt --coco=C1,C2,C3,C4,C5,C6,C7,C8,C9,C10 --prs_predictors=SCORE_1,SCORE_2,SCORE_3,SCORE_4,SCORE_5,SCORE_6,SCORE_7,SCORE_8,SCORE_9,SCORE_10,SCORE_11,SCORE_12,SCORE_13,SCORE_14,SCORE_15,SCORE_16,SCORE_17 --trait=Binary --prev=0.01
    
    # trait 1b

        # prscs compute weights - Run 1 EUR 
        bash polygenic_risk_score_pred_.sh --sumstats=trait-1-b.txt.gz --target=scz_tmi1_asn_ml-qc1.hg19.ch.fl.bg --output=trait1-b-tmi1-run1 --path2plink=/home/unix/mlam/mlam/max_bin/plink/ --prscs_env=/home/unix/mlam/mlam/max_bin/envs/prscs/bin --path2prscs=/home/unix/mlam/mlam/max_bin/PRS_CS/PRScs/ --path2prscsref=/home/unix/mlam/mlam/max_bin/PRS_CS/PRScs/prscs_reffiles/ldblk_1kg_eur/ --n_gwas=8828 --qsub=Y --prscs_WT=Y

        # prscs allelic scoring / prs modelling - Run 1 EUR                                       
        bash polygenic_risk_score_pred_.sh --sumstats=trait-1-b.txt.gz --target=scz_tmi1_asn_ml-qc1.hg19.ch.fl.bg --output=trait1-b-tmi1-run1 --path2plink=/home/unix/mlam/mlam/max_bin/plink/ --prscs_env=/home/unix/mlam/mlam/max_bin/envs/prscs/bin --path2prscs=/home/unix/mlam/mlam/max_bin/PRS_CS/PRScs/ --path2prscsref=/home/unix/mlam/mlam/max_bin/PRS_CS/PRScs/prscs_reffiles/ldblk_1kg_eur/ --n_gwas=8828 --prscs_ASC=Y --prsmodelling=Y --pcafile=cobg_gw.tmi1_data1_run1.menv.mds_cov --prsfile=trait1-b-tmi1-run1.prscs.file.txt --coco=C1,C2,C3,C4,C5,C6,C7,C8,C9,C10 --prs_predictors=SCORE_prscs --trait=Binary --prev=0.01

        # prscs compute weights - Run 2 EAS 
        bash polygenic_risk_score_pred_.sh --sumstats=trait-1-b.txt.gz --target=scz_tmi1_asn_ml-qc1.hg19.ch.fl.bg --output=trait1-b-tmi1-run2 --path2plink=/home/unix/mlam/mlam/max_bin/plink/ --prscs_env=/home/unix/mlam/mlam/max_bin/envs/prscs/bin --path2prscs=/home/unix/mlam/mlam/max_bin/PRS_CS/PRScs/ --path2prscsref=/home/unix/mlam/mlam/max_bin/PRS_CS/PRScs/prscs_reffiles/ldblk_1kg_eas/ --n_gwas=8828 --qsub=Y --prscs_WT=Y

        # prscs allelic scoring / prs modelling - Run 2 EAS                                       
        bash polygenic_risk_score_pred_.sh --sumstats=trait-1-b.txt.gz --target=scz_tmi1_asn_ml-qc1.hg19.ch.fl.bg --output=trait1-b-tmi1-run2 --path2plink=/home/unix/mlam/mlam/max_bin/plink/ --prscs_env=/home/unix/mlam/mlam/max_bin/envs/prscs/bin --path2prscs=/home/unix/mlam/mlam/max_bin/PRS_CS/PRScs/ --path2prscsref=/home/unix/mlam/mlam/max_bin/PRS_CS/PRScs/prscs_reffiles/ldblk_1kg_eas/ --n_gwas=8828 --prscs_ASC=Y --prsmodelling=Y --pcafile=cobg_gw.tmi1_data1_run1.menv.mds_cov --prsfile=trait1-b-tmi1-run1.prscs.file.txt --coco=C1,C2,C3,C4,C5,C6,C7,C8,C9,C10 --prs_predictors=SCORE_prscs --trait=Binary --prev=0.01

        # prspt run 1 
        bash polygenic_risk_score_pred_.sh --sumstats=trait-1-b.txt.gz --target=scz_tmi1_asn_ml-qc1.hg19.ch.fl.bg --output=trait1-b-tmi1-run1 --path2plink=/home/unix/mlam/mlam/max_bin/plink/ --prspt=Y --prsmodelling=Y --pcafile=cobg_gw.tmi1_data1_run1.menv.mds_cov --prsfile=trait1-b-tmi1-run1.prs.file.txt --coco=C1,C2,C3,C4,C5,C6,C7,C8,C9,C10 --prs_predictors=SCORE_1,SCORE_2,SCORE_3,SCORE_4,SCORE_5,SCORE_6,SCORE_7,SCORE_8,SCORE_9,SCORE_10,SCORE_11,SCORE_12,SCORE_13,SCORE_14,SCORE_15,SCORE_16,SCORE_17 --trait=Binary --prev=0.01

    # trait 2a

        # prscs compute weights - Run 1 EUR 
        bash polygenic_risk_score_pred_.sh --sumstats=trait-2-a.txt.gz --target=scz_tmi1_asn_ml-qc1.hg19.ch.fl.bg --output=trait2-a-tmi1-run1 --path2plink=/home/unix/mlam/mlam/max_bin/plink/ --prscs_env=/home/unix/mlam/mlam/max_bin/envs/prscs/bin --path2prscs=/home/unix/mlam/mlam/max_bin/PRS_CS/PRScs/ --path2prscsref=/home/unix/mlam/mlam/max_bin/PRS_CS/PRScs/prscs_reffiles/ldblk_1kg_eur/ --n_gwas=8828 --qsub=Y --prscs_WT=Y

        # prscs allelic scoring / prs modelling - Run 1 EUR                                       
        bash polygenic_risk_score_pred_.sh --sumstats=trait-2-a.txt.gz --target=scz_tmi1_asn_ml-qc1.hg19.ch.fl.bg --output=trait2-a-tmi1-run1 --path2plink=/home/unix/mlam/mlam/max_bin/plink/ --prscs_env=/home/unix/mlam/mlam/max_bin/envs/prscs/bin --path2prscs=/home/unix/mlam/mlam/max_bin/PRS_CS/PRScs/ --path2prscsref=/home/unix/mlam/mlam/max_bin/PRS_CS/PRScs/prscs_reffiles/ldblk_1kg_eur/ --n_gwas=8828 --prscs_ASC=Y --prsmodelling=Y --pcafile=cobg_gw.tmi1_data1_run1.menv.mds_cov --prsfile=trait2-a-tmi1-run1.prscs.file.txt --coco=C1,C2,C3,C4,C5,C6,C7,C8,C9,C10 --prs_predictors=SCORE_prscs --trait=Binary --prev=0.01

        # prscs compute weights - Run 2 EAS 
        bash polygenic_risk_score_pred_.sh --sumstats=trait-2-a.txt.gz --target=scz_tmi1_asn_ml-qc1.hg19.ch.fl.bg --output=trait2-a-tmi1-run2 --path2plink=/home/unix/mlam/mlam/max_bin/plink/ --prscs_env=/home/unix/mlam/mlam/max_bin/envs/prscs/bin --path2prscs=/home/unix/mlam/mlam/max_bin/PRS_CS/PRScs/ --path2prscsref=/home/unix/mlam/mlam/max_bin/PRS_CS/PRScs/prscs_reffiles/ldblk_1kg_eas/ --n_gwas=8828 --qsub=Y --prscs_WT=Y

        # prscs allelic scoring / prs modelling - Run 2 EAS                                       
        bash polygenic_risk_score_pred_.sh --sumstats=trait-2-a.txt.gz --target=scz_tmi1_asn_ml-qc1.hg19.ch.fl.bg --output=trait2-a-tmi1-run2 --path2plink=/home/unix/mlam/mlam/max_bin/plink/ --prscs_env=/home/unix/mlam/mlam/max_bin/envs/prscs/bin --path2prscs=/home/unix/mlam/mlam/max_bin/PRS_CS/PRScs/ --path2prscsref=/home/unix/mlam/mlam/max_bin/PRS_CS/PRScs/prscs_reffiles/ldblk_1kg_eas/ --n_gwas=8828 --prscs_ASC=Y --prsmodelling=Y --pcafile=cobg_gw.tmi1_data1_run1.menv.mds_cov --prsfile=trait2-a-tmi1-run1.prscs.file.txt --coco=C1,C2,C3,C4,C5,C6,C7,C8,C9,C10 --prs_predictors=SCORE_prscs --trait=Binary --prev=0.01

        # prspt run 1 
        bash polygenic_risk_score_pred_.sh --sumstats=trait-2-a.txt.gz --target=scz_tmi1_asn_ml-qc1.hg19.ch.fl.bg --output=trait2-a-tmi1-run1 --path2plink=/home/unix/mlam/mlam/max_bin/plink/ --prspt=Y --prsmodelling=Y --pcafile=cobg_gw.tmi1_data1_run1.menv.mds_cov --prsfile=trait2-a-tmi1-run1.prs.file.txt --coco=C1,C2,C3,C4,C5,C6,C7,C8,C9,C10 --prs_predictors=SCORE_1,SCORE_2,SCORE_3,SCORE_4,SCORE_5,SCORE_6,SCORE_7,SCORE_8,SCORE_9,SCORE_10,SCORE_11,SCORE_12,SCORE_13,SCORE_14,SCORE_15,SCORE_16,SCORE_17 --trait=Binary --prev=0.01
    
    # trait 2b

        # prscs compute weights - Run 1 EUR 
        bash polygenic_risk_score_pred_.sh --sumstats=trait-2-b.txt.gz --target=scz_tmi1_asn_ml-qc1.hg19.ch.fl.bg --output=trait2-b-tmi1-run1 --path2plink=/home/unix/mlam/mlam/max_bin/plink/ --prscs_env=/home/unix/mlam/mlam/max_bin/envs/prscs/bin --path2prscs=/home/unix/mlam/mlam/max_bin/PRS_CS/PRScs/ --path2prscsref=/home/unix/mlam/mlam/max_bin/PRS_CS/PRScs/prscs_reffiles/ldblk_1kg_eur/ --n_gwas=8828 --qsub=Y --prscs_WT=Y

        # prscs allelic scoring / prs modelling - Run 1 EUR                                       
        bash polygenic_risk_score_pred_.sh --sumstats=trait-2-b.txt.gz --target=scz_tmi1_asn_ml-qc1.hg19.ch.fl.bg --output=trait2-b-tmi1-run1 --path2plink=/home/unix/mlam/mlam/max_bin/plink/ --prscs_env=/home/unix/mlam/mlam/max_bin/envs/prscs/bin --path2prscs=/home/unix/mlam/mlam/max_bin/PRS_CS/PRScs/ --path2prscsref=/home/unix/mlam/mlam/max_bin/PRS_CS/PRScs/prscs_reffiles/ldblk_1kg_eur/ --n_gwas=8828 --prscs_ASC=Y --prsmodelling=Y --pcafile=cobg_gw.tmi1_data1_run1.menv.mds_cov --prsfile=trait2-b-tmi1-run1.prscs.file.txt --coco=C1,C2,C3,C4,C5,C6,C7,C8,C9,C10 --prs_predictors=SCORE_prscs --trait=Binary --prev=0.01

        # prscs compute weights - Run 2 EAS 
        bash polygenic_risk_score_pred_.sh --sumstats=trait-2-b.txt.gz --target=scz_tmi1_asn_ml-qc1.hg19.ch.fl.bg --output=trait2-b-tmi1-run2 --path2plink=/home/unix/mlam/mlam/max_bin/plink/ --prscs_env=/home/unix/mlam/mlam/max_bin/envs/prscs/bin --path2prscs=/home/unix/mlam/mlam/max_bin/PRS_CS/PRScs/ --path2prscsref=/home/unix/mlam/mlam/max_bin/PRS_CS/PRScs/prscs_reffiles/ldblk_1kg_eas/ --n_gwas=8828 --qsub=Y --prscs_WT=Y

        # prscs allelic scoring / prs modelling - Run 2 EAS                                       
        bash polygenic_risk_score_pred_.sh --sumstats=trait-2-b.txt.gz --target=scz_tmi1_asn_ml-qc1.hg19.ch.fl.bg --output=trait2-b-tmi1-run2 --path2plink=/home/unix/mlam/mlam/max_bin/plink/ --prscs_env=/home/unix/mlam/mlam/max_bin/envs/prscs/bin --path2prscs=/home/unix/mlam/mlam/max_bin/PRS_CS/PRScs/ --path2prscsref=/home/unix/mlam/mlam/max_bin/PRS_CS/PRScs/prscs_reffiles/ldblk_1kg_eas/ --n_gwas=8828 --prscs_ASC=Y --prsmodelling=Y --pcafile=cobg_gw.tmi1_data1_run1.menv.mds_cov --prsfile=trait2-b-tmi1-run1.prscs.file.txt --coco=C1,C2,C3,C4,C5,C6,C7,C8,C9,C10 --prs_predictors=SCORE_prscs --trait=Binary --prev=0.01

        # prspt run 1 
        bash polygenic_risk_score_pred_.sh --sumstats=trait-2-b.txt.gz --target=scz_tmi1_asn_ml-qc1.hg19.ch.fl.bg --output=trait2-b-tmi1-run1 --path2plink=/home/unix/mlam/mlam/max_bin/plink/ --prspt=Y --prsmodelling=Y --pcafile=cobg_gw.tmi1_data1_run1.menv.mds_cov --prsfile=trait2-b-tmi1-run1.prs.file.txt --coco=C1,C2,C3,C4,C5,C6,C7,C8,C9,C10 --prs_predictors=SCORE_1,SCORE_2,SCORE_3,SCORE_4,SCORE_5,SCORE_6,SCORE_7,SCORE_8,SCORE_9,SCORE_10,SCORE_11,SCORE_12,SCORE_13,SCORE_14,SCORE_15,SCORE_16,SCORE_17 --trait=Binary --prev=0.01

    # trait 3a

        # prscs compute weights - Run 1 EUR 
        bash polygenic_risk_score_pred_.sh --sumstats=trait-3-a.txt.gz --target=scz_tmi1_asn_ml-qc1.hg19.ch.fl.bg --output=trait3-a-tmi1-run1 --path2plink=/home/unix/mlam/mlam/max_bin/plink/ --prscs_env=/home/unix/mlam/mlam/max_bin/envs/prscs/bin --path2prscs=/home/unix/mlam/mlam/max_bin/PRS_CS/PRScs/ --path2prscsref=/home/unix/mlam/mlam/max_bin/PRS_CS/PRScs/prscs_reffiles/ldblk_1kg_eur/ --n_gwas=8828 --qsub=Y --prscs_WT=Y

        # prscs allelic scoring / prs modelling - Run 1 EUR                                       
        bash polygenic_risk_score_pred_.sh --sumstats=trait-3-a.txt.gz --target=scz_tmi1_asn_ml-qc1.hg19.ch.fl.bg --output=trait3-a-tmi1-run1 --path2plink=/home/unix/mlam/mlam/max_bin/plink/ --prscs_env=/home/unix/mlam/mlam/max_bin/envs/prscs/bin --path2prscs=/home/unix/mlam/mlam/max_bin/PRS_CS/PRScs/ --path2prscsref=/home/unix/mlam/mlam/max_bin/PRS_CS/PRScs/prscs_reffiles/ldblk_1kg_eur/ --n_gwas=8828 --prscs_ASC=Y --prsmodelling=Y --pcafile=cobg_gw.tmi1_data1_run1.menv.mds_cov --prsfile=trait3-a-tmi1-run1.prscs.file.txt --coco=C1,C2,C3,C4,C5,C6,C7,C8,C9,C10 --prs_predictors=SCORE_prscs --trait=Binary --prev=0.01

        # prscs compute weights - Run 2 EAS 
        bash polygenic_risk_score_pred_.sh --sumstats=trait-3-a.txt.gz --target=scz_tmi1_asn_ml-qc1.hg19.ch.fl.bg --output=trait3-a-tmi1-run2 --path2plink=/home/unix/mlam/mlam/max_bin/plink/ --prscs_env=/home/unix/mlam/mlam/max_bin/envs/prscs/bin --path2prscs=/home/unix/mlam/mlam/max_bin/PRS_CS/PRScs/ --path2prscsref=/home/unix/mlam/mlam/max_bin/PRS_CS/PRScs/prscs_reffiles/ldblk_1kg_eas/ --n_gwas=8828 --qsub=Y --prscs_WT=Y

        # prscs allelic scoring / prs modelling - Run 2 EAS                                       
        bash polygenic_risk_score_pred_.sh --sumstats=trait-3-a.txt.gz --target=scz_tmi1_asn_ml-qc1.hg19.ch.fl.bg --output=trait3-a-tmi1-run2 --path2plink=/home/unix/mlam/mlam/max_bin/plink/ --prscs_env=/home/unix/mlam/mlam/max_bin/envs/prscs/bin --path2prscs=/home/unix/mlam/mlam/max_bin/PRS_CS/PRScs/ --path2prscsref=/home/unix/mlam/mlam/max_bin/PRS_CS/PRScs/prscs_reffiles/ldblk_1kg_eas/ --n_gwas=8828 --prscs_ASC=Y --prsmodelling=Y --pcafile=cobg_gw.tmi1_data1_run1.menv.mds_cov --prsfile=trait3-a-tmi1-run1.prscs.file.txt --coco=C1,C2,C3,C4,C5,C6,C7,C8,C9,C10 --prs_predictors=SCORE_prscs --trait=Binary --prev=0.01

        # prspt run 1 
        bash polygenic_risk_score_pred_.sh --sumstats=trait-3-a.txt.gz --target=scz_tmi1_asn_ml-qc1.hg19.ch.fl.bg --output=trait3-a-tmi1-run1 --path2plink=/home/unix/mlam/mlam/max_bin/plink/ --prspt=Y --prsmodelling=Y --pcafile=cobg_gw.tmi1_data1_run1.menv.mds_cov --prsfile=trait3-a-tmi1-run1.prs.file.txt --coco=C1,C2,C3,C4,C5,C6,C7,C8,C9,C10 --prs_predictors=SCORE_1,SCORE_2,SCORE_3,SCORE_4,SCORE_5,SCORE_6,SCORE_7,SCORE_8,SCORE_9,SCORE_10,SCORE_11,SCORE_12,SCORE_13,SCORE_14,SCORE_15,SCORE_16,SCORE_17 --trait=Binary --prev=0.01
    
    # trait 3b

        # prscs compute weights - Run 1 EUR 
        bash polygenic_risk_score_pred_.sh --sumstats=trait-3-b.txt.gz --target=scz_tmi1_asn_ml-qc1.hg19.ch.fl.bg --output=trait3-b-tmi1-run1 --path2plink=/home/unix/mlam/mlam/max_bin/plink/ --prscs_env=/home/unix/mlam/mlam/max_bin/envs/prscs/bin --path2prscs=/home/unix/mlam/mlam/max_bin/PRS_CS/PRScs/ --path2prscsref=/home/unix/mlam/mlam/max_bin/PRS_CS/PRScs/prscs_reffiles/ldblk_1kg_eur/ --n_gwas=8828 --qsub=Y --prscs_WT=Y

        # prscs allelic scoring / prs modelling - Run 1 EUR                                       
        bash polygenic_risk_score_pred_.sh --sumstats=trait-3-b.txt.gz --target=scz_tmi1_asn_ml-qc1.hg19.ch.fl.bg --output=trait3-b-tmi1-run1 --path2plink=/home/unix/mlam/mlam/max_bin/plink/ --prscs_env=/home/unix/mlam/mlam/max_bin/envs/prscs/bin --path2prscs=/home/unix/mlam/mlam/max_bin/PRS_CS/PRScs/ --path2prscsref=/home/unix/mlam/mlam/max_bin/PRS_CS/PRScs/prscs_reffiles/ldblk_1kg_eur/ --n_gwas=8828 --prscs_ASC=Y --prsmodelling=Y --pcafile=cobg_gw.tmi1_data1_run1.menv.mds_cov --prsfile=trait3-b-tmi1-run1.prscs.file.txt --coco=C1,C2,C3,C4,C5,C6,C7,C8,C9,C10 --prs_predictors=SCORE_prscs --trait=Binary --prev=0.01

        # prscs compute weights - Run 2 EAS 
        bash polygenic_risk_score_pred_.sh --sumstats=trait-3-b.txt.gz --target=scz_tmi1_asn_ml-qc1.hg19.ch.fl.bg --output=trait3-b-tmi1-run2 --path2plink=/home/unix/mlam/mlam/max_bin/plink/ --prscs_env=/home/unix/mlam/mlam/max_bin/envs/prscs/bin --path2prscs=/home/unix/mlam/mlam/max_bin/PRS_CS/PRScs/ --path2prscsref=/home/unix/mlam/mlam/max_bin/PRS_CS/PRScs/prscs_reffiles/ldblk_1kg_eas/ --n_gwas=8828 --qsub=Y --prscs_WT=Y

        # prscs allelic scoring / prs modelling - Run 2 EAS                                       
        bash polygenic_risk_score_pred_.sh --sumstats=trait-3-b.txt.gz --target=scz_tmi1_asn_ml-qc1.hg19.ch.fl.bg --output=trait3-b-tmi1-run2 --path2plink=/home/unix/mlam/mlam/max_bin/plink/ --prscs_env=/home/unix/mlam/mlam/max_bin/envs/prscs/bin --path2prscs=/home/unix/mlam/mlam/max_bin/PRS_CS/PRScs/ --path2prscsref=/home/unix/mlam/mlam/max_bin/PRS_CS/PRScs/prscs_reffiles/ldblk_1kg_eas/ --n_gwas=8828 --prscs_ASC=Y --prsmodelling=Y --pcafile=cobg_gw.tmi1_data1_run1.menv.mds_cov --prsfile=trait3-b-tmi1-run1.prscs.file.txt --coco=C1,C2,C3,C4,C5,C6,C7,C8,C9,C10 --prs_predictors=SCORE_prscs --trait=Binary --prev=0.01

        # prspt run 1 
        bash polygenic_risk_score_pred_.sh --sumstats=trait-3-b.txt.gz --target=scz_tmi1_asn_ml-qc1.hg19.ch.fl.bg --output=trait3-b-tmi1-run1 --path2plink=/home/unix/mlam/mlam/max_bin/plink/ --prspt=Y --prsmodelling=Y --pcafile=cobg_gw.tmi1_data1_run1.menv.mds_cov --prsfile=trait3-b-tmi1-run1.prs.file.txt --coco=C1,C2,C3,C4,C5,C6,C7,C8,C9,C10 --prs_predictors=SCORE_1,SCORE_2,SCORE_3,SCORE_4,SCORE_5,SCORE_6,SCORE_7,SCORE_8,SCORE_9,SCORE_10,SCORE_11,SCORE_12,SCORE_13,SCORE_14,SCORE_15,SCORE_16,SCORE_17 --trait=Binary --prev=0.01


            

        # prscsx trait 1 run 1
        bash polygenic_risk_score_pred_.sh --sumstats_pop1=trait-1-a.txt.gz --sumstats_pop2=trait-1-b.txt.gz --pop1=EAS --pop2=EUR --target=scz_tmi1_asn_ml-qc1.hg19.ch.fl.bg --output=trait1-a-tmi1-run1 --path2plink=/home/unix/mlam/mlam/max_bin/plink/ --prscs_env=/home/unix/mlam/mlam/max_bin/envs/prscs/bin --path2prscsx=/home/unix/mlam/mlam/max_bin/PRS_CS/PRScsx/ --path2prscsref=/home/unix/mlam/mlam/max_bin/PRS_CS/PRScs/prscs_reffiles/ --n_gwas_pop1=8828 --n_gwas_pop2=721315 --qsub=Y --prscs_WT=Y

        # prscsx stage 1 run 1                                       
        bash polygenic_risk_score_pred_.sh --sumstats_pop1=trait-1-a.txt.gz --sumstats_pop2=trait-1-b.txt.gz --pop1=EAS --pop2=EUR --target=scz_tmi1_asn_ml-qc1.hg19.ch.fl.bg --output=trait1-a-tmi1-run1 --path2plink=/home/unix/mlam/mlam/max_bin/plink/ --prscs_env=/home/unix/mlam/mlam/max_bin/envs/prscs/bin --path2prscsx=/home/unix/mlam/mlam/max_bin/PRS_CS/PRScsx/ --path2prscsref=/home/unix/mlam/mlam/max_bin/PRS_CS/PRScs/prscs_reffiles/ --n_gwas_pop1=8828 
        n_gwas_pop2=721315
        prscs_ASC=Y


