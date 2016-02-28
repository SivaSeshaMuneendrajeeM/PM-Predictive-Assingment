library(Hmisc)
Loading required package: survival
Loading required package: splines

Attaching package: ‘survival’

The following object is masked from ‘package:caret’:
  
  cluster

Loading required package: Formula

Attaching package: ‘Hmisc’

The following object is masked from ‘package:randomForest’:
  
  combine

The following objects are masked from ‘package:base’:
  
  format.pval, round.POSIXt, trunc.POSIXt, units

Warning messages:
  1: package ‘Hmisc’ was built under R version 3.1.3 
2: package ‘Formula’ was built under R version 3.1.3 
> library(caret)
> library(randomForest)
> library(foreach)
foreach: simple, scalable parallel programming from Revolution Analytics
Use Revolution R for scalability, fault tolerance and more.
http://www.revolutionanalytics.com
Warning message:
  package ‘foreach’ was built under R version 3.1.3 
> library(doParallel)
Loading required package: iterators
Loading required package: parallel
Warning messages:
  1: package ‘doParallel’ was built under R version 3.1.3 
2: package ‘iterators’ was built under R version 3.1.3 
> set.seed(2048)
> options(warn=-1)
> training_data <- read.csv("C:\\Users\\welcome\\Downloads\\pml-training.csv", na.strings=c("#DIV/0!") )
> evaluation_data <- read.csv("C:\\Users\\welcome\\Downloads\\pml-testing.csv", na.strings=c("#DIV/0!") )
> for(i in c(8:ncol(training_data)-1)) {training_data[,i] = as.numeric(as.character(training_data[,i]))}
> for(i in c(8:ncol(evaluation_data)-1)) {evaluation_data[,i] = as.numeric(as.character(evaluation_data[,i]))}
> feature_set <- colnames(training_data[colSums(is.na(training_data)) == 0])[-(1:7)]
> model_data <- training_data[feature_set]
> feature_set
[1] "roll_belt"            "pitch_belt"           "yaw_belt"            
[4] "total_accel_belt"     "gyros_belt_x"         "gyros_belt_y"        
[7] "gyros_belt_z"         "accel_belt_x"         "accel_belt_y"        
[10] "accel_belt_z"         "magnet_belt_x"        "magnet_belt_y"       
[13] "magnet_belt_z"        "roll_arm"             "pitch_arm"           
[16] "yaw_arm"              "total_accel_arm"      "gyros_arm_x"         
[19] "gyros_arm_y"          "gyros_arm_z"          "accel_arm_x"         
[22] "accel_arm_y"          "accel_arm_z"          "magnet_arm_x"        
[25] "magnet_arm_y"         "magnet_arm_z"         "roll_dumbbell"       
[28] "pitch_dumbbell"       "yaw_dumbbell"         "total_accel_dumbbell"
[31] "gyros_dumbbell_x"     "gyros_dumbbell_y"     "gyros_dumbbell_z"    
[34] "accel_dumbbell_x"     "accel_dumbbell_y"     "accel_dumbbell_z"    
[37] "magnet_dumbbell_x"    "magnet_dumbbell_y"    "magnet_dumbbell_z"   
[40] "roll_forearm"         "pitch_forearm"        "yaw_forearm"         
[43] "total_accel_forearm"  "gyros_forearm_x"      "gyros_forearm_y"     
[46] "gyros_forearm_z"      "accel_forearm_x"      "accel_forearm_y"     
[49] "accel_forearm_z"      "magnet_forearm_x"     "magnet_forearm_y"    
[52] "magnet_forearm_z"     "classe"              
> idx <- createDataPartition(y=model_data$classe, p=0.75, list=FALSE )
> training <- model_data[idx,]
> testing <- model_data[-idx,]
> registerDoParallel()
> x <- training[-ncol(training)]
> y <- training$classe
> rf <- foreach(ntree=rep(150, 6), .combine=randomForest::combine, .packages='randomForest') %dopar% {
  + randomForest(x, y, ntree=ntree) 
  + }
> predictions1 <- predict(rf, newdata=training)
> confusionMatrix(predictions1,training$classe)
Confusion Matrix and Statistics

Reference
Prediction    A    B    C    D    E
A 4185    0    0    0    0
B    0 2848    0    0    0
C    0    0 2567    0    0
D    0    0    0 2412    0
E    0    0    0    0 2706

Overall Statistics

Accuracy : 1          
95% CI : (0.9997, 1)
No Information Rate : 0.2843     
P-Value [Acc > NIR] : < 2.2e-16  

Kappa : 1          
Mcnemar's Test P-Value : NA         

Statistics by Class:

Class: A Class: B Class: C Class: D Class: E
Sensitivity            1.0000   1.0000   1.0000   1.0000   1.0000
Specificity            1.0000   1.0000   1.0000   1.0000   1.0000
Pos Pred Value         1.0000   1.0000   1.0000   1.0000   1.0000
Neg Pred Value         1.0000   1.0000   1.0000   1.0000   1.0000
Prevalence             0.2843   0.1935   0.1744   0.1639   0.1839
Detection Rate         0.2843   0.1935   0.1744   0.1639   0.1839
Detection Prevalence   0.2843   0.1935   0.1744   0.1639   0.1839
Balanced Accuracy      1.0000   1.0000   1.0000   1.0000   1.0000
> predictions2 <- predict(rf, newdata=testing)
> confusionMatrix(predictions2,testing$classe)
Confusion Matrix and Statistics

Reference
Prediction    A    B    C    D    E
A 1395    5    0    0    0
B    0  941    6    0    0
C    0    3  848    8    2
D    0    0    1  796    4
E    0    0    0    0  895

Overall Statistics

Accuracy : 0.9941         
95% CI : (0.9915, 0.996)
No Information Rate : 0.2845         
P-Value [Acc > NIR] : < 2.2e-16      

Kappa : 0.9925         
Mcnemar's Test P-Value : NA             

Statistics by Class:
  
  Class: A Class: B Class: C Class: D Class: E
Sensitivity            1.0000   0.9916   0.9918   0.9900   0.9933
Specificity            0.9986   0.9985   0.9968   0.9988   1.0000
Pos Pred Value         0.9964   0.9937   0.9849   0.9938   1.0000
Neg Pred Value         1.0000   0.9980   0.9983   0.9981   0.9985
Prevalence             0.2845   0.1935   0.1743   0.1639   0.1837
Detection Rate         0.2845   0.1919   0.1729   0.1623   0.1825
Detection Prevalence   0.2855   0.1931   0.1756   0.1633   0.1825
Balanced Accuracy      0.9993   0.9950   0.9943   0.9944   0.9967
> pml_write_files = function(x){
  +   n = length(x)
  +   for(i in 1:n){
    +     filename = paste0("problem_id_",i,".txt")
    +     write.table(x[i],file=filename,quote=FALSE,row.names=FALSE,col.names=FALSE)
    +   }
  + }
> x <- evaluation_data
> x <- x[feature_set[feature_set!='classe']]
> answers <- predict(rf, newdata=x)
> answers
1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 
B  A  B  A  A  E  D  B  A  A  B  C  B  A  E  E  A  B  B  B 
Levels: A B C D E