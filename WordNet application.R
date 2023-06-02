### READ FILES

setwd("/Users/Ulrike/Documents/Transitivity/15_Negation_and_Modals/02_Modal_Data/07_Modals_single_file")
data <- read.csv(file="Modals complete19.txt", sep="\t", fileEncoding="utf8", header=T); summary(file)

setwd("/Users/Ulrike/Documents/Transitivity/15_Negation_and_Modals/02_Modal_Data/08_WordNet_Files")
index <- read.csv(file="index_verb_coded.txt", sep="\t", fileEncoding="utf8", header=T, colClasses="character"); head(index)


### CODE DATA

data$semantics <- ""

for (i in 1:nrow(data)) {
	search.term <- paste("^", data$Verb.lemma[i], "$", sep="")
	sem.no <- grep(search.term, index$V1)
	if (length(sem.no)>0) {
		data$semantics[i] <- index[sem.no,3]
	} else {
		data$semantics[i] <- NA
	}
	 cat(i/nrow(data), "\n")	
}


### SAVE THE RESULT

setwd("/Users/Ulrike/Documents/Transitivity/15_Negation_and_Modals/02_Modal_Data/07_Modals_single_file")
write.table(data, file="Modals complete20.txt", sep="\t", row.names=F, quote=F)






























































# Zu Faktoren konvertieren
names(file)
names <- c(9:26)
file[,names] <- lapply(file[,names] , factor)

str(file)
summary(file)


### Einzeltests ###

file[grep("^charming", file$V26), 4:8]


### Formen kodieren

# Aus der Liste an ing-Formen wurden manuell etwa 100 Types ausgeschlossen, weil
# - sie keine Verben im progressive sein können (anything, King, bring)
# - weil sie vermutlich häufiger als Adjektive gebraucht werden (hier habe ich nur wenige getestet, das heißt L2 bis R2 angeschaut) (fucking, willing, interesting)
# - ihre Basis als Verbform nicht existieren würde (uninterest, unforgive, unplease)
# - weil sie groß geschrieben waren
# - weil nicht erkennbar war, was das verb sein sollte (gating, iding)

setwd("/Users/Ulrike/Documents/Transitivity/15_Negation_and_Modals/02_Modal_Data")
ing.file <- read.csv(file="ing-Forms cleaned.txt", sep="\t", fileEncoding="utf8", header=T); summary(ing.file)

names(file)
nrow(file) #1406863
# subsetting funktioniert plötzlich nicht mehr
Vsechsundzwanzig <- grep("^$", file$V26, value=F); length(Vsechsundzwanzig) #1395831, findet alles

V26.leer <- file[Vsechsundzwanzig,] #1395831
V26.voll <- file[-Vsechsundzwanzig,]; nrow(V26.voll) #11032

head(ing.file)

V26.leer$Verb.form <- ""
V26.voll$Verb.form <- ""

for (i in 1:nrow(V26.voll)){
	word <- V26.voll$V26[i]
	spot <- word %in% ing.file$Var1
	#spot <- ing.file[ing.file$Var1==word,3]
	if(isTRUE(spot)==TRUE){
		V26.voll$Verb.lemma[i] <- ing.file[ing.file$Var1==word,3]
		V26.voll$Verb.form[i] <- "progressive"
	} 
cat(i/nrow(V26.voll), "\n")
}


table(V26.voll$Verb.form)
length(table(V26.voll$Verb.lemma))
head(sort(table(V26.voll$Verb.lemma), decreasing=T))


file2 <- rbind(V26.voll, V26.leer)

setwd("/Users/Ulrike/Documents/Transitivity/15_Negation_and_Modals/02_Modal_Data/07_Modals_single_file")
write.table(file2, file="Modals complete18.txt", sep="\t", row.names=F, quote=F)





### Perfekt muss noch gemacht werden 
### und natürlich könnte man so doch auch Passiv versuchen

################################
### Silbenzahl und Wortlänge ###
################################

setwd("/Users/Ulrike/Documents/Transitivity/15_Negation_and_Modals/02_Modal_Data/07_Modals_single_file")
file <- read.csv(file="Modals complete18.txt", sep="\t", fileEncoding="utf8", header=T); summary(file)
# Ausgabe komplett als Character-Strings


# Zu Faktoren konvertieren
names(f25ile)
names <- c(9:21)
file[,names] <- lapply(file[,names] , factor)

str(file)
summary(file)

head(file)

#install.packages("quanteda")
library(quanteda)

#install.packages("nsyllable")
library(nsyllable)

#### Silbenzahl
?nsyllable

filled <- which(file$Verb.lemma!=""); length(filled)
empty <- which(file$Verb.lemma==""); length(empty)
length(filled)+length(empty)

part1 <- file[filled,]
part2 <- file[empty,]

part2$syllables <- NA
part2$letters <- NA

part1$syllables <- nsyllable(part1$Verb.lemma)
head(part1$syllables)
part1$letters <- nchar(part1$Verb.lemma)

file2 <- rbind(part1, part2)


#plot(file2$syllables, file2$letters)
table(file2[file2$syllables==5,25])
# Auch Wörter mit angeblichen 6 Silben gecheckt:
# Bei Wörtern , die vermutlich nicht im Wörterbuch standen, wird die Silbenzahl überschätzt, wenn das Wort auf -e endet.


setwd("/Users/Ulrike/Documents/Transitivity/15_Negation_and_Modals/02_Modal_Data/07_Modals_single_file")
write.table(file2, file="Modals complete19.txt", sep="\t", row.names=F, quote=F)













