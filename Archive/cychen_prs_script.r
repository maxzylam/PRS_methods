#!/sara/sw/R-3.2.1/bin/Rscript
##############################
# set up library
options(echo=TRUE)
library(pROC)
library(car)
library(heplots)
library(ggplot2)
setwd("/home/gwas/pgc_scz_asia/imp_collect/prs_score/chiayenc")

##############################
# set up funcitons
getprofile <- function(studyname,pc=TRUE,orprs=10){
# get 10 PRS
for (i in 1:10){
profile.tmp <- read.table(paste0("pgcsczasn.clumpqcr01.bg.", studyname, ".s", i, ".profile"),header=TRUE,stringsAsFactors=FALSE)
profile.tmp$FIDIID <- paste(profile.tmp$FID,profile.tmp$IID,sep=":")
profile.tmp <- profile.tmp[,c(7,6,4)]
colnames(profile.tmp) <- c("FIDIID",paste0("score.s",i),paste0("score.s",i,".CNT"))
assign(paste0("profile.s",i), profile.tmp)
}
# PRS decile 
profile.tmp <- get(paste0("profile.s",orprs))
profile.tmp$score.dec.tmp <- factor(cut(profile.tmp[,paste0("score.s", orprs)], quantile(profile.tmp[,paste0("score.s", orprs)], prob = seq(0,1,length=11)),include.lowest=TRUE))
colnames(profile.tmp)[length(profile.tmp)] <- paste0("score.s", orprs, ".dec")
assign(paste0("profile.s",orprs), profile.tmp)
# phenotype
pheno.tmp <- read.table(paste0("pgcsczasn.clumpqcr01.bg.", studyname, ".s1.profile"),header=TRUE,stringsAsFactors=FALSE)
pheno.tmp$FIDIID <- paste(pheno.tmp$FID,pheno.tmp$IID,sep=":")
pheno.tmp <- pheno.tmp[,c(7,3)]
# PC
if (pc==TRUE){
pc.tmp <- read.table(paste0("/home/chiayenc/pgc_scz_asia_prs/pgcsczasn_meta/pgcsczasn.",studyname,".pc"), header=TRUE, stringsAsFactors=FALSE)
pc.tmp$FIDIID <- paste(pc.tmp$FID,pc.tmp$IID,sep=":")
pc.tmp <- pc.tmp[,c("FIDIID",paste0("C",seq(1,10,1)))]
# merge data
profile.all <- Reduce(function(x, y) merge(x, y, all=FALSE, by="FIDIID"), list(pheno.tmp,pc.tmp,profile.s1,profile.s2,profile.s3,profile.s4,profile.s5,profile.s6,profile.s7,profile.s8,profile.s9,profile.s10))
    }else{
profile.all <- Reduce(function(x, y) merge(x, y, all=FALSE, by="FIDIID"), list(pheno.tmp,profile.s1,profile.s2,profile.s3,profile.s4,profile.s5,profile.s6,profile.s7,profile.s8,profile.s9,profile.s10))
    }
profile.all$PHENO <- profile.all$PHENO-1
return(profile.all)
}

rsq_lcc <- function(R2O, data, K) {
    caco_n <- data$PHENO
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
    r2 <- (1-exp(2*(logLik(model0)-logLik(model1))[1]/n))/(1-(exp(2*logLik(model0)[1]/n)))
    chisq <- -2*(logLik(null)-logLik(full))
    pval  <- pchisq(chisq, (null$df.residual-full$df.residual), lower.tail=FALSE)
    return(c(r2,chisq,pval))
} 

