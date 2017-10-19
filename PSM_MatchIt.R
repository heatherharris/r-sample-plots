##############################################################
##############################################################
##		Introduction to Propensity Score Matching	  	    
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

  ## PACKAGES WE WILL USE TODAY ##
 
  ## This package will be what we use to create propensity score matched groups today.
	install.packages("MatchIt")
  
  ## This package is helpful for quickly generating descriptives statistics and screening covariates.
	install.packages("psych")

  ## This package includes a data set with which we will be working today. 
	install.packages("Matching")
	
  ## We will use this package today to create density plots similar to those presented in the 
  ## PowerPoint presentation. 
	install.packages("ggplot2")

  ## PACKAGES WE WILL NOT USE TODAY BUT USED LATER IN THE SCRIPT ##
	  
  ## This package is required in order to use optimal matching. We will not use this package today, 
  ## but there is annotated syntax towards the end of this script that you might find helpful. 
	install.packages("optmatch")
	
  ## This package is required in order to use genetic matching. We will not use this package today, 
  ## but there is annotated syntax towards the end of this script that you might find helpful. 
	install.packages("rgenoud")
	


  ## Next, we need to "require" each of the packages in order to use them.

	require(MatchIt)

	require(psych)

	require(Matching)
	
	require(ggplot2)
		
	#require(optmatch)
	
	#require(rgenoud)
	

  ## The example data we are going to use is included in the Matching package.


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


####################################
#### Propensity Score Matching  ####
####################################


  ## We'll be using the MatchIt package in R to conduct PSM. Let's first call up the help page 
  ## to look through the arguments.

	?MatchIt()

  ## In this step, we use the matchit() function to calculate propensity scores using the group  (treatment)
  ## as the DV predicted from age, education, ethnicity, marriage status, and degree level (covariates) 
  ## using the nearest neighbor greedy algorithm. Which algorithm we use is indicated by the method= argument. 
  ## We also must specify the data set (data=lalonde), and to match nonparticipantsto participants at a 1:1 ratio 
  ## using the ratio= argument. You can also use many-to-one matching (e.g. ratio=4). The results are then saved
  ## in a new object called "m.out".
	
	m.out1<-matchit(lalonde$treat~lalonde$age+lalonde$educ+lalonde$black+lalonde$hisp+
	lalonde$married+lalonde$nodegr, data=lalonde, method="nearest", ratio=1)

  ## In this step, we check the results (saved in m.out) created by the matching program. The above step used 
  ## nearest neighbor matching and provided us with predicted values (in logits) for each case in the data set.
	
	m.out1

  ## In the step below, the standard deviation (in logits) is calculated. These values will be used
  ## in the next step -- matching within a specified caliper width. The below code calculates the  
  ## standard deviation to use in the next step. 
	
	ps.sd = sd(m.out1$distance)

  ## How do we check what is in ps.sd?

####################################
####    Using Caliper Widths    ####
####################################


  ## As mentioned in the previous step, the "caliper=" argument indicates that matches should only be 
  ## created for participants/treatment cases that have a comparison group match within .2 standard 
  ## deviations on the logit of the propensity score. 0.2 SD is a distance commonly used in 
  ## practice, but it can be adjusted to any value (e.g., 0.1 sd). 

  ## Note that in order to set a caliper distance, we needed to first calculate the
  ## standard deviation of the logit of the propensity score. Let's first check the 
  ## values we created in the last step.   
	
	ps.sd

	m.out2<-matchit(lalonde$treat~lalonde$age+lalonde$educ+lalonde$black+lalonde$hisp+lalonde$married+ 
	lalonde$nodegr, data=lalonde, caliper = 0.2*ps.sd, method="nearest", ratio=1)

  ## We can once again look at the object we just created (m.out) to see our matched data. 

	m.out2
	
  ## What do you think happens if we make the caliper distance smaller?
  
    m.out3<-matchit(lalonde$treat~lalonde$age+lalonde$educ+lalonde$black+lalonde$hisp+lalonde$married+ 
	lalonde$nodegr, data=lalonde, caliper = 0.1*ps.sd, method="nearest", ratio=1)  
	
	m.out3

####################################
####     Diagnosing Matches     ####
####################################

  ## Diagnosing the quality of matches is most useful when the nearest neighbor
  ## matching algorithm is used. Two primary approaches are typically used to
  ## assess the quality of matches and ensure the two groups are indeed balanced
  ## on the propensity scores: visual and numeric diagnostics. 

  ## VISUAL DIAGNOSIS ##

  ## Several visual aids are available via the MatchIt package in R to diagnose the 
  ## quality of matches visually. For example, we can plot jitter graphs and 
  ## histograms to examine the balance of the matched treatment (participants) 
  ## and control (nonparticipants). First, let's save our three final matched data sets 

	NN<-match.data(m.out1) 
	NNCalip.2<-match.data(m.out2)
	NNCalip.1<-match.data(m.out3)
	
	plot(m.out1, type = "jitter") 

	plot(m.out1, type = "hist")
	
	plot(m.out1, type = "QQ") 
	
  ## We can also compare the density distributions for each covariate before matching vs. after matching. 

	qplot(age, data = lalonde, geom = "density", fill = as.factor(treat), alpha=I(.5),
	main = "Density of Age BEFORE Matching by Group", xlab = "Age (in years)", ylab = "Density")
	
	qplot(age, data = NNCalip.2, geom = "density", fill = as.factor(treat), alpha=I(.5),
	main = "Density of Age AFTER Matching by Group", xlab = "Age (in years)", ylab = "Density")
	
	
  ## NUMERIC DIAGNOSIS ##

  ## We should also evaluate the numeric balance between groups both univariately and
  ## multivariately (i.e., on each covariate and on the propensity score). To evaluate
  ## the quality of matches numerically, the describe() function can be used.

	describe(NN)
	
	head(NN)
	
	summary(m.out1)
	
	summary(m.out1, standardize=T)
	

  ## As mentioned earlier in the presentation, we want the individal covariates 
  ## for both groups to be within one fourth of a standard deviation of each other, 
  ## and the same for the propensity scores. We also want both groups to have roughly
  ## the same spread of scores, and we can check that by dividing the variance of  
  ## one group's propensity scores by the variance of the others -- we want this 
  ## ratio to be close to one, indicating that the groups are similar in their
  ## spread of scores. 	

