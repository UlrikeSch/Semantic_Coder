### LOAD FILES

setwd("/Users/Ulrike/Documents/Transitivity/15_Negation_and_Modals/02_Modal_Data/08_WordNet_Files")

data <- read.csv(file="data.verb.txt", sep="\t", fileEncoding="utf8", header=F, colClasses="character"); head(data)

index <- read.csv(file="index.verb.txt", sep="\t", fileEncoding="utf8", header=F, colClasses="character"); head(index)


### COMBINE FILES

index$semantics <- ""

for (i in 1:nrow(index)) {
	index$semantics[i] <- data[grep(index$V2[i], data$V1),2]
cat(i/nrow(index), "\n")
	
}


### SAVE RESULT

write.table(index, file="index_verb_coded.txt", sep="\t", row.names=F, quote=F)






