##############################
# PRS R2 & OR decile
# Normal case-control
studyname = c("bix1", "bix2", "bix3", "cno1", "hnk1", "imh1", "imh2", "jpn1", "umc1", "uwa1", "xju1")
orprs=10
for (k in 1:length(studyname)){
profile <- getprofile(studyname[k],orprs=orprs)
n <- length(profile[,1])
# PRS prediction R2
nagelkerke.output <- c()
for (i in 1:10){
full <- glm(paste0("PHENO~score.s", i, " + ",paste(paste0("C",seq(1,10,1)),collapse=" + ")), family=binomial, data=profile)
null <- glm(paste0("PHENO~ ",paste(paste0("C",seq(1,10,1)),collapse=" + ")), family=binomial, data=profile)
nagelkerke.output <- rbind(nagelkerke.output, c(paste0("s",i), min(profile[,paste0("score.s", i, ".CNT")]), nagelkerke(full,null,n)))
}
write.table(nagelkerke.output, file = paste0("/home/gwas/pgc_scz_asia/imp_collect/prs_score/chiayenc/nagelkerke.output.",studyname[k],'.txt'), append = FALSE, quote = FALSE, sep = " ", eol = "\n", na = "NA", dec = ".", row.names = FALSE, col.names = FALSE)    
# PRS decile OR
OR.dec.glm <- glm(paste0("PHENO~score.s", orprs, ".dec"), family=binomial, data=profile)
writeLines(paste(sprintf("%s", studyname[k]), sprintf("%s", paste0("score.s", orprs, ".dec")), sprintf("%.3f", summary(OR.dec.glm)$coefficients[10,1]), sprintf("%.3f", summary(OR.dec.glm)$coefficients[10,2]), sprintf("%.3f", summary(OR.dec.glm)$coefficients[10,3]), sprintf("%.50f", pnorm(summary(OR.dec.glm)$coefficients[10,3], lower.tail=FALSE)*2), sep=","))

# print sample size
writeLines(paste(sprintf("%s", studyname[k]), sprintf("%i", length(profile[,1])), sprintf("%i", length(profile[which(profile[,"PHENO"]==1),"PHENO"])), sprintf("%i", length(profile[which(profile[,"PHENO"]==0),"PHENO"])), sep=","))
}

# Pseudo case-control
studyname = c("tai1", "tai2")
orprs=10
for (k in 1:length(studyname)){
profile <- getprofile(studyname[k],pc=FALSE,orprs=orprs)
n <- length(profile[,1])
# PRS prediction R2
nagelkerke.output <- c()
for (i in 1:10){
full <- glm(paste0("PHENO~score.s", i), family=binomial, data=profile)
null <- glm(paste0("PHENO~1"), family=binomial, data=profile)
nagelkerke.output <- rbind(nagelkerke.output, c(paste0("s",i), min(profile[,paste0("score.s", i, ".CNT")]), nagelkerke(full,null,n)))
}
write.table(nagelkerke.output, file = paste0("/home/gwas/pgc_scz_asia/imp_collect/prs_score/chiayenc/nagelkerke.output.",studyname[k],'.txt'), append = FALSE, quote = FALSE, sep = " ", eol = "\n", na = "NA", dec = ".", row.names = FALSE, col.names = FALSE)    
# PRS decile OR and sample size
OR.dec.glm <- glm(paste0("PHENO~score.s", orprs, ".dec"), family=binomial, data=profile)
writeLines(paste(sprintf("%s", studyname[k]), sprintf("%i", length(profile[,1])), sprintf("%i", length(profile[which(profile[,"PHENO"]==1),"PHENO"])), sprintf("%i", length(profile[which(profile[,"PHENO"]==0),"PHENO"])), sprintf("%s", paste0("score.s", orprs, ".dec")), sprintf("%.3f", exp(summary(OR.dec.glm)$coefficients[10,1])), sprintf("%.3f", summary(OR.dec.glm)$coefficients[10,2]), sprintf("%.50f", pnorm(summary(OR.dec.glm)$coefficients[10,3], lower.tail=FALSE)*2), sep=","))
}

##############################
# summarize PRS R2
outputname = c("bix1", "bix2", "bix3", "cno1", "hnk1", "imh1", "imh2", "jpn1", "umc1", "uwa1", "xju1", "tai1", "tai2")

nagelkerke.all.output <- read.table(paste0("nagelkerke.output.", outputname[1], ".txt"),header=FALSE,stringsAsFactors=FALSE)
nagelkerke.all.output <- nagelkerke.all.output[,2:5]
colnames(nagelkerke.all.output) <- paste(outputname[1], c("CNT","r2","chisq","pval"),sep=".")

