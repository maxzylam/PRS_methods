Note: All the following script are using 1000 Genome downloaded from https://ctg.cncr.nl/software/magma as LD preference data  
_Scroll down, the download links are at the end of the page._

All the script are used for "qsub -v ...script.sh " command. I still keep the paths of my server in the scripts.
Please adjust accordingly if you run it on interactive sessions or locally.

## PRSice.pt.sh

The script uses PRSice (https://www.prsice.info/) to calculation Pruning and thresholding (PT) PRS

## PRSice.meta.sh 
Assuming you use a meta analysis data that consist of EUR and EAS GWAS data

First prepare the meta analysis discovery data. This step is not included in the script.

The script uses PRSice to calculate Pruning and thresholding (PT) PRS. Here we have 2 hyperparameters: the P-value threshold and the population of the LD reference. 

## LDpred.sh
It requires the sample size of the discovery GWAS data.

## PRScs.origin.sh
It requires the sample size of the discovery GWAS data.
It uses the original PRS-CS to calculate the PRS. 
In order to enable parallel jobs running at the same time. The analysis of each chromosome and each shrinkage parameter is done seperately. 
Please go to https://github.com/getian107/PRScs for more information

## PRScs.x.sh
It uses the PRS-CSx (will be released soon) to calculate the PRS. 

## Where to find the PRS
PRSice will print the PRS in *.all.score files  
LDpred and PRS-CS(x) will generate corrected effect size estimates. Please use plink to calculate the PRS.

## To calculate the R^2 of PRS, you can use R:
### For binary traits:  
Here is the example code to calculate Nagelkerke's R2 (C1, C2, C3 are covariates)
```
library(rcompanion)
Null<-glm(formula = PHENO ~ C1 + C2 + C3 , family = "binomial", data = DATA)  
Full<-glm(formula = PHENO ~ PRS + C1 + C2 + C3 , family = "binomial", data = DATA)  
Adj.R2<-nagelkerke(Full, null=Null)$Pseudo.R.squared.for.model.vs.null[3]  
```
### For quantitative traits:
Here is the example code to calculate partial R2:
```
Null<-lm(PHENO ~ C1 + C2 + C3, Reg)  
Full<-lm(PHENO ~ PRS + C1 + C2 + C3, Reg)  
SSE.null<-sum(Null$residuals**2)  
SSE.full<-sum(Full$residuals**2)  
R2.partial<-(SSE.null-SSE.full)/SSE.null  
```

### Liability scale conversion 
```
h2l_R2N <- function(k, r2n, p) {
  # k = population prevalence
  # r2n = Nagelkerke's attributable to genomic profile risk score
  # p = proportion of cases in the case-control sample
  # calculates proportion of variance explained on the liability scale
  # from ABC at http://www.complextraitgenomics.com/software/
  # Lee SH, Goddard ME, Wray NR, Visscher PM. (2012) A better coefficient of determination for genetic profile analysis. Genet Epidemiol. 2012 Apr;36(3):214-24.
  x <- qnorm(1 - k)
  z <- dnorm(x)
  i <- z / k
  cc <- k * (1 - k) * k * (1 - k) / (z^2 * p * (1 - p))
  theta <- i * ((p - k)/(1 - k)) * (i * ((p - k) / ( 1 - k)) - x)
  e <- 1 - p^(2 * p) * (1 - p)^(2 * (1 - p))
  h2l_R2N <- cc * e * r2n / (1 + cc * e * theta * r2n) 
}

 r2n <- my_r2$Pseudo.R.squared.for.model.vs.null[3]
 r2l <- h2l_R2N(k=0.01, r2n=r2n, p=sum(my_subset$PHENO==1)/sum(my_subset$PHENO %in% c(0,1)))
```
