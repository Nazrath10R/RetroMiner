
library(ggplot2)
library(reshape2)


input_files <-  list.files(path = ".", pattern = "*_parsed.txt")

# example <- input_files[1]

# example_table <- read.table(example, sep="\t", header=TRUE)
# second_table <- read.table(input_files[2], sep="\t", header=TRUE)

# rbind(example_table, second_table)

# create empty table
table <- matrix(NA, 1, 12)
table <- as.data.frame(table)

colnames(table) <- c("Dataset","Disease","Tissue","Sample","Replicate","ORF1p","ORF2p","ORF0","ORF1p_variants","ORF2p_variants","HERV_proteins","PTMs")


for(i in 1:length(input_files)) {

  tab <- read.table(input_files[i], sep="\t", header=TRUE)
  table <- rbind(table, tab)

}

table <- table[-1,]

head(table)

length(unique(table$Dataset))

table$ORF1p
table$ORF2p
table$ORF0
table$ORF1p_variants
table$ORF2p_variants
table$HERV_proteins


par(mfrow=c(1,2))
boxplot(table$ORF1p[which(table$ORF1p>0)], main="ORF1p score", col="steelblue", 
        xlab=paste("n = ", length(which(table$ORF1p>0)),sep = ""))

boxplot(table$ORF2p[which(table$ORF2p>0)], main="ORF2p score", col="steelblue", 
        xlab=paste("n = ", length(which(table$ORF2p>0)),sep = ""))



orf1p_length <-  length(table$ORF1p[which(table$ORF1p>0)])
orf2p_length <-  length(table$ORF2p[which(table$ORF2p>0)])

difference_table <- as.data.frame(matrix(NA,orf1p_length+orf2p_length,2))
colnames(difference_table) <- c("protein", "score")

difference_table$score[1:orf1p_length] <- table$ORF1p[which(table$ORF1p>0)]
difference_table$protein[1:orf1p_length] <- rep("ORF1p",orf1p_length)

difference_table$score[(1+orf1p_length):(orf1p_length+orf2p_length)] <- table$ORF2p[which(table$ORF2p>0)]
difference_table$protein[(1+orf1p_length):(orf1p_length+orf2p_length)] <- rep("ORF2p",orf2p_length)

difference_table$score <- as.numeric(difference_table$score)


ggplot(difference_table, aes(x = protein, y = score)) +
        geom_boxplot(fill = "steelblue") + 
        ggtitle("Difference between LINE-1 protein confidence scores \n n(ORF1p) = 16 \t n(ORF2p) = 34") +
        theme_bw() + geom_jitter() 



par(mfrow=c(1,1))

#### Variants ####

## ORF1p variants

orf1p_variants <- table$ORF1p_variants[which(table$ORF1p_variants!=0)]

orf1p_variant_confidences <- 0

for(i in 1:length(orf1p_variants)) {
  value <- unlist(strsplit(orf1p_variants[i], split = "\\(|\\)"))
  value <- as.numeric(value[seq(2, length(value), 2)])
  orf1p_variant_confidences <- c(orf1p_variant_confidences, value)
}

orf1p_variant_confidences <- orf1p_variant_confidences[-1] 

plot(orf1p_variant_confidences)
abline(h=80, col="red")


## ORF2p variants

orf2p_variants <- table$ORF2p_variants[which(table$ORF2p_variants!=0)]

orf2p_variant_confidences <- 0

for(i in 1:length(orf2p_variants)) {
  value <- unlist(strsplit(orf2p_variants[i], split = "\\(|\\)"))
  value <- as.numeric(value[seq(2, length(value), 2)])
  orf2p_variant_confidences <- c(orf2p_variant_confidences, value)
}

orf2p_variant_confidences <- orf2p_variant_confidences[-1] 

plot(orf2p_variant_confidences)
abline(h=80, col="red")



all_variants <- c(orf1p_variant_confidences, orf2p_variant_confidences)
plot(all_variants)
abline(h=80, col="red")



orf1p_var_length <-  length(orf1p_variant_confidences)
orf2p_var_length <-  length(orf2p_variant_confidences)


two_var_table <- as.data.frame(matrix(NA,orf1p_var_length+orf2p_var_length,2))
colnames(two_var_table) <- c("variant", "score")

two_var_table$score[1:orf1p_var_length] <- orf1p_variant_confidences
two_var_table$variant[1:orf1p_var_length] <- rep("ORF1p_variant",orf1p_var_length)

two_var_table$score[(1+orf1p_var_length):(orf1p_var_length+orf2p_var_length)] <- orf2p_variant_confidences
two_var_table$variant[(1+orf1p_var_length):(orf1p_var_length+orf2p_var_length)] <- rep("ORF2p_variant",orf2p_var_length)

two_var_table$score <- as.numeric(two_var_table$score)


ggplot(two_var_table, aes(x=rownames(two_var_table), y=score, color=variant)) +
  geom_point() + geom_hline(yintercept=80 , color='red', size=0.2) +
  theme(axis.title.x = element_blank(),
        axis.text.x=element_blank(), 
        # axis.line.x=element_line(color="black", size = 0.6),
        axis.line.y=element_line(color="black", size = 0.2),
        axis.ticks.x=element_blank())


