library(KoNLP)
useSejongDic()
library(tm) 

#textmining #############################################
docs <- read.csv("sms_spam.csv" , header = T , stringsAsFactors = F) 
corpus <- Corpus(DataframeSource(docs[,1:2])) 
inspect(corpus[1:3])
corpus_clean <- tm_map(corpus , tolower) 
corpus_clean <- tm_map(corpus_clean , removeNumbers)
corpus_clean <- tm_map(corpus_clean , removeWords , stopwords())
corpus_clean <- tm_map(corpus_clean , removePunctuation) 

lapply(corpus,as.character)
sms_dtm <- TermDocumentMatrix(corpus , control = list(weighting=weightTfIdf))
inspect(sms_dtm)

sms_dtm3 <- TermDocumentMatrix(corpus)
inspect(sms_dtm3)

findFreqTerms(TermDocumentMatrix(corpus) , lowfreq = 2)
findAssocs(TermDocumentMatrix(corpus) , "user" , 0.5)

library(caret) 
library(rpart)
library(nnet) 

sms_dtm2 <- DocumentTermMatrix(corpus , control = list(weighting = weightTfIdf))
inspect(sms_dtm2)

sms_dtm2_df <- cbind(as.data.frame(as.matrix(sms_dtm2)) , LABEL = docs$type)
m <- nnet(LABEL ~ . , data = sms_dtm2_df , size = 3)
predict(m , newdata = sms_dtm2_df) 

#실습#######
advice <- read.csv("advice.csv" , header = T , stringsAsFactors = F)
place <- sapply(advice[,2] , extractNoun , USE.NAMES = F) 
c <- unlist(place) 
place2 <- Filter(function(x) {nchar(x) >=2 & nchar(x) <= 5} , c)
res <- str_replace_all(place2 , "[^[:alpha:]]" , "")
res <- res[res != ""]
res

wordcount <- table(res)
wordcount2 <- sort(table(res) , decreasing=T)
wordcount2

library(wordcloud);
library(RColorBrewer)
palete <- brewer.pal(8 , "Set2") 
wordcloud(names(wordcount) , freq = wordcount , scale=c(3,1) , rot.per = 0.25 , min.freq = 1 , random.order = F , random.color = T , colors = palete) 
keyword <- dimnames(wordcount2[1:10])$res

contents <- c()
for(i in 1:6) { 
  inter <- intersect(place[[i]] , keyword)
  contents <- rbind(contents ,table(inter)[keyword])
}

rownames(contents) <- advice$DATE
colnames(contents) <- keyword
contents[which(is.na(contents))] <- 0 

#백화점 CIC분석 
advice2 <- read.csv("advice2.csv" , header = T , stringsAsFactors = F)
rownames(advice2) <- advice2[,1]
advice2 <- advice2[-1]  
advice3 <- ifelse(advice2 > mean(apply(advice2, 2 , mean)) , 1 , 0) 

library(arules) 
trans <- as.matrix(advice3 , "Transaction")
rules1 <- apriori(trans , parameter = list(supp=0.3 , conf = 0.7 , target = "rules"))
rules1 
inspect(sort(rules1)) #tm과 arule이 충돌하는 경우가 있으므로 detach(package:xxx)를 사용하여 하나를 제거하고 해보자. 

rules2 <- subset(rules1 , subset = lhs %pin% '초밥' & confidence > 0.7)
inspect(sort(rules2)) 

image(trans)
install.packages("arulesViz")
library(arulesViz)

image(trans)
#install.packages("arulesViz")
library(arulesViz)
 
plot(rules1) 
plot(rules1 , method = "grouped") 
plot(rules1 , method = "graph" , control = list(type = "items")) 
plot(rules1 , method = "paracoord" , control = list(reorder = TRUE)) 

cor(advice2)
library(corrgram)
corrgram(cor(advice2))

library(corrplot)
corrplot(cor(advice2))

library(sna)
library(rgl)
advice_square <- t(as.matrix(advice2)) %*% as.matrix(advice2)
gplot(sqrt(sqrt(advice_square)) , displaylabel=T , vertex.cex=sqrt(diag(advice_square))*0.01 , label=rownames(advice_square) , edge.col="blue" , boxed.labels=F , arrowhead.cex=0.01 , edge.lwd=0.01 , vertex.alpha=0.01)

library(zoo)
dates <- as.Date(rownames(advice2)  , format = "%Y-%m-%d")
time_keywords <- zoo(advice2 , dates) 
plot(time_keywords)

ccf(advice2$고등어 , advice2$연어 , main = "고등어 vs 연어")
ccf(advice2$장롱 , advice2$탁자 , main = "장롱 vs 탁자")

ccf(advice2$TV , advice2$구두 , main = "TV vs 구두")
ccf(advice2$곰팡이 , advice2$노트북 , main = "곰팡이 vs 노트북")


