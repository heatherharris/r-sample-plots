##############################################################
##############################################################
##		Introduction to PSM Missing Data Methods	  	    ##
##		  NERA Propensity Score Analyses Workshop		    ##
##				October 27, 2016					        ##
##											                ##
##	  Heather Harris *Jessica Jacovidis * Jeanne Horst      ##
##			   James Madison University		     	        ##
##############################################################
##############################################################

  ## The generated missingness values for this exercise was adapted with permission from
  ## code created by Kelly Foelber, Heather Harris, and Elisabeth Pyburn. 

  ## To run commands in R, you type in Command and Enter (Mac) OR Control and R (PC)

#####################################
######Setting Working Directory######
#####################################

  ## Before working in R, it is important to set a working directory.
  ## The working directory is a folder to which files will be saved and 
  ## from which other files can be opened. In order to set a working 
  ## directory, the setwd() function must be used. This function is in 
  ## the base R package and includes only one argument - the path for
  ## the working directory in quotes. 

	setwd("C:/Users/heather.harris/Desktop/R Files")

  ## Note: For PC the slashes in the path need to be "/" and for Macs "\"

  ## After setting a working directory, we can check that is was set corretly
  ## by running the "get working directory" function (getwd()). 
	
	getwd()


#####################################
######   Installing Packages   ######
#####################################

  ## In order to use certain functions in R, we first need to install 
  ## a few packages. We use the install.packages() function to download
  ## the packages we want off of the CRAN server. When installing a package,
  ## we are prompted to first choose a "mirror" (CRAN server) near us from 
  ## which we can download the information. The closer the mirror, the (marginally)
  ## quicker the package will download. 


	install.packages("MatchIt")

	install.packages("psych")
	
	install.packages("optmatch")
	
	install.packages("mvtnorm")

  ## Next, we need to "require" each of the packages in order to use them.

	require(MatchIt)

	require(psych)
	
	require(optmatch)
	
	require(mvtnorm)

  ## The example data we are going to use is included in the Matching package.


#####################################
######     Simulating Data     ######
#####################################

  ## For the purposes of this part of the workshop, we will not be using the LaLonde data set
  ## because the data set includes many categorical veriables. Rather, we will simulate a data
  ## set with only continuous variables. Although the missing data methods can be used with
  ## categorical data, it is easier for illustration purposes to use continuous variables. 

			##PARTICIPANTS 
  ## In this step, We simulate a dataset with 200 participants.

