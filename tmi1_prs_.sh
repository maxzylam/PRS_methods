##### Run PRS for TMI1

    # trait 1a

        # prscs stage 1 run 1
        sumstats=trait-1-a.txt.gz
        target=scz_tmi1_asn_ml-qc1.hg19.ch.fl.bg
        output=trait1-a-tmi1-run1
        path2plink=/home/unix/mlam/mlam/max_bin/plink/
        prscs_env=/home/unix/mlam/mlam/max_bin/envs/prscs/bin
        path2prscs=/home/unix/mlam/mlam/max_bin/PRS_CS/PRScs/
        path2prscsref=/home/unix/mlam/mlam/max_bin/PRS_CS/PRScs/prscs_reffiles/ldblk_1kg_eur/
        n_gwas=8828
        qsub=Y
        prscs_WT=Y

        # prscs stage 1 run 1                                       
        sumstats=trait-1-a.txt.gz
        target=scz_tmi1_asn_ml-qc1.hg19.ch.fl.bg
        output=trait1-a-tmi1-run1
        path2plink=/home/unix/mlam/mlam/max_bin/plink/
        prscs_env=/home/unix/mlam/mlam/max_bin/envs/prscs/bin
        path2prscs=/home/unix/mlam/mlam/max_bin/PRS_CS/PRScs/
        path2prscsref=/home/unix/mlam/mlam/max_bin/PRS_CS/PRScs/prscs_reffiles/ldblk_1kg_eur/
        n_gwas=8828
        prscs_ASC=Y

        # prscs stage 1 run 2
        sumstats=trait-1-a.txt.gz
        target=scz_tmi1_asn_ml-qc1.hg19.ch.fl.bg
        output=trait1-a-tmi1-run2
        path2plink=/home/unix/mlam/mlam/max_bin/plink/
        prscs_env=/home/unix/mlam/mlam/max_bin/envs/prscs/bin
        path2prscs=/home/unix/mlam/mlam/max_bin/PRS_CS/PRScs/
        path2prscsref=/home/unix/mlam/mlam/max_bin/PRS_CS/PRScs/prscs_reffiles/ldblk_1kg_eas/
        n_gwas=8828
        qsub=Y
        prscs_WT=Y

        # prscs stage 1 run 2                                       
        sumstats=trait-1-a.txt.gz
        target=scz_tmi1_asn_ml-qc1.hg19.ch.fl.bg
        output=trait1-a-tmi1-run2
        path2plink=/home/unix/mlam/mlam/max_bin/plink/
        prscs_env=/home/unix/mlam/mlam/max_bin/envs/prscs/bin
        path2prscs=/home/unix/mlam/mlam/max_bin/PRS_CS/PRScs/
        path2prscsref=/home/unix/mlam/mlam/max_bin/PRS_CS/PRScs/prscs_reffiles/ldblk_1kg_eas/
        n_gwas=8828
        prscs_ASC=Y

        # prspt run 1 
        sumstats=trait-1-a.txt.gz
        target=scz_tmi1_asn_ml-qc1.hg19.ch.fl.bg
        output=trait1-a-tmi1-run1
        path2plink=/home/unix/mlam/mlam/max_bin/plink/
        prspt=Y

        # prscsx stage 1 run 1
        sumstats_pop1=trait-1-a.txt.gz
        sumstats_pop2=trait-1-b.txt.gz
        pop1=EAS
        pop2=EUR
        target=scz_tmi1_asn_ml-qc1.hg19.ch.fl.bg
        output=trait1-a-tmi1-run1
        path2plink=/home/unix/mlam/mlam/max_bin/plink/
        prscs_env=/home/unix/mlam/mlam/max_bin/envs/prscs/bin
        path2prscsx=/home/unix/mlam/mlam/max_bin/PRS_CS/PRScsx/
        path2prscsref=/home/unix/mlam/mlam/max_bin/PRS_CS/PRScs/prscs_reffiles/
        n_gwas_pop1=8828
        n_gwas_pop2=721315
        qsub=Y
        prscs_WT=Y

        # prscsx stage 1 run 1                                       
        sumstats_pop1=trait-1-a.txt.gz
        sumstats_pop2=trait-1-b.txt.gz
        pop1=EAS
        pop2=EUR
        target=scz_tmi1_asn_ml-qc1.hg19.ch.fl.bg
        output=trait1-a-tmi1-run1
        path2plink=/home/unix/mlam/mlam/max_bin/plink/
        prscs_env=/home/unix/mlam/mlam/max_bin/envs/prscs/bin
        path2prscsx=/home/unix/mlam/mlam/max_bin/PRS_CS/PRScsx/
        path2prscsref=/home/unix/mlam/mlam/max_bin/PRS_CS/PRScs/prscs_reffiles/
        n_gwas_pop1=8828
        n_gwas_pop2=721315
        prscs_ASC=Y
