############################################
### Polygenic Risk Score Analysis 

    function helpscript {
        echo "The current wrapper performs polygenic risk score analysis based on standard PT
        methods, PRSCS, and PRSCSx. The first part of the analysis extracts weights for PRS prediction 
        the second stage calculates the totaled polygenic risk score for the dataset in question. Next we combine
        each set of polygenic risk score with the PCA output of the dataset that is studied. For this wrapper
        we assume that the individual level genotypes have been processed and QC-ed via the RICOPILI pipeline."
    
        echo "Usage options -
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
                "
    
    }

############################################

############################################
### def merge.files.sh
### Bash to R function for merging files

    echo "
        library(\"data.table\")
        library(\"tidyverse\")
        file1 <- fread(\"FILE1\")
        file2 <- fread(\"FILE2\")
        file1file2 <- inner_join(file1, file2, by=\"KEY\")
        fwrite(file1file2, file=\"OUTMERGE\", quote=FALSE, sep=\"\t\", na=\"NA\")
    " > file_merge

    printf "
        # Parameters
            while [ \"\$1\" != \"\" ];do
                PARAM=\`echo \$1 | awk -F= '{print \$1}'\`
                VALUE=\`echo \$1 | awk -F= '{print \$2}'\`
                case \$PARAM in
                        --FILE1)
                            FILE1=\$VALUE
                            ;;
                        --FILE2)
                            FILE2=\$VALUE
                            ;;
                        --KEY)
                            KEY=\$VALUE
                            ;;
                        --OUTMERGE)
                            OUTMERGE=\$VALUE
                            ;;
                        \$)
                        echo \"ERROR:unknown parameter \ "\$PARAM\ "\"
                        esac
                        shift
            done

        # substitute vars

        echo \"cat file_merge | sed 's/FILE1/\$FILE1/g' | sed 's/FILE2/\$FILE2/g' | sed 's/KEY/\$KEY/g' | sed 's/OUTMERGE/\$OUTMERGE/g' > merge.R\" > merge.sh

        bash merge.sh
        
        R CMD BATCH --no-save merge.R
        
        " > merge.files.sh

        chmod +x merge.files.sh

############################################

############################################
### General file definition

    # Define Summary statistics file 
    # Define Target level genotype file 

    # Assigning parameters

        while [ "$1" != "" ];do
            PARAM=`echo $1 | awk -F= '{print $1}'`
            VALUE=`echo $1 | awk -F= '{print $2}'`
            case $PARAM in
                    -h | --help)
                            helpscript
                            exit 1
                            ;;
                    --sumstats)
                            sumstats=$VALUE 
                            ;;
                    --sumstats_pop1)
                            sumstats_pop1=$VALUE 
                            ;;
                    --sumstats_pop2)
                            sumstats_pop2=$VALUE
                            ;;
                    --target)
                            target=$VALUE 
                            ;;
                    --output)
                            output=$VALUE
                            ;;
                    --prspt)
                            prspt=$VALUE 
                            ;;
                    --path2plink)
                            path2plink=$VALUE
                            ;;
                    --clump_p1)
                            clump_p1=$VALUE
                            ;;
                    --clump_p2)
                            clump_p2=$VALUE
                            ;;
                    --clump_r2)
                            clump_r2=$VALUE
                            ;;
                    --clump_kb)
                            clump_kb=$VALUE
                            ;;
                    --range_file)
                            range_file=$VALUE
                            ;;
                    --prscs_WT)
                            prscs_WT=$VALUE 
                            ;;
                    --prscs_ASC)
                            prscs_ASC=$VALUE 
                            ;;
                    --prcs_env)
                            prscs_env=$VALUE
                            ;;
                    --path2prscs)
                            path2prscs=$VALUE
                            ;;
                    --phi)
                            phi=$VALUE
                            ;;
                    --path2prscsref)
                            path2prscsref=$VALUE
                            ;;
                    --path2bim)
                            path2bim=$VALUE
                            ;;
                    --path2sumstats)
                            path2sumstats=$VALUE
                            ;;
                    --path2output)
                            path2output=$VALUE
                            ;;
                    --path2prscsx)
                            path2prscsx=$VALUE
                            ;;
                    --prscsx_WT)
                            prscs_WT=$VALUE 
                            ;;
                    --prscsx_ASC)
                            prscs_ASC=$VALUE 
                            ;;
                    --n_gwas)
                            n_gwas=$VALUE
                            ;;
                    --n_gwas_pop1)
                            n_gwas_pop1=$VALUE
                            ;;
                    --n_gwas_pop2)
                            n_gwas_pop2=$VALUE 
                            ;;
                    --pop1)
                            pop1=$VALUE 
                            ;;
                    --pop2)
                            pop2=$VALUE 
                            ;;
                    --qsub)
                            qsub=$VALUE 
                            ;;
                    --prsmodelling)
                            prsmodelling=$VALUE 
                            ;;
                    --prsfile)
                            prsfile=$VALUE 
                            ;;
                    --pcafile)
                            pcafile=$VALUE
                            ;;
                    --coco)
                            coco==$VALUE 
                            ;;
                    --prs_predictors)
                            prs_predictors=$VALUE
                            ;;
                    --trait)
                            trait=$VALUE 
                            ;;
                    --prev)
                            prev=$VALUE 
                            ;;
                    $)
                            echo "ERROR:unknown parameter \ "$PARAM\ ""
                            helpscript
                    esac
                    shift
        done
    
    # File check 

        if [ ! -f "$sumstats" ]; then 
            echo "Can't find sumstats file - Aborting"
            exit 1 
        fi 

        if [ ! -f "$target.fam" ]; then 
            echo "Can't find target fam file - Aborting"
            exit 1 
        fi 

        if [ ! -f "$target.bim" ]; then 
            echo "Can't find target bim file - Aborting"
            exit 1 
        fi 

        if [ ! -f "$target.bed" ]; then 
            echo "Can't find target bed file - Aborting"
            exit 1 
        fi 

        if [ -z "$output" ]; then 
            echo "Plese define output file before proceed - Aborting"
            exit 1 
        fi
    # >>>

############################################

############################################
### Logger 
    if [ ! -f $output.prs_analysis.log ]; then  

        echo "#######################################" 2>&1 | tee $output.prs_analysis.log
        echo "### POLYGENIC RISK SCORE PREDICTION ###" 2>&1 | tee -a $output.prs_analysis.log
        echo "#######################################" 2>&1 | tee -a $output.prs_analysis.log
        echo "" 2>&1 | tee -a $output.prs_analysis.log
        echo "Analyst Initials : $(id -u -n)" 2>&1 | tee -a $output.prs_analysis.log
        echo "" 2>&1 | tee -a $output.prs_analysis.log
        echo "PRS prediction analysis for $target intiated on $(date)" 2>&1 | tee -a $output.prs_analysis.log
        echo "" 2>&1 | tee -a $output.prs_analysis.log
        echo "GWAS Summary statistics = $sumstats" 2>&1 | tee -a $output.prs_analysis.log
        echo ""
        echo "Target Data for PRS prediction = $target" 2>&1 | tee -a $output.prs_analysis.log
        echo ""
        echo "Output prefix for PRS prediction = $output" 2>&1 | tee -a $output.prs_analysis.log
    else 

        echo " # # # # # # > > > > < < < < # # # # # #"  2>&1 | tee -a $output.prs_analysis.log
        echo ".....CONTINUING....."  2>&1 | tee -a $output.prs_analysis.log
    fi 

############################################

############################################
### Perform PRS CS 

    if [ "$prscs_WT" == "Y" ]; then 

        ############################################
        ### Extract SNP weights  

            # Unzip sumstats
                sumstats_1=$(echo $sumstats | sed 's/.gz//g')
                gunzip $sumstats
            # >>> 

            # Log start  
                printf "\nStarting procedures for PRS CS analysis...$(date)\n\n" 2>&1 | tee -a $output.prs_analysis.log

            # Check parameters
                if [ -z "$prscs_env" ]; then echo "PRSCS environment not specified - aborting"; exit 1; else echo "--prscs_env = $prscs_env"; fi 2>&1 | tee -a $output.prs_analysis.log
                if [ -z "$path2prscs" ]; then echo "Path to PRSCS not specified - aborting"; exit 1; else echo "--path2prscs = $path2prscs"; fi 2>&1 | tee -a $output.prs_analysis.log
                if [ -z "$path2prscsref" ]; then echo "Path to PRSCS reference not specified - aborting"; exit 1; else echo "--path2prscsref = $path2prscsref"; fi 2>&1 | tee -a $output.prs_analysis.log
                if [ -z "$path2bim" ]; then echo "Path to bim not specified - setting default directory"; path2bim=$(pwd); echo "--path2bim = $path2bim"; fi 2>&1 | tee -a $output.prs_analysis.log
                if [ -z "$path2sumstats" ]; then echo "Path to sumstats not specified - setting defaul directory"; path2sumstats=$(pwd); echo "--path2sumstats = $path2sumstats"; fi 2>&1 | tee -a $output.prs_analysis.log
                if [ -z "$path2output" ]; then echo "Path to output not specified - setting default directory"; path2output=$(pwd); echo "--path2output = $path2output"; fi 2>&1 | tee -a $output.prs_analysis.log
                if [ -z "$phi" ]; then echo "Phi value not specified - setting default parameter 1e-2"; phi=1e-2; echo "--phi=$phi"; fi 2>&1 | tee -a $output.prs_analysis.log
            
                    path2bim=${path2bim:="$(pwd)"}
                    path2sumstats=${path2sumstats:="$(pwd)"}
                    path2output=${path2output:="$(pwd)"}
                    phi=${phi:="1e-2"}
            # >>> 

            # generate prscs weights 
                # write scripts     
                    for i in $(seq 22)
                        do echo "$prscs_env/python $path2prscs/PRScs.py --ref_dir=$path2prscsref/ --bim_prefix=$path2bim/$target --sst_file=$path2sumstats/$sumstats_1 --n_gwas=$n_gwas --chrom="$i" --phi=$phi --out_dir=$path2output/$output" > $output.prscs.weight.calc.script.chr"$i".sh
                    done 
                # >>> 

                # interactive mode 

                    if [ "$qsub" == "N" ]; then 

                        # setup xargs and run scripts 
                            process=$(lscpu | sed -n '4,4p' | awk '{print $2}')
                            ls -tr *prscs.weight.calc.script*.sh | xargs -P $process -n 1 bash
                        # >>> 
                    elif [ "$qsub" == "S" ]; then 
                        # Run script serially 

                            ls -tr *prscs.weight.calc.script*.sh | xargs -P 1 -n 1 bash
                        # submit to HPC

                    elif [ "$qsub" == "Y" ]; then 
                        for i in $(seq 22)
                            do qsub -cwd -N prscs.wt.job."$i" -l h_vmem=8G -l h_rt=24:00:00 $output.prscs.weight.calc.script.chr"$i".sh
                        done

                        printf "\nPRS-CS scripts for computing weights for allelic scoring submitted to HPC - $(date)\n" 2>&1 | tee -a $output.prs_analysis.log
                        printf "\nThe PRS wrapper script would exit momentarily to allow for the HPC job to complete\n\n" 2>&1 | tee -a $output.prs_analysis.log
                        printf "\nWhen the HPC jobs are completed - allelic scoring can be carried out using the --prscs_ASC=Y flag" 2>&1 | tee -a $output.prs_analysis.log
                    fi 
                
                # >>> 
        ############################################

    fi

    if [ "$prscs_ASC" == "Y" ]; then 
        
        ############################################
        ### Allelic Scoring for PRSCS 
            
            # Consolidate weights 
                printf "" > $output.prscs.snp.weights.txt
                for i in $(seq 22)
                    do cat "$output"_pst_eff*chr"$i"*txt 
                done | sort -u -t \t -k1 | sort -k 1 -n -k 3 -n  >> $output.prscs.snp.weights.txt
            # >>> 

            # allelic scoring 
                $path2plink/plink --bfile $target --score $output.prscs.snp.weights.txt 2 4 6 --out $output.prscs.scoring
            # >>>

            # extract prs scores 
                cat $output.prscs.scoring.profile | awk '{print $1,$3,$4,$6}' | sed '1,1d' | sed '1 i\FID PHENO CNT_prscs SCORE_prscs' > $output.prscs.file.txt
            # >>> 
        ############################################

        ############################################
        ### Move files to folder

            if [ -f $output.prscs.file.txt ]; then 
                printf "\nPRSCS  allelic scoring is complete\041\041...$(date)\n" 2>&1 | tee -a $output.prs_analysis.log
            
                mkdir $output.prscs
                mv *prscs* $output.prscs
                mv *pst_eff* $output.prscs
                gzip $sumstats_1

            else
                printf "\nCan't find allele score file - please check that the file format and options were indicated right\n\n...Aborting...." 2>&1 | tee -a $output.prs_analysis.log

            fi 
        ############################################
    fi


############################################

############################################
### Perform PRCSx

    if [ "$prscsx_WT" == "Y" ]; then 

        ############################################
        ### Extract SNP Weights

            # Unzip sumstats
                if [ ! -f "$sumstats_pop1" ]; then 
                    echo "Can't find pop1 sumstats file - Aborting"
                    exit 1 
                fi             

                if [ ! -f "$sumstats_pop2" ]; then 
                    echo "Can't find pop2 sumstats file - Aborting"
                    exit 1 
                fi 

                sumstats_1=$(echo $sumstats_pop1 | sed 's/.gz//g')
                sumstats_2=$(echo $sumstats_pop2 | sed 's/.gz//g')
                gunzip $sumstats_pop1
                gunzip $sumstats_pop2

            # >>> 

            # Log start  
                printf "\n-----------------------------------------------------------------\n" 2>&1 | tee -a $output.prs_analysis.log
                printf "\nStarting procedures for PRS CSx analysis...$(date)\n\n" 2>&1 | tee -a $output.prs_analysis.log
                printf "\nTwo sets of summary statistics are used for PRS CS x analysis\n\n" 2>&1 | tee -a $output.prs_analysis.log
                printf "\n --sumstats_pop1 = $sumstats_pop1\n --sumstats_pop2 = $sumstats_pop2\n" 2>&1 | tee -a $output.prs_analysis.log
                printf "\n --n_gwas_pop1 = $n_gwas_pop1\n --n_gwas_pop2 = $n_gwas_pop2\n" 2>&1 | tee -a $output.prs_analysis.log
                printf "\n --pop1 = $pop1\n --pop2 = $pop2\n" 2>&1 | tee -a $output.prs_analysis.log

                if [[ -z "$n_gwas_pop1" || -z "$n_gwas_pop2" || -z "$pop1" || -z "$pop2" ]]; then 
                    echo "Please check the parameters very carefully - one of the population parameters was not entered properly"
                    echo "Aborting...."
                fi 
            # >>> 

            # Check parameters
                if [ -z "$prscs_env" ]; then echo "PRSCS environment not specified - aborting"; exit 1; else echo "--prscs_env = $prscs_env"; fi 2>&1 | tee -a $output.prs_analysis.log
                if [ -z "$path2prscsx" ]; then echo "Path to PRSCSx not specified - aborting"; exit 1; else echo "--path2prscsx = $path2prscsx"; fi 2>&1 | tee -a $output.prs_analysis.log
                if [ -z "$path2prscsref" ]; then echo "Path to PRSCS reference not specified - aborting"; exit 1; else echo "--path2prscsref = $path2prscsref"; fi 2>&1 | tee -a $output.prs_analysis.log
                if [ -z "$path2bim" ]; then echo "Path to bim not specified - setting default directory"; path2bim=$(pwd); echo "--path2bim = $path2bim"; fi 2>&1 | tee -a $output.prs_analysis.log
                if [ -z "$path2sumstats" ]; then echo "Path to sumstats not specified - setting defaul directory"; path2sumstats=$(pwd); echo "--path2sumstats = $path2sumstats"; fi 2>&1 | tee -a $output.prs_analysis.log
                if [ -z "$path2output" ]; then echo "Path to output not specified - setting default directory"; path2output=$(pwd); echo "--path2output = $path2output"; fi 2>&1 | tee -a $output.prs_analysis.log
                if [ -z "$phi" ]; then echo "Phi value not specified - setting default parameter 1e-2"; phi=1e-2; echo "--phi=$phi"; fi 2>&1 | tee -a $output.prs_analysis.log                
                printf "\n-----------------------------------------------------------------\n" 2>&1 | tee -a $output.prs_analysis.log
                    path2bim=${path2bim:="$(pwd)"}
                    path2sumstats=${path2sumstats:="$(pwd)"}
                    path2output=${path2output:="$(pwd)"}
                    phi=${phi:="1e-2"}
            # >>> 

            # generate prs csx weights
                for i in $(seq 22)
                    do echo "$prscs_env/python $path2prscsx/PRScsx.py --ref_dir=$path2prscsref --bim_prefix=$path2bim/$target --sst_file=$path2bim/$sumstats_1,$path2bim/$sumstats_2 --n_gwas=$n_gwas_pop1,$n_gwas_pop2 --pop=$pop1,$pop2  --chrom="$i" --phi=$phi --out_dir=$path2output --meta=True --out_name=$output" > $output.prscsx.weight.calc.script.chr"$i".sh
                done

            # >>>

            # interactive mode 

                if [ "$qsub" == "N" ]; then 

                    # setup xargs and run scripts 
                        process=$(lscpu | sed -n '4,4p' | awk '{print $2}')
                        ls -tr *prscs.weight.calc.script*.sh | xargs -P $process -n 1 bash
                    # >>> 
                elif [ "$qsub" == "S" ]; then 
                    # Run script serially 

                        ls -tr *prscs.weight.calc.script*.sh | xargs -P 1 -n 1 bash
                    # submit to HPC

                elif [ "$qsub" == "Y" ]; then 
                    for i in $(seq 22)
                        do qsub -cwd -N prscsx.wt.job."$i" -l h_vmem=8G -l h_rt=24:00:00 $output.prscsx.weight.calc.script.chr"$i".sh
                    done

                    printf "\nPRS-CSx scripts for computing weights for allelic scoring submitted to HPC - $(date)\n" 2>&1 | tee -a $output.prs_analysis.log
                    printf "\nThe PRS wrapper script would exit momentarily to allow for the HPC job to complete\n\n" 2>&1 | tee -a $output.prs_analysis.log
                    printf "\nWhen the HPC jobs are completed - allelic scoring can be carried out using the --prscs_ASC=Y flag" 2>&1 | tee -a $output.prs_analysis.log
                fi 
            
            # >>> 
        ############################################   
    
    fi

    if [ "$prscsx_ASC" == "Y" ]; then 
    
        ############################################
        ### Allelic Scoring for PRSCS 
            
            # Consolidate weights 
                printf "" > $output.prscsx.$pop1.snp.weights.txt
                for i in $(seq 22)
                    do cat "$output"_"$pop1"_pst_eff*chr"$i"*txt 
                done | sort -u -t \t -k1 | sort -k 1 -n -k 3 -n  >> $output.prscsx.$pop1.snp.weights.txt

                printf "" > $output.prscsx.$pop2.snp.weights.txt
                for i in $(seq 22)
                    do cat "$output"_"$pop2"_pst_eff*chr"$i"*txt 
                done | sort -u -t \t -k1 | sort -k 1 -n -k 3 -n  >> $output.prscsx.$pop2.snp.weights.txt

                printf "" > $output.prscsx.meta.snp.weights.txt
                for i in $(seq 22)
                    do cat "$output"_META_pst_eff*chr"$i"*txt 
                done | sort -u -t \t -k1 | sort -k 1 -n -k 3 -n  >> $output.prscsx.meta.snp.weights.txt
            # >>> 

            # allelic scoring 
                $path2plink/plink --bfile $target --score $output.prscsx.$pop1.snp.weights.txt 2 4 6 --out $output.prscsx.$pop1.scoring
                $path2plink/plink --bfile $target --score $output.prscsx.$pop2.snp.weights.txt 2 4 6 --out $output.prscsx.$pop2.scoring
                $path2plink/plink --bfile $target --score $output.prscsx.meta.snp.weights.txt 2 4 6 --out $output.prscsx.meta.scoring                
            # >>>

            # extract prs scores 
                cat $output.prscsx.$pop1.scoring.profile | awk '{print $1,$3,$4,$6}' | sed '1,1d' | sed "1 i\FID PHENO CNT_prscsx_"$pop1" SCORE_prscsx_"$pop1"" > $output.prscsx.$pop1.file.txt
                cat $output.prscsx.$pop2.scoring.profile | awk '{print $1,$4,$6}' | sed '1,1d' | sed "1 i\FID CNT_prscsx_"$pop2" SCORE_prscsx_"$pop2"" > $output.prscsx.$pop2.file.txt
                cat $output.prscsx.meta.scoring.profile | awk '{print $1,$4,$6}' | sed '1,1d' | sed "1 i\FID _prscsx_meta SCORE_prscsx_meta" > $output.prscsx.meta.file.txt

                prscsxscorefiles=$(echo "$output.prscsx.$pop1.file.txt $output.prscsx.$pop2.file.txt $output.prscsx.meta.file.txt")

                paste -d ' ' $prscsxscorefiles | awk '{print $1, $2, $4, $6}' > $output.prscsx.file.txt
            # >>> 
        ############################################

        ############################################
        ### Move files to folder

            if [ -f $output.prscsx.file.txt ]; then 
                printf "\nPRSCSx  allelic scoring is complete\041\041...$(date)\n" 2>&1 | tee -a $output.prs_analysis.log
            
                mkdir $output.prscsx
                mv *prscsx* $output.prscsx
                mv *pst_eff* $output.prscsx
                gzip $sumstats_1
                gzip $sumstats_2

            else
                printf "\nCan't find allele score file - please check that the file format and options were indicated right\n\n...Aborting...." 2>&1 | tee -a $output.prs_analysis.log

            fi 
        ############################################
    
    fi

############################################

############################################
### Perform PRS PT

    if [ "$prspt" == "Y" ]; then 

        ############################################
        ### Clump files for PT PRS 

            # This module of the wrapper would carry out sumstats clumping for PT PRS 
                
                
                # Log start 
                    printf "\nStarting Clumping procedures for PRS PT analysis...$(date)\n\n" 2>&1 | tee -a $output.prs_analysis.log
                # >>> 

                # Check sumstats 
                    
                    printf "\nHeaders for summary statistics as follows....\n" 2>&1 | tee -a $output.prs_analysis.log
                        zcat $sumstats | head -11 2>&1 | tee -a $output.prs_analysis.log
                    echo ""
                    
                    sumstatsrows=$(zcat $sumstats | awk '{if(NF == 5) print $0}' | wc | awk '{print $1}')

                    if [ "$sumstatsrows" -lt 1000 ]; then 

                        printf "\nError Detected $(date)\nThere is something wrong with the Summary Statistics that were provided\nThere are less than 1000 rows of the summary statistics that fit 5 fields required for PRS\n\nPlease make sure that the summary statistics have the following columns\nSNP - A1 - A2 - Z - Pvalue\nAborting....\n\n" 2>&1 | tee -a $output.prs_analysis.log

                        exit 1 
                    else 

                        printf "\nSumstats checks complete\041....Proceeding to clump procedures\n" 2>&1 | tee -a $output.prs_analysis.log
                    fi 
                # >>> 


                # Clump sumstats 

                    sumstats_1=$(echo $sumstats | sed 's/.gz//g')
                    gunzip $sumstats

                    # Plink Clumping

                        # set default parameters

                            printf "\nClumping parameters =\n"
                            if [ -z "$clump_p1" ]; then echo "Primary clumping P not specified - setting default"; clump_p1=${clump_p1:="1"}; echo "--clump_p1 = $clump_p1"; else echo "--clump_p1 = $clump_p1"; fi 2>&1 | tee -a $output.prs_analysis.log
                            if [ -z "$clump_p2" ]; then echo "Secondary clumping P not specified - setting default"; clump_p2=${clump_p2:="1"}; echo "--clump-p2 = $clump_p2"; else echo "--clump-p2 = $clump_p2"; fi 2>&1 | tee -a $output.prs_analysis.log
                            if [ -z "$clump_kb" ]; then echo "Clump window not specified - setting default"; clump_kb=${clump_kb:="500"}; echo "--clump_kb = $clump_kb"; else echo "--clump_kb = $clump_kb"; fi 2>&1 | tee -a $output.prs_analysis.log
                            if [ -z "$clump_r2" ]; then echo "Clump r2 not specified - setting default"; clump_r2=${clump_r2:="0.1"}; echo "--clump_r2 = $clump_r2"; else echo "--clump_kb = $clump_kb"; fi 2>&1 | tee -a $output.prs_analysis.log
                                clump_p1=${clump_p1:="1"}
                                clump_p2=${clump_p2:="1"}
                                clump_kb=${clump_kb:="500"}
                                clump_r2=${clump_r2:="0.1"}
                        # >>> 

                        # plink clump command 
                
                            $path2plink/plink --bfile $target --clump-p1 $clump_p1 --clump-p2 $clump_p2 --clump-r2 $clump_r2 --clump-kb $clump_kb --clump $sumstats_1 --clump-snp-field SNP --clump-field P --out $output

                        # >>> 

                        # create xmhc file 
                            
                            # extract all chr except chr6
                                cat $output.clumped | awk '{if($1 != 6) print $3, $1, $4, $5}' > $output.xmhc.clumped
                            # >>> 

                            # extract chr6 no mhc
                                cat $output.clumped | awk '{if($1 == 6 && ($4 < 25000000 || $4 > 35000000)) print $3, $1, $4, $5}' >> $output.xmhc.clumped

                            # sort clumped by chr and bp 
                                cat $output.xmhc.clumped | sort -k 2 -n -k 3 -n | sed '1,2d' > $output.xmhc.clumped.sort
                            # >>> 

                            # merge with sumstats 
                                ./merge.files.sh --FILE1=$output.xmhc.clumped.sort --FILE2=$sumstats_1 --KEY=SNP --OUTMERGE=$output.xmhc.clumped.sort.combined
                                gzip $sumstats_1

                                if [ ! -f $output.xmhc.clumped.sort.combined ]; then 
                                    echo "WARNING! Can't find  $output.xmhc.clumped.sort.combined - It's highly possible that the merge script did not work" 2>&1 | tee -a $output.prs_analysis.log
                                fi 
                            # >>>     
                        # >>> 
                    #>>>
                # >>>
            # >>>  
        ############################################

        ############################################
        ### File scoring for PRS PT 

            # Create q-range file 
                # 1E-8,1E-7,1E-6,1E-5,3E-5,1E-4,3E-4,1E-3,3E-3,0.01,0.03,0.1,0.3,1.0 

                if [ ! -f "$range_file" ]; then
                    echo "1e-8 0 1e-8" > $output.range_list
                    echo "1e-7 0 1e-7" >> $output.range_list
                    echo "1e-6 0 1e-6" >> $output.range_list
                    echo "1e-5 0 1e-5" >> $output.range_list
                    echo "5e-5 0 5e-5" >> $output.range_list
                    echo "1e-4 0 1e-4" >> $output.range_list
                    echo "5e-4 0 5e-4" >> $output.range_list
                    echo "1e-3 0 1e-3" >> $output.range_list
                    echo "5e-3 0 5e-3" >> $output.range_list
                    echo "0.01 0 0.01" >> $output.range_list
                    echo "0.05 0 0.05" >> $output.range_list
                    echo "0.1 0 0.1" >> $output.range_list
                    echo "0.2 0 0.2" >> $output.range_list
                    echo "0.3 0 0.3" >> $output.range_list
                    echo "0.4 0 0.4" >> $output.range_list
                    echo "0.5 0 0.5" >> $output.range_list
                    echo "1 0 1" >> $output.range_list
                
                elif [ -f "$range_file" ]; then 

                    cat $range_file > $output.range_list
                fi  
                    
            # >>>

            # Create additional files for extracting allelic scores

                # Create SNP - Pvalue file 
                
                    cat $output.xmhc.clumped.sort.combined | awk '{print $1, $8}' | sed '1,1d' | sed '1 i\SNP P' > $output.pvalue
                # >>>
            # >>>
                

            # plink allelic scoring procedure

                $path2plink/plink --bfile $target --score $output.xmhc.clumped.sort.combined 1 5 7 header --q-score-range $output.range_list $output.pvalue --out $output.scoring
                
                # addlog
                    cat $output.scoring.log >> $output.prs_analysis.log
                # >>> 
            # >>>

            # merge PT scoring files 

                # Create list of .profile files 
                    ls -tr $output*.profile > $output.profile.list
                # >>> 

                # Create ID.txt file 
                    ptfileone=$(cat $output.profile.list | sed -n '1,1p')

                    cat $ptfileone | awk '{print $1, $3}' > $output.ID.txt
                # >>>

                # Create score.txt files 
                    while read prsfile 
                        do cat $prsfile | awk '{print $4, $6}' > $prsfile.prs.score.txt
                    done < $output.profile.list
                # >>> 

                # Create score.list 
                    prsscorelist=$(ls -tr *.prs.score.txt | tr '\n' ' ')
                    prsheader=$(cat -n $output.range_list | awk '{print "CNT_"$1, "SCORE_"$1}' | tr '\n' ' ')
                # >>>

                # prsfile with FID
                    echo "FID PHENO $prsheader" > $output.prs.file.txt
                    paste -d ' ' $output.ID.txt $prsscorelist | sed '1,1d' >> $output.prs.file.txt
                # >>> 
            # >>>

        ############################################

        ############################################
        ### Move files to folder

            if [ -f $output.prs.file.txt ]; then 
                printf "\nPRS-PT  allelic scoring is complete\041\041...$(date)\n" 2>&1 | tee -a $output.prs_analysis.log
            
                mkdir $output.prspt
                mv *profile* $output.prspt
                mv $output.nosex $output.prspt
                mv $output.clumped $output.prspt
                mv $output.log $output.prspt
                mv $output.xmhc.clumped $output.prspt
                mv $output.xmhc.clumped.sort $output.prspt
                mv $output.xmhc.clumped.sort.combined $output.prspt
                mv $output.range_list $output.prspt
                mv $output.pvalue $output.prspt
                mv $output.scoring.nosex $output.prspt
                mv $output.scoring.log $output.prspt
                mv $output.ID.txt $output.prspt
                mv $output.prs.file.txt $output.prspt



            else
                printf "\nCan't find allele score file - please check that the file format and options were indicated right\n\n...Aborting...." 2>&1 | tee -a $output.prs_analysis.log

            fi 
        ############################################

    fi 
############################################

############################################
### PRS modelling 
    if [ "$prsmodelling" == "Y" ]; then 
        # Logger  

            printf "\nStarting Procedures for PRS modelling....$(date)\n\n" 2>&1 | tee -a $output.prs_analysis.log

        # >>>

        # file checks 

            if [ ! -f "$prsfile" ]; then 
                echo "Can't find prs file - plese check if you are in the right directory!"
                echo "Aborting now..."
                exit 1
            fi 

            if [ ! -f "$pcafile" ]; then 
                echo "Can't fine pca file - please check that the pca file is copied into the prs directory"
                echo "Also, we are highly encouraging users to run their genotype data through the RICOPILI pipeline for QC and PCA procedures"
                echo "Aborting..."
                exit 1 
            fi

            if [ -z "$coco" ]; then 
                echo "Covariates not specified for PRS modelling"
                echo "Please specify covariates using the --coco=C1,C2,C3,...."
                echo "Using comma delimited list with no whitespaces" 
                echo "Aborting...."
                exit 1
            else 
                echo "Defining covariates for PRS modelling --coco = $coco" 2>&1 | tee -a $output.prs_analysis.log
            fi

            if [ -z "$prs_predictors" ]; then 
                echo "PRS predictors are not specified"
                echo "Please specify PRS predictors useing --prs_predictors=predictor1,predictor2...."
                echo "Using comma delimited list with no whitespace.."
                echo "Aborting..."
                exit 1 
            else 
                echo "Defining PRS predictors for PRS modelling --prs_predictors = $prs_predictors" 2>&1 | tee -a $output.prs_analysis.log
            fi

            if [ -z "$trait" ]; then 
                echo "Trait not defined...Please definee if the trait investigated is Binary or Quantitative"
                echo "Aborting..."
                exit 1
            else 

                echo "Indicated trait is $trait" 2>&1 | tee -a $output.prs_analysis.log

            fi

            if [ "$trait" == "Binary" ]; then 
                if [ -z "$prev" ]; then 
                    echo "Trait is indicated as Binary - Prevalence not indicated"
                    echo "We will need the prevalence of the Binary trait to calculate liability parameters"
                    echo "Aborting..."
                    exit 1 

                else 
                    echo "Prevalence of trait is $prev" 2>&1 | tee -a $output.prs_analysis.log
                fi 
            fi

        # >>>  

        # Generate R code for modelling 

            # Load modules

                echo "
                # Load modules
                library(\"tidyverse\")
                library(\"data.table\")
                library(\"pROC\")
                " > prs_modelling.r 

            # >>> 
            
            # Define linear'logistic model functions

                echo "
                # Define functions
                rsq_lcc <- function(R2O, data, K) {
                    caco_n <- data\$PHENO
                    ncase = length(caco_n[which(caco_n==1)])
                    ncont = length(caco_n[which(caco_n==0)])
                    nt  = ncase + ncont  
                    P   = ncase/nt 
                    thd = -qnorm(K,0,1) 
                    zv  = dnorm(thd) 
                    mv = zv/K
                    theta = mv*(P-K)/(1-K)*(mv*(P-K)/(1-K)-thd) # theta in equation (15)
                    cv = K*(1-K)/zv^2*K*(1-K)/(P*(1-P))
                    R2  = R2O*cv/(1+R2O*theta*cv)
                    return(R2)
                }

                nagelkerke <- function(full,null,n){
                    # r2 <- (1-exp((logLik(null)-logLik(full))[1])^(2/n))/(1-exp(logLik(null)[1])^(2/n))
                    r2 <- (1-exp(2*(logLik(null)-logLik(full))[1]/n))/(1-(exp(2*logLik(null)[1]/n)))
                    chisq <- -2*(logLik(null)-logLik(full))
                    pval  <- pchisq(chisq, (null\$df.residual-full\$df.residual), lower.tail=FALSE)
                    return(c(r2,chisq,pval))
                } " >> prs_modelling.r
            # >>>

            # Load data 

                if [ "$trait" == "Binary" ]; then 
                    echo "
                    # Load prs data 
                        prsfile <- fread(\"$prsfile\",na.strings=\"-9\")
                    # Load pca file 
                        pcafile <- fread(\"$pcafile\")
                    # merge prs pca files
                        prsdat <- left_join(prsfile, pcafile, by=\"FID\")
                    # change PHENO 1/2 to 0/1
                        prsdat\$PHENO <- prsdat\$PHENO-1
                    # output prsdat
                        fwrite(prsdat, file=\"prsdatinput.txt\", quote=FALSE, sep=\"\t\", na=\"NA\")
                    # coerce to data frame
                        data<-as.data.frame(prsdat)
                    " >> prs_modelling.r
                elif [ "$trait" == "Quantitative" ]; then 
                    echo "
                    # Load prs data 
                        prsfile <- fread(\"$prsfile\",na.strings=\"-9\")
                    # Load pca file 
                        pcafile <- fread(\"$pcafile\")
                    # merge prs pca files
                        prsdat <- left_join(prsfile, pcafile, by=\"FID\")
                    # output prsdat
                        fwrite(prsdat, file=\"prsdatinput.txt\", quote=FALSE, sep=\"\t\", na=\"NA\")
                    # coerce to data frame
                        data<-as.data.frame(prsdat)
                    " >> prs_modelling.r

                fi

            # >>> 

            # Perform PRS modelling 

                covariates=$(echo $coco | sed 's/,/\ +\ /g')
                npredictors=$(echo $prs_predictors | tr ',' '\n' | wc | awk '{print $1}')

                #for i in $(seq $npredictors); do declare predictor_"$i"=$(echo $prs_predictors | tr ',' '\n' | awk -v line=$i '{if(NR==line) print $0}'); done

                for i in $(seq $npredictors)
                    do echo "$i"
                done > npredictor.list

                echo $prs_predictors | tr ',' '\n' > prspredictor.list

                if [ "$trait" == "Binary" ]; then 

                    
                    echo "
                    # PRS modelling for binary trait

                        # define sample size
                            caco_n <- prsdat\$PHENO
                            ncase = length(caco_n[which(caco_n==1)])
                            ncont = length(caco_n[which(caco_n==0)])
                            caco_n  = ncase + ncont  
                    " >> prs_modelling.r

                    while read -u 3 -r i && read -u 4 -r j    
                        do 
                            echo "
                                Null_$i<-glm(formula = \"PHENO ~ $covariates\" , family = \"binomial\", data = data)  
                                Full_$i<-glm(formula = \"PHENO ~ $j + $covariates\" , family = \"binomial\", data = data)  
                                Rsq_"$i" <- nagelkerke(Full_$i, Null_$i, caco_n)
                                LRsq_"$i" <- rsq_lcc(Rsq_"$i", data, $prev)
                            "
                    done 3< npredictor.list 4< prspredictor.list >> prs_modelling.r

                elif [ "$trait" == "Quantitative" ]; then 

                    while read -u 3 -r i && read -u 4 -r j    
                        do
                            echo "
                            # PRS modelling for Quantitative trait 
                                
                                Null_"$i"<-lm(PHENO ~ $covariates, data = data)  
                                Full_"$i"<-lm(PHENO ~ $j + $covariates, data = data)  
                                SSE.null_"$i"<-sum(Null\$residuals**2)  
                                SSE.full_"$i"<-sum(Full\$residuals**2)  
                                Rsq_"$i"<-(SSE.null_"$i"-SSE.full_"$i")/SSE.null_"$i"  
                            " 
                    done 3< npredictor.list 4< prspredictor.list >> prs_modelling.r
                fi

                # Combine results 

                    modelR=$(cat npredictor.list | awk '{print "Rsq_"$1}' | tr '\n' ',' | sed s'/.$//')

                    modelLR=$(cat npredictor.list | awk '{print "LRsq_"$1}' | tr '\n' ',' | sed s'/.$//')

                    echo "
                    # Consolidate PRS results 

                        TotalR <- rbind($modelR)

                        TotalLR <- rbind($modelLR)

                        Total <- cbind(TotalR, TotalLR)

                        Totaldata <- as.data.frame(Total)

                        Totaldata <- Totaldata %>% select(., R2 = V1, R2_liab = V4, Chisq = V2, Pval = V3)

                        fwrite(Totaldata, file=\"prsdatoutput.txt\", quote=FALSE, sep=\" \", na=\"NA\")
                    " >> prs_modelling.r

                    cat $output.range_list | awk '{print $1}' | sed '1 i\PRS_predictors' > $output.prspredictors.txt

                    paste -d ' '  $output.prspredictors.txt prsdatoutput.txt > $output.prspt.results.txt
                # >>>
            # >>>
        # >>>
    fi 
    # >>>
############################################