Nexaminee1=200

  ## In order to simulate the data, we first need to create a correlation matrix that includes
  ## the relationships among the five covariates.

	corrX=matrix(c(1,.3,.3,.3,.3,
         	     .3, 1,.3,.3,.3,
            	  .3,.3, 1,.3,.3,
            	  .3,.3,.3, 1,.3,
            	  .3,.3,.3,.3, 1 ),5,5)
               
  ## In this step, we double-check that the matrix was created successfully.

	corrX

  ## Next, we create a vector of standard deviation values
  ## for each of the five covariates
	
	sdX=c(5,5,5,5,5)
  
  ## How can we check whether it was created successfully?

  ## We then multiply it by its transpose and then by the correlation matrix (corrX)
  ## in order to make a covariance matrix.

	temp=sdX %*% t(sdX)  #Multiplying sdX by its transpose

	temp

	covX=corrX *temp 

	covX

  ## Next, we simulate the data by using the objects we just created. 
  ## We will use "chol" for Cholesky decomposition. 

	XT=rmvnorm(Nexaminee1, c(25,25,22.5,22.5,22.5), covX, method="chol") 

  ## Next, I create v, which is a randomly generated number for each of the examinees in the 
  ## simulated data set. 

	v=rnorm(Nexaminee1)

	v

  ## Next, we need to create a grouping variable to indicate this is the participant group

	groupT<-rep(1,200)

	str(group)


  ## In the below steps, we simulate Y or the outcome variable with an intercept of 100,
  ## and a function of X3, X4, and X5, with a treatment effect of 10.

	YT=100 + 10 +.5*XT[,3]+.5*XT[,4]+.5*XT[,5]+v

	Y

		##NON-PARTICIPANTS 

  ## For non-participants, we complete the same series of steps above, but simulate a larger
  ## number (our "resevour") and we will simulate them to be lower on the covariates to 
  ## signify selection bias.

	Nexaminee2=800

	XC=rmvnorm(Nexaminee2, c(20,20,20,20,20), covX, method="chol") 

	v=rnorm(Nexaminee2)
	
	v

	groupC<-rep(0,800)

	str(group)

	YC=100 +.5*XC[,3]+.5*XC[,4]+.5*XC[,5]+v
	
	Y

  ## In the below steps, we combine both the Treatment and Comparison group information into 
  ## one large data set. 

	Y<-c(YT, YC)
	group<-c(groupT, groupC)
	X1<-c(XT[,1],XC[,1])
	X2<-c(XT[,2],XC[,2])
	X3<-c(XT[,3],XC[,3])
	X4<-c(XT[,4],XC[,4])
	X5<-c(XT[,5],XC[,5])

  ## We then make a final data set by combining all of the variables we simulated into one data frame.

	dataA=cbind(group, X1, X2, X3, X4, X5, Y)

	dataB<-as.data.frame(dataA)

  ## How can we check to make sure it was created correctly?

  ## In this step, we compute propensity scores using logistic regression.

	Pb=glm(formula=group ~ X1+X2+X3+X4+X5, data=dataB,  family=binomial)

  ## We can then check to make sure it was created successfully. 

	Pb  

	Pb$coefficients  

  ## In the below steps, I save each of the coefficients as a number. 
  ## Sometimes, MatchIt can be glitchy. 
  
	IntCo<-as.numeric(Pb$coefficients[1])
	X1co <-as.numeric(Pb$coefficients[2])
	X2co <-as.numeric(Pb$coefficients[3])
	X3co <-as.numeric(Pb$coefficients[4])
	X4co <-as.numeric(Pb$coefficients[5])
	X5co <-as.numeric(Pb$coefficients[6])

  ## We need to first create values for the predicted values.

	Phat<-rep(NA, 1000)

	X1pred<-rep(NA, 1000)
	X2pred<-rep(NA, 1000)
	X3pred<-rep(NA, 1000)
	X4pred<-rep(NA, 1000)
	X5pred<-rep(NA, 1000)

  ## We can then loop through all participants and nonparticipants to
  ## assign propensity scores based on their levels on the covariates. 

	for (j in 1:1000) {
		X1pred[j]<-dataB$X1[j]*X1co
		X2pred[j]<-dataB$X2[j]*X2co
		X3pred[j]<-dataB$X3[j]*X3co
		X4pred[j]<-dataB$X4[j]*X4co
		X5pred[j]<-dataB$X5[j]*X5co
		Phat[j]=sum(IntCo,X1pred[j],X2pred[j],X3pred[j],X4pred[j],X5pred[j])
	 	}

	Phat

	xp <- exp(Phat) 
	
	xp

	prop <-xp/(1+xp)  #convert odds --> probabilitites (i.e., propensity scores)

	prop

	data<-cbind(dataB,Phat,prop)

  ## How can we check our final data set?
 

####################################
####    Creating Missingness    ####
####################################

  ## We are going to base the missingness off of two of the covariates. 
  ## To do this, we will use a probablistic function to make higher scores
  ## most likely to be deleted on two other covariates. 
  ## For now, we will run this part of the script without going into detail,
  ## but if you would like, I can explain in greater detail later. 

	x3cut <- quantile(data$X3, probs=0.90)

	x3cut
	
	data$X3extreme <- ifelse(data$X3 >= x3cut, yes=1, no=0)

	nextremeX3 <- length(data$X3extreme[data$X3extreme==1])

	nextremeX3

	data$X3probmiss <- NA

	data$X3probmiss[data$X3extreme==1] <- runif(n=nextremeX3, min=0.7, max=1.0)

	nnonextX3 <- 1000-nextremeX3

	nnonextX3

	data$X3probmiss[data$X3extreme==0] <- runif(n=nnonextX3, min=0, max=0.034)

	mean(data$X3probmiss[data$X3extreme==1])
	mean(data$X3probmiss[data$X3extreme==0])
	(10*mean(data$X3probmiss[data$X3extreme==1]))+(90*mean(data$X3probmiss[data$X3extreme==0]))

  ## In the below step, we create a missingness indicator for X3 (1 = missing)
  ## What can we do with this newly created value?
  

	randomProbs <- runif(n=1000, min=0, max=1)
	data$X3miss <- ifelse(data$X3probmiss >= randomProbs, yes=1, no=0)
	data$Y.X3.10 <- ifelse(data$X3miss==1, yes=NA, no=data$Y)
	zcut <- quantile(data$X4[data$X3miss==0], probs=0.88871)
	zcut
	data$X4extreme <- ifelse(data$X4 >= zcut, yes=1, no=0)

  ## We repeat the above process above to create additional missingness on X1 based on values on X4.

	nextremeX4 <- length(data$X4extreme[data$X4extreme==1])
	nextremeX4
	data$X4probmiss <- NA
	data$X4probmiss[data$X4extreme==1] <- runif(n=nextremeX4, min=0.7, max=1.0)
	nnonextX4 <- 1000-nextremeX4
	nnonextX4
	data$X4probmiss[data$X4extreme==0] <- runif(n=nnonextX4, min=0, max=0.034)
	mean(data$X4probmiss[data$X4extreme==1])
	mean(data$X4probmiss[data$X4extreme==0])
	(11.129*mean(data$X4probmiss[data$X4extreme==1]))+(88.871*mean(data$X4probmiss[data$X4extreme==0]))
	randomProbs <- runif(n=8000, min=0, max=1)
	data$X4miss <- ifelse(data$X4probmiss >= randomProbs, yes=1, no=0)
	data$Y.X4.10 <- ifelse(data$X4miss==1, yes=NA, no=data$X2)
	data$X2miss <- ifelse(data$X4miss==1, yes=NA, no=data$Y.X3.10)

