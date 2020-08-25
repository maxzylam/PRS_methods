
        # Parameters
            while [ "$1" != "" ];do
                PARAM=`echo $1 | awk -F= '{print $1}'`
                VALUE=`echo $1 | awk -F= '{print $2}'`
                case $PARAM in
                        --FILE1)
                            FILE1=$VALUE
                            ;;
                        --FILE2)
                            FILE2=$VALUE
                            ;;
                        --KEY)
                            KEY=$VALUE
                            ;;
                        --OUTMERGE)
                            OUTMERGE=$VALUE
                            ;;
                        $)
                        echo "ERROR:unknown parameter \ $PARAM "
                        esac
                        shift
            done

        # substitute vars

        echo "cat file_merge | sed 's/FILE1/$FILE1/g' | sed 's/FILE2/$FILE2/g' | sed 's/KEY/$KEY/g' | sed 's/OUTMERGE/$OUTMERGE/g' > merge.R" > merge.sh

        bash merge.sh
        
        R CMD BATCH --no-save merge.R
        
        