for (i in 2:length(outputname)){
    profile.tmp <- read.table(paste0("nagelkerke.output.", outputname[i], ".txt"),header=FALSE,stringsAsFactors=FALSE)
    profile.tmp <- profile.tmp[,2:5]
    colnames(profile.tmp) <- paste(outputname[i], c("CNT","r2","chisq","pval"),sep=".")
    nagelkerke.all.output <- cbind.data.frame(nagelkerke.all.output, profile.tmp)
}

write.table(nagelkerke.all.output, file = "nagelkerke.output.all.txt", append = FALSE, quote = FALSE, sep = " ", eol = "\n", na = "NA", dec = ".", row.names = TRUE, col.names = TRUE)

##############################
# make OR plot
studyname = "umc1"
orprs=10
profile <- getprofile(studyname,orprs=orprs)
n <- length(profile[,1])
# PRS decile OR
OR.dec.glm <- glm(paste0("PHENO~score.s", orprs, ".dec + ",paste(paste0("C",seq(1,10,1)),collapse=" + ")), family=binomial, data=profile)
OR.dec.plot <- as.data.frame(summary(OR.dec.glm)$coefficients[c(2:10),c(1:2)])
OR.dec.plot <- rbind(c(0,0),OR.dec.plot)
colnames(OR.dec.plot) <- c("logOR", "SE_OR")
OR.dec.plot$OR <- exp(OR.dec.plot$logOR) 
OR.dec.plot$Decile <- factor(seq(1,10,1))
OR.dec.plot$CI_OR_upper <- exp(OR.dec.plot$logOR+OR.dec.plot$SE_OR*1.96)
OR.dec.plot$CI_OR_lower <- exp(OR.dec.plot$logOR-OR.dec.plot$SE_OR*1.96)

pd <- position_dodge(0.1)
OR.dec.plot.output <- ggplot(OR.dec.plot, aes(x=Decile, y=OR)) + geom_errorbar(aes(ymin=CI_OR_lower, ymax=CI_OR_upper), width=.1, position=pd)+geom_point(position=pd) + scale_x_discrete("Decile") + scale_y_continuous(name="Odds ratio", limits=c(0, 15), breaks=c(1,2,3,4,5,5,6,7,8,9,10,11,12,13,14,15))

ggsave("OR.dec.plot.output.pdf",OR.dec.plot.output)

#####################################################
# TEST CODE
# full <- glm(paste0("PHENO~score.s1 + ",paste(paste0("C",seq(1,10,1)),collapse=" + ")), family=binomial, data=profile)
# null <- glm(paste0("PHENO~ ",paste(paste0("C",seq(1,10,1)),collapse=" + ")), family=binomial, data=profile)
# nagelkerke(full,null,n)
# nagelkerke.output
# full.lm <- lm(paste0("PHENO~score.s1 + ",paste(paste0("C",seq(1,10,1)),collapse=" + ")), data=profile)
# null.lm <- lm(paste0("PHENO~ ",paste(paste0("C",seq(1,10,1)),collapse=" + ")), data=profile)
# partial.r2.lm <- (sum(null.lm$residuals^2) - sum(full.lm$residuals^2))/sum(null.lm$residuals^2)
# rsq_lcc(partial.r2.lm, data=profile, K=0.01)
# etasq(full.lm)[1,1]

# rsq_lcc <- function(formula, data, K, lcc=TRUE) {
#     caco_n <- data$PHENO
#     ncase = length(caco_n[which(caco_n==2)])
#     ncont = length(caco_n[which(caco_n==1)])
#     nt  = ncase + ncont  
#     P   = ncase/nt 
#     thd = -qnorm(K,0,1) 
#     zv  = dnorm(thd) 
#     mv = zv/K
#     theta = mv*(P-K)/(1-K)*(mv*(P-K)/(1-K)-thd) # theta in equation (15)
#     cv = K*(1-K)/zv^2*K*(1-K)/(P*(1-P))
#     fit <- lm(formula, data=data)
#     R2O = var(fit$fitted.values)/(ncase/nt*ncont/nt) #R2 on the observed scale
#     R2  = R2O*cv/(1+R2O*theta*cv)
#     if (lcc == TRUE) {
#         return(R2)
#     }else{
#         return(R2O)
#     }
# }