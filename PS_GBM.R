##############################################################
##############################################################
##		      Generalized Boosted Models in R	  	    
##		  NERA Propensity Score Analyses Workshop		    
##				October 27, 2016					        
##											           
##	          Heather Harris & Jeanne Horst		            
##			   James Madison University		     	    
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
	
  ## The twang() package in R will be used to run GBM. 
 	install.packages("twang")


  ## Next, we need to "require" each of the packages in order to use them.

	require(MatchIt)

	require(psych)

	require(Matching)
	
	require(ggplot2)
		
	require(optmatch)
	
	require(rgenoud)
	
	require(gbm)
	
	require(rms)	
	
	require(twang)

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
####       Missing Data with twang()       ####
###############################################

  ## Because the twang() package does not handle missing data, we must first
  ## specify how we would like it to be handled. For example, we might use
  ## listwise deletion. 
  
  ## The below code will listwise delete cases with missing data.
  
  lalonde.2 <- na.omit(lalonde)
  
  ## Keep in mind... talk about missing data handling methods before or after this part???

###############################################
####  Estimating Propensity Scores w/ GBM  ####
###############################################

  ## In the below step, we use the ps() function to estimate propensity scores using
  ## the generalized boosted model. We specify the covariates predicting treatment 
  ## (lalonde$treat), the data set (lalonde), the treatment effect estimand of interest
  ## (ATE), the stopping rule we want to employ (es.max), & the number of iterations (10,000).

lalonde.ps <- ps(lalonde$treat ~ lalonde$age + lalonde$educ + lalonde$hisp + lalonde$black, data = lalonde, estimand = "ATE", stop.method = "es.max", n.trees = 10000, verbaose = F)

  ## We can then also plot the balance according to each iteration and the stopping rule.
  
  plot(lalonde.ps.ks, plots = 1)

  ## Other balance information can be obtained using the bal.table function:
  
  bal.table(lalonde.ps, digits=3, ks.cutoff = 0, p.cutoff = 1)
  
  tx.mn #The mean of the treatment group 
  tx.sd #The standard deviation of the treatment group 
  ct.mn #The mean of the control group 
  ct.sd #The standard deviation of the control group 
  std.eff.sz #The standardized effect size, (tx.mn-ct.mn)/tx.sd. If tx.sd is small or 0, the  standardized effect size can be large or INF. Therefore standardized effect sizes greater than 500 are set to NA 
  stat #The t-statistic for numeric variables and the chi-square statistic for continuous variables 
  p #The p-value for the test associated with stat 
  ks #The KS statistic 
  ks.pval #The KS p-value computed using the analytic approximation, which does not necessarily work well with a lot of ties


###############################################
####  Comparing Balance Before and After   ####
###############################################

  ## Next, we can compare the balance of the covariates before matching versus after matching
  ## using the bal.table() function. 
  
  bal.table(lalonde.ps)
  
###############################################
####        Using KS Stopping Rule         ####
###############################################  

  ## This time, we will use the Kolmogorov-Smirnov stopping rule and again check the balance.
  
  lalonde.ks <- ps(lalonde$treat ~ lalonde$age + lalonde$educ + lalonde$hisp + lalonde$black, data = lalonde, estimand = "ATE", stop.method = "ks.max", n.trees = 10000, verbaose = F)
  
  bal.table(lalonde.ks)

  ## What do you notice is different between the two stopping rules?	

####################################
####       Saving Out Data      ####
####################################
 
  ## Once again, we can save out the final data set. 

	write.table(lalonde,file="FinalData.csv",sep=",",row.names=FALSE)



