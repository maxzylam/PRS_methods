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
                --target)   :   Target prediction file - plink binary files
                                ^ Users are highly adviced to have QC-ed their target file via RICOPILI
                --output)   :   output prefix for PRS analysis
                
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
                    --xpop)
                            xpop=$VALUE 
                            ;;
                    --n_gwas)

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

############################################



############################################
### Perform PRS CS 

    if [ "$prscs" == "Y" ]; then 

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
            # >>> 

            # generate prscs weights 
                # write scripts     
                    for i in $(seq 22)
                        do echo "$prscs_env/python $path2prscs/PRScs.py --ref_dir=$path2prscsref/ --bim_prefix=$path2bim/$target --sst_file=$path2sumstats/$sumstats_1 --n_gwas=$n_gwas --chrom="$i" --phi=1e-2 --out_dir=$path2output/$output" > $output.prscs.weight.calc.script.chr"$i".sh
                    done 
                # >>> 

                # setup xargs and run scripts 

                    process=$(lscpu | sed -n '4,4p' | awk '{print $2/2}')

                    ls -tr *prscs.weight.calc.script*.sh | xargs -P $process -n 1 bash
                # >>> 

            
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
                            if [ -z "$clump_p1" ]; then clump_p1=1; echo "--clump_p1 = $clump_p1"; fi 2>&1 | tee -a $output.prs_analysis.log
                            if [ -z "$clump_p2" ]; then clump_p2=1; echo "--clump-p2 = $clump_p2"; fi 2>&1 | tee -a $output.prs_analysis.log
                            if [ -z "$clump_kb" ]; then clump_kb=500; echo "--clump_kb = $clump_kb"; fi 2>&1 | tee -a $output.prs_analysis.log
                            if [ -z "$clump_r2" ]; then clump_r2=0.1; echo "--clump_r2 = $clump_r2"; fi 2>&1 | tee -a $output.prs_analysis.log

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
                            # >>> 

                            # sort clumped by chr and bp 
                                cat $output.xmhc.clumped | sort -k 2 -n -k 3 -n | sed '1,2d' > $output.xmhc.clumped.sort
                            # >>> 

                            # merge with sumstats 
                                ./merge.files.sh --FILE1=$output.xmhc.clumped.sort --FILE2=$sumstats_1 --KEY=SNP --OUTMERGE=$output.xmhc.clumped.sort.combined
                                gzip $sumstats_1
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

                    cat $ptfileone | awk '{print $1}' > $output.ID.txt
                # >>>

                # Create score.txt files 
                    while read prsfile 
                        do cat $prsfile | awk '{print $6}' > $prsfile.prs.score.txt
                    done < $output.profile.list
                # >>> 

                # Create score.list 
                    prsscorelist=$(ls -tr *.prs.score.txt | tr '\n' ' ')
                    prsheader=$(cat $output.range_list | awk '{print "SCORE_"$1}' | tr '\n' ' ')
                # >>>

                # prsfile with FID
                    echo "FID $prsheader" > $output.prs.file.txt
                    paste -d ' ' $output.ID.txt $prsscorelist | sed '1,1d' >> $output.prs.file.txt
                # >>> 
            # >>>

        ############################################

        ############################################
        ### Clean up #1

            if [ -f $output.prs.file.txt ]; then 
                printf "\nPolygenic Allelic scoring is complete\041\041...$(date)" 2>&1 | tee -a $output.prs_analysis.log
            
                rm $output.pvalue
                rm $output.range_list
                rm *.nosex
                rm $output*.profile*

            else
                printf "\nCan't find allele score file - please check that the file format and options were indicated right\n\n...Aborting...." 2>&1 | tee -a $output.prs_analysis.log

            fi 
        ############################################
    fi 
############################################