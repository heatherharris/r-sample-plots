##############################################################
##############################################################
##		      Propensity Score Weighting in R	  	    
##		  NERA Propensity Score Analyses Workshop		    
##				October 27, 2016					        
##											           
##	          Heather Harris & Jeanne Horst		            
##			   James Madison University		     
##  	  Adapted from Olomos & Govindasamy, 2015	    
##############################################################
##############################################################


  ## To run commands in R, you type in Command and Enter (Mac) OR Control and R (PC)

#####################################
######Setting Working Directory######
#####################################

  ## Before working in R, it is important to set a working directory.
  ## The working directory is a folder to which files will be saved and 
  ## from which other files can be opened. In order to set a working 
  ## directory, the setwd() function must be used. This function is in 
  ## the base R package and includes only one argument - the path for
  ## the working directory in quotes. The top example below is to set the
  ## working directory for a PC, the bottom is for Mac.
  
  ##PC Working Directory
	setwd("C:/Users/heatherdawnharris/Dropbox/NERA PSM Workshop/Workshop Materials/Intro to R")

  ##Mac Working Directory
	setwd("/Users/heatherdawnharris/Dropbox/NERA PSM Workshop/Workshop Materials/Intro to R")


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
 
  ## This package will be what we use to create propensity score matched groups today.
	install.packages("MatchIt")
  
  ## This package is helpful for quickly generating descriptives statistics and screening covariates.
	install.packages("psych")

  ## This package includes a data set with which we will be working today. 
	install.packages("Matching")
	
  ## We will use this package today to create density plots similar to those presented in the 
  ## PowerPoint presentation. 
	install.packages("ggplot2")
	  
  ## This package is required in order to use optimal matching. We will not use this package today, 
  ## but there is annotated syntax towards the end of this script that you might find helpful. 
	install.packages("optmatch")
	
  ## This package is required in order to use genetic matching. We will not use this package today, 
  ## but there is annotated syntax towards the end of this script that you might find helpful. 
	install.packages("rgenoud")
	
  ## This package is required in order to run generalize boosted regression models.  
	install.packages("gbm")

  ## This package is required in order to run additional regression modeling techniques. 
	install.packages("rms")


  ## Next, we need to "require" each of the packages in order to use them.

	require(MatchIt)

	require(psych)

	require(Matching)
	
	require(ggplot2)
		
	require(optmatch)
	
	require(rgenoud)
	
	require(gbm)
	
	require(rms)	

  ## Reminder: The example data we are going to use is included in the Matching package.


#####################################
######       Lalonde Data      ######
#####################################

  ## R also has a lot of data sets freely available for anyone to use. 
  ## For example, to look at the number of data sets available on the 
  ## CRAN servers, let's run the below line of code:

	?data()

  ## To pull in a data set from the Matching package, we simple need to use
  ## the data() function to open it. Let's open the Lalonde data set. This
  ## data set is commonly used in propensity score matching examples.

	data(lalonde)

  ## To make sure the data was pulled in correctly, we want to check the first
  ## few cases (rows), the last few cases, and the structure of the data set. 

	head(lalonde)

	tail(lalonde)

	str(lalonde)


  ## We can also look up additional information about the data set online:

	http://sekhon.berkeley.edu/matching/lalonde.html

  ## For the purposes of the workshop, the format of the data is summarized 
  ## below.

  ## Data frame with 445 observations on the following 12 variables.

  ## age = age in years.
  ## educ = years of schooling.
  ## black = indicator variable for blacks.
  ## hisp = indicator variable for Hispanics.
  ## married = indicator variable for martial status.
  ## nodegr = indicator variable for high school diploma.
  ## re74 = real earnings in 1974.
  ## re75 = real earnings in 1975.
  ## re78 = real earnings in 1978.
  ## u74 = indicator variable for earnings in 1974 being zero.
  ## u75 = indicator variable for earnings in 1975 being zero.
  ## treat = an indicator variable for treatment status.


###############################################
#### Regression Analysis Before Weighting  ####
###############################################


  ## We'll first use the lm() function in R to look at the regression 
  ## equation prior to weighting. If you would like to view the arguments, remember
  ## you can easily call up the help page.

	?lm()

  ## In this step, we use the lm() function to evaluate the regression weights for each variable included in the model. 
  ## We predict treatment outcome (re78) from the covariates of age, education, and ethnicity variables. 
	
	model.1<-lm(lalonde$re78~lalonde$treat+lalonde$age+lalonde$educ+lalonde$black+lalonde$hisp, data=lalonde)
	

###############################################
####   Evaluate Balance Before Weighting   ####
###############################################
	

  ## Next, we evaluate the balance of each covariate between groups prior to weighting. 
  
  pre.data.treat <- lm(lalonde$re74~lalonde$treat)
  
  pre.data.age <- lm(lalonde$re74~lalonde$age)
    
  pre.data.edu <- lm(lalonde$re74~lalonde$edu)
    
  pre.data.black <- lm(lalonde$re74~lalonde$black)
    
  pre.data.hisp <- lm(lalonde$re74~lalonde$hisp)  
  
  ## We can check the contents of each of the above objects using the summary function:
  
  summary(pre.data.treat)


###############################################
####      Estimate Propensity Scores       ####
###############################################

  ## In the below step, we estimate propensity scores using the glm function and our covariates. 
  
	ps<-glm(lalonde$treat~lalonde$age + lalonde$educ + lalonde$black + lalonde$hisp, data=lalonde, family = binomial())

  ## Next, we can check to make sure they were successfully created.
  
	summary(ps)

  ## Then, we create a new variable that is each case's predicted probability of participation 
  ## (propensity score) and attach it to the lalonde data set and check that it worked.
  
	lalonde$ps <-predict(ps, type="response")

	summary(lalonde$ps)


###############################################
####          Creating Weights             ####
###############################################

  ## In the below step, we create weights for both the treatment and comparison groups. 
  ## The weight for the treatment group is calculated as 1/ps; the weight for the comparison
  ## group is calculated as 1/(1-ps). Again, we will make sure the new variable was created. 
  
	lalonde$weight.ATE <- ifelse(lalonde$treat == 1, 1/lalonde$ps, 1/(1-lalonde$ps))

	summary(lalonde$weight.ATE)
	
	
###############################################
####    Checking Balance After Weights     ####
###############################################

## Again, we evaluate the balance of each covariate between groups after weighting. 
  
  post.data.treat <- lm(lalonde$re74~lalonde$treat, weights = (weight.ATE))
  
  post.data.age <- lm(lalonde$re74~lalonde$age, weights = (weight.ATE))
    
  post.data.edu <- lm(lalonde$re74~lalonde$edu, weights = (weight.ATE))
    
  post.data.black <- lm(lalonde$re74~lalonde$black, weights = (weight.ATE))
    
  post.data.hisp <- lm(lalonde$re74~lalonde$hisp, weights = (weight.ATE))  
  
  ## We can again check the contents of each of the above objects using the summary function:
  
  summary(pre.data.treat)

###############################################
####      Estimating Treatment Effect      ####
###############################################

	model.2 <- lm(lalonde$re78~lalonde$treat+lalonde$age+lalonde$educ+lalonde$black+lalonde$hisp, data=lalonde, weights=(weight.ATE))


####################################
####       Saving Out Data      ####
####################################
 
  ## Finally, we can save out the new propensity scores (in logits) into a final data set. 

	write.table(lalonde,file="FinalData.csv",sep=",",row.names=FALSE)