ggplot(two_var_table, aes(score, fill=variant)) +
 geom_density(alpha = 0.2) + ggtitle("LINE-1 variant smoothed density plot")


ggplot(two_var_table, aes(score, fill=variant)) +
 geom_histogram(bins=80, alpha = 0.35) 








number_of_variants <- length(orf1p_variant_confidences)+length(orf2p_variant_confidences)
# 174 orf1p variants vs 347 orf2p variants
# 315 vs 832

variant_confidences <- as.data.frame(matrix(NA, number_of_variants, 2))

colnames(variant_confidences) <- c("protein", "value") 

variant_confidences$protein[1:length(orf1p_variant_confidences)] <- rep("ORF1p_variant", length(orf1p_variant_confidences))
variant_confidences$value[1:length(orf1p_variant_confidences)] <- orf1p_variant_confidences

variant_confidences$protein[316:nrow(variant_confidences)] <- rep("ORF2p_variant", length(orf2p_variant_confidences))
variant_confidences$value[316:nrow(variant_confidences)] <- orf2p_variant_confidences


ORF1p_confidences <- table$ORF1p[which(table$ORF1p>0)]
ORF2p_confidences <- table$ORF2p[which(table$ORF2p>0)]

confidences <- variant_confidences
confidences

# n <- matrix(NA, length(ORF1p_confidences),2)
# n[,1] <- rep("ORF1p", length(ORF1p_confidences))
# n[,2] <- ORF1p_confidences

n <- matrix(NA, length(ORF1p_confidences)+length(ORF2p_confidences),2)
n[,1] <- c(rep("ORF1p", length(ORF1p_confidences)), rep("ORF2p", length(ORF2p_confidences)))
n[,2] <- c(ORF1p_confidences, ORF2p_confidences)
n <- as.data.frame(n)
colnames(n) <- colnames(confidences)

confidences <- rbind(confidences, n)



# colnames(variant_confidences) <- c("protein", "confidence")
# x <- melt(variant_confidences)

# ggplot(x, aes(x=rownames(variant_confidences) ,y=value, color=protein)) +
#   geom_point() +
#   theme(
#         axis.title.x=element_blank(),
#         axis.text.x=element_blank(),
#         axis.ticks.x=element_blank())


colnames(confidences) <- c("protein", "confidence")
x <- melt(confidences)

x$confidence <- as.numeric(as.character(x$confidence))

ggplot(x, aes(x=seq(1,nrow(x),1) ,y=confidence, color=protein)) +
  geom_point() +
  scale_y_continuous(breaks=seq(0, 100, 10)) +
  theme(axis.title.x = element_blank())
  ggtitle("confidence scores for identified proteins")



# ggplot(x, aes(confidence, colour=protein)) +
#   geom_freqpoly(binwidth = 5)


ggplot(x, aes(confidence, fill=protein)) +
  geom_histogram(binwidth = 3)  + geom_vline(xintercept=80, color = "black", size=0.25) +
    facet_grid(scales="free_y" , protein ~ .) + ggtitle("LINE-1 protein identifications") +
    ylab("frequency") + xlab("combined confidence score") +
    theme(axis.line.x = element_line(color="black", size = 0.3),
        axis.line.y = element_line(color="black", size = 0.3),
        plot.title = element_text(hjust = 0.5, size = 18),
        axis.text=element_text(size=14), legend.text=element_text(size=12),
        legend.title=element_text(size=16),
        axis.title=element_text(size=16,face="bold"))



















# redo with HERV proteins

hervs <- table$HERV_proteins[which(table$HERV_proteins!=0)]

hervs <- gsub("c", "", hervs)

test <- gsub("\\(|\\)", "",hervs)
test <- gsub(",", "", test)
test <- gsub("\\ ", "_", test)
test

test <- unlist(strsplit(test, split = "_"))
test_values <- test[seq(2,length(test),2)]

plot(test_values)

test
test_matrix <- matrix(test,length(test)/2,2,byrow = TRUE)
test_df <- as.data.frame(test_matrix)

colnames(test_df) <- c("protein", "confidence")
test_df

test_df_melted <- melt(test_df)
test_df_melted$confidence <- as.numeric(as.character(test_df_melted$confidence))


ggplot(test_df_melted, aes(x=seq(1,nrow(test_df_melted),1) ,y=confidence, color=protein)) +
  geom_point() +
  scale_y_continuous(breaks=seq(0, 100, 10)) +
  theme(axis.title.x = element_blank()) +
  ggtitle("confidence scores for identified HERV proteins")



####



table$ORF1p[which(table$ORF2p>80)]



x[which(x$confidence>80),]

grep(88.03400, table)
table[9,]




grep("ORF2p_PA2_17_(64.436)", table)

which(table$ORF2p==87.096774)

str(table)




# write.table(table, "output_table.txt", sep="\t")

















