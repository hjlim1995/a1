setwd("c://data")
like <- read.csv("like.csv" , stringsAsFactors = F , header = T)
colnames(like) <- c("talk" , "book" , "travel" , "school" , "tall" , "skin" , "muscle" , "label")
test <- data.frame(talk=70 , book=50 , travel=30 , school=70 , tall=70 , skin=40 , muscle=50)

library(class) 
train <- like[,-8]
group <- like[,8]
knnpred1 <- knn(train , test , group , k=3 , prob=TRUE) 
knnpred2 <- knn(train , test , group , k=4 , prob=TRUE) 

buy <- read.csv("buy.csv" , stringsAsFactors = F , header = T)
buy$age <- scale(buy$����)
buy$pay <- scale(buy$������)
buy

test <- data.frame(age=44 , pay=400)
train <- buy[,c(4,5)]
labels <- buy[,3]

#ǥ��ȭ 
test$age <- (test$age - mean(buy$����)) / sd(buy$����)
test$pay <- (test$pay - mean(buy$������)) / sd(buy$������)
knnpred1 <- knn(train , test , labels , k=5 , prob=TRUE) 
knnpred2 <- knn(train , test , labels , k=6 , prob=TRUE) 
knnpred1;knnpred2