####################################
#### Propensity Score Matching  ####
####################################


  ## We'll again be using the MatchIt package in R to conduct PSM. If we do not use a missing data technique, 
  ## we by default will be using LISTWISE DELETION. Let's look at what we find:

	?MatchIt()

  ## In this step, we again use the matchit() function to calculate propensity scores and create matches.
  ## The results are then saved in a new object called "m.out1".
	
	m.out1<-matchit(data$group~data$X2+data$X3+data$X4+data$X5, data=data, method="nearest", ratio=1)

  ## In this step, we check the results (saved in m.out) created by the matching program. The above step used 
  ## nearest neighbor matching and provided us with predicted values (in logits) for each case in the data set.
	
	m.out1
	summary(m.out1)


####################################
####    Stochastic Regression   ####
####################################

  ## First, we want to predict the missing variable (X2) with complete variables (X1, X3-X5)

	Reg20 <- lm(formula = X2 ~ X1 + X3 + X4 + X5, data=data)

	summary(Reg20)

	describe(data)

  ## We also need to obtain the SD of the residuals, so we can add a random error term.

 	sd(Reg20$residuals)

  ## Imputing missing data values for X2

	data$X2imp <- ifelse((is.na(missing20$Y20)==TRUE), yes=(Reg20$coefficients[1]+(Reg20$coefficients[2]*missing20$X1)	
	(Reg20$coefficients[3]*missing20$X2)+(Reg20$coefficients[4]*missing20$X3)+(Reg20$coefficients[5]*missing20$X4)+	
	(Reg20$coefficients[6]*missing20$X5)+(rnorm(1, mean=0, sd=sd(Reg20$residuals)))), no=missing20$Y20)



  ## In this step, we again use the matchit() function to calculate propensity scores and create matches.
  ## The results are then saved in a new object called "m.out1".
	
	m.out2<-matchit(data$group~data$X1+data$X2imp+data$X3+data$X4+data$X5, data=data, method="nearest", ratio=1)

  ## In this step, we check the results (saved in m.out) created by the matching program. The above step used 
  ## nearest neighbor matching and provided us with predicted values (in logits) for each case in the data set.
	
	m.out2
	
	summary(m.out2)
	
####################################
####    Multiple Imputation     ####
####################################

  ## To use multiple imputation, we need to create m data sets (in this case 50) with
  ## different imputed values for each set. 
	imp20.sets <-amelia(data,idvars=c("X2","ID","group","X3extreme","X3probmiss","X3miss","X2.X3.10","X4extreme",
	"X4probmiss","X4miss","X2.X4.10"),m=50)

  ## Let's take a look at the imputed data sets. 
	
	str(imp20.sets$imputations)

  ## We can also look at just one of the data sets. 
  
	str(imp20.sets$imputations[[1]])

  ## Next, we need to aggrigate across all 50 data sets. 
  
	temp <- matrix(data=NA,nrow=1000,ncol=50)

  ## Next, we use a for loop to put the multiply across imputed values

	for (j in 1:50) {
		temp[,j] <- imp20.sets$imputations[[j]]$Y20
		}

  ## Next, we can create our final combined dataset 
  
	data2 <- imp20.sets$imputations[[1]]

  ## Next, we average across all the X2 variables in all 50 imputed datasets. 
  ## The new, averaged variable is called "YAmeliaImp".
  
	data2$X2AmeliaImp <- apply(temp,MARGIN=1,FUN=mean)

	str(data2)

  ## In this step, we again use the matchit() function to calculate propensity scores and create matches.
  ## The results are then saved in a new object called "m.out1".
	
	m.out3<-matchit(data$group~data$X2AmeliaImp+data$X3+data$X4+data$X5, data=data, method="nearest", ratio=1)
	
  ## In this step, we check the results (saved in m.out) created by the matching program. The above step used 
  ## nearest neighbor matching and provided us with predicted values (in logits) for each case in the data set.
	
	m.out3
	
	summary(m.out3)


####################################
####       Saving Out Data      ####
####################################
 
  ## Finally, we can save out the new propensity scores (in logits) into a final data set. 

	write.table(NN,file="FinalData.csv",sep=",",row.names=FALSE)