####################################
####       Saving Out Data      ####
####################################
 
  ## Finally, we can save out the new propensity scores (in logits) into a final data set. 

	write.table(NN,file="FinalData.csv",sep=",",row.names=FALSE)


####################################
####    One-to-Many Matching    ####
####################################

  ## With nearest neighbor matching, we can also match multiple comparison group
  ## members to each treatment group member using the "ratio=" argument. 
  ## For example, the below code matches two comparison group members to every
  ## treatment group member. The data set we are working with does not have enough
  ## control units to use one-to-many matching. 

	m.out=matchit(lalonde$treat~lalonde$age+lalonde$educ+lalonde$black+lalonde$hisp+lalonde$married+
	lalonde$nodegr, data=lalonde, caliper = 0.2*ps.sd, method="nearest", ratio=2)


####################################
####    Matching Algorithms     ####
####################################

  ## Other matching algorithms are also available. To use different matching algorithms,
  ## we change the "method=" argument to one of the following:

  ## "exact"    = Exact Matching
  ## "full"     = Full Matching 
  ## "genetic"  = Genetic Matching
  ## "optimal"  = Optimal Matching
  ## "subclass" = Subclassification (which we will cover later)

  ## For example, we could run the following code to use optimal matching rather 
  ## than nearest neighbor matching. 

	m.out4=matchit(lalonde$treat~lalonde$age+lalonde$educ+lalonde$black+lalonde$hisp+lalonde$married+
	lalonde$nodegr, data=lalonde, method="optimal", ratio=1)
	
  ## Now, we can change the "method=" argument to "exact" to use exact matching. 
  
    m.out5=matchit(lalonde$treat~lalonde$age+lalonde$educ+lalonde$black+lalonde$hisp+lalonde$married+
	lalonde$nodegr, data=lalonde, method="exact", ratio=1)
	
	m.out5
	
  ## What do you notice about the number of control versus treated units using exact matching?

####################################
####     Diagnosing Matches     ####
####################################

  ## Let's again diagnose the quality of matches for optimal matching and exact matching. 

  ## VISUAL DIAGNOSIS ##

  ## Several visual aids are available via the MatchIt package in R to diagnose the 
  ## quality of matches visually. For example, we can plot jitter graphs and 
  ## histograms to examine the balance of the matched treatment (participants) 
  ## and control (nonparticipants). First, let's save our final matched data sets.

	Optimal<-match.data(m.out4) 
	Exact<-match.data(m.out5)
	
	plot(m.out4, type = "jitter") 

	plot(m.out4, type = "hist")
	
	plot(m.out4, type = "QQ") 
	
  ## We can also compare the density distributions for each covariate before matching vs. after matching. 

	qplot(age, data = lalonde, geom = "density", fill = as.factor(treat), alpha=I(.5),
	main = "Density of Age BEFORE Matching by Group", xlab = "Age (in years)", ylab = "Density")
	
	qplot(age, data = Optimal, geom = "density", fill = as.factor(treat), alpha=I(.5),
	main = "Density of Age AFTER Matching by Group", xlab = "Age (in years)", ylab = "Density")
	
	
  ## NUMERIC DIAGNOSIS ##

  ## We should also evaluate the numeric balance between groups both univariately and
  ## multivariately (i.e., on each covariate and on the propensity score). To evaluate
  ## the quality of matches numerically, the describe() function can be used.

	describe(Optimal)
	
	head(Optimal)
	
	summary(Optimal)
	
	summary(m.out4)
	
	summary(m.out4, standardize=T)
	
  ## As mentioned earlier in the presentation, we want the individal covariates 
  ## for both groups to be within one fourth of a standard deviation of each other, 
  ## and the same for the propensity scores. We also want both groups to have roughly
  ## the same spread of scores, and we can check that by dividing the variance of  
  ## one group's propensity scores by the variance of the others -- we want this 
  ## ratio to be close to one, indicating that the groups are similar in their
  ## spread of scores. 


####################################
####       Saving Out Data      ####
####################################
 
  ## Finally, we can save out the new propensity scores (in logits) into a final data set. 

	write.table(NN,file="FinalData.csv",sep=",",row.names=FALSE)



