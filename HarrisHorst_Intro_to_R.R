#########################################################
#########################################################
##				Introduction to R					   
##		  NERA Propensity Score Analyses Workshop      
##				October 27, 2016					   
##											           
##	         Heather Harris & Jeanne Horst		       
##			   James Madison University				   
#########################################################
#########################################################


  ## Because R uses only scripts (i.e., syntax), it is important
  ## to take notes and organize the script in a way you can easily 
  ## understand. 

  ## Comments are a great way of organizing a script. The "#" sign 
  ## denotes comments and the R program will recognize them as such.
  ## Thus, nothing following a "#" on the same line will be run as a
  ## command. 

  ## To actually "run" the script, press Ctrl and R for PCs OR 
  ## Command and Enter on Macs.


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

	setwd("C:/Users/heatherdawnharris/Dropbox/NERA PSM Workshop/Workshop Materials/Intro to R")

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


  ## The "foreign" package allows us to open data saved in different formats
  ## (e.g., SAS and SPSS files). 

	install.packages("foreign")

  ## The "psych" package includes useful tools for social science statistics.

	install.packages("psych")

  ## Other packages offer several packages in one, like the "Hmisc" package. 
  ## We'll look at what's included in the Hmisc package in a minute. 

	install.packages("Hmisc")



#####################################
######     Loading Packages    ######
#####################################

  ## Next, we need to load (or "require") the downloaded packages 
  ## in order to use them. Downloading packages is similar to downloading
  ## a software program on our computer -- we still need to open it to 
  ## start running the program. 

	require(foreign)

	require(psych)

	require(Hmisc)

  ## Notice that the package name is no longer in quotations. 


#####################################
######    Help for Packages    ######
#####################################

  ## Each package also has a help page that is formatted in relatively
  ## the same way. The help page lets us know what functions are included
  ## in that package and the arguments for each function. Let's run each
  ## of the below commands to briefly look at the help pages for one of
  ## the packages we just installed. 

	?psych()

  ## For the other two packages, we might need to search for information about
  ## the packages online. 

  ## On Macs, you can include working hyperlinks to resources within your scripts
  ## (sadly, not with PCs)

  https://cran.r-project.org/web/packages/Hmisc/index.html 


#####################################
######    Creating Objects     ######
#####################################

  ## R evolved as an "object oriented" programming language, which basically
  ## means that we have set "objects" that we work with in the program. 

  ## Objects can be numeric values, vectors (similar to columns or rows), 
  ## matrices, data frames, or lists. For example, let's run the below line
  ## of code to "set" 4 to be called "Object1". We "set" things as objects by 
  ## using the "gets" sign <- 

	Object1<-4

  ## We can then see the contents of Object1 by simply running the object's name.

	Object1

  ## We can also use R for calculations. For example, the below line adds ten 
  ## to Object1, then places the answer into a new object called "Answer."

	Answer<-Object1 + 10

	Answer

  ## If we want to place multiple numbers in an object, we can use the "combine"
  ## function c().	

	Object2<-c(4, 4, 5, 5, 6, 6)

	Object2

  ## What do you think will happen if we run the below code?

	Object3<-c(6, 6, 5, 5, 4, 4)

	Object3
	
	Tom<-("stellar")
	
	Tom

	NewObject<-c(Object2, Object3)

	NewObject


#####################################
######      Loading Data       ######
#####################################

  ## The "foreign" package allows us to pull in data saved in various formats.
  ## Below are a few examples of how we could pull in data from SPSS, SAS or 
  ## csv files and store the data sets as new objects. 

	mydata1 <- spss.get("Name_of_File.sav", use.value.labels=TRUE)

	mydata2 <- read.table("Name_of_File.csv", sep=",")

	mydata5 <-read.sas7bdat("Name_of_File.sas7bdat")

  ## Some of the functions we used above have additional arguments. For 
  ## example, the below code reads in a CSV file with headers indicated
  ## by the "header=TRUE" argument in the function. Also note that TRUE
  ## is in all caps -- this is because arguments that are set to either 
  ## "TRUE" or "FALSE" must always be written in all caps. 

	mydata3 <- read.table("Name_of_File.csv", header=TRUE, sep=",")

  ## The below code reads in data from Excel. Note that the "1" indicates
  ## data should only be read in from the first sheet of the document. 
	
	mydata4 <-read.xlsx("Name_of_File.xlsx",1)


#####################################
######       Free Data!        ######
#####################################

  ## R also has a lot of data sets freely available for anyone to use. 
  ## For example, to look at the number of data sets available on the 
  ## CRAN servers, let's run the below line of code:

	?data()

  ## To pull in a data set from the psych package, we simple need to use
  ## the data() function to open it. Let's use the Big Five data set as
  ## an example.

	data(bfi)


#####################################
######      Checking Data      ######
#####################################

  ## Once the data is read into R, it is important for us to make sure it
  ## read in correctly. Remember we can use just the object name to see all
  ## of the contents stored in that object. However, some data sets might be
  ## quite large (like bfi). 

	bfi

  ## When we're working with large data sets, we may wish to look at the first few 
  ## cases (rows) and the last few cases to make sure the data was read in correctly.
  ## We can do this using the head() and tail() functions in R (base program). 

	head(bfi)
	?head()

	tail(bfi)

  ## Another way of checking our data is to look at the structure using the str() 
  ## function and the descriptive statistics using the describe() function. 

	str(bfi)

	describe(bfi)
	
	summary(bfi)


#####################################
######    Manipulating Data    ######
#####################################

  ## Similar to SAS and SPSS, we can also reformat and manipulate data in
  ## the R environment. For example, we concatenated data when we used the 
  ## combine function c() in our earlier example.  
	

  ## We can also use functions like apply(). To learn what the apply function
  ## can do, we can again look at the help page. 

	?apply()

  ## Let's try to create a subscore for agreeableness using the below line of syntax and save it as a new object. 
   
  ## First, we want to select only the first five elements of our data set using brackets:
    
    bfi[,1:5]
    
  ## Next, we can use the apply() function to create a summed score. 
	
	apply(bfi[,1:5], 1, sum)
	
  ## Finally, we can save the total agreeableness scores as a new column in our data set. 
  
     bfi$AgrTotal<-apply(bfi[,1:5], 1, sum)
    
  ## How could we check to make sure it worked?
     head(bfi)
     tail(bfi)
     sum(c(4,5,6))

  ## We may also wish to reformat our data to a data frame. This is a structure
  ## that statistical functions will easily recognize as a data set. Our example
  ## data set is already formatted as a data frame; however, the below code is what
  ## we would run if it wasn't. 

	mydata<-as.data.frame(bfi)

  ## Although data management in R is outside the scope of the current workshop,
  ## additional information on how to reformat and manipulate data can be found in
  ## the R packet included in the workshop materials. 


    Name<-c("Hello"," World!")










