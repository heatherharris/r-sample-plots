
#### Example 1: Using axis()
normal <- rnorm(n=50000000, mean=0, sd=1)

# Make margins around plot equal to
# x lines of text, in this order:
# bottom margin, left, top, right
par(mar=c(19,3,3,1),
	mgp=c(-1.4,.5,0)) #This line pulls axis labels closer to the plot
#?plot()
plot(density(x = normal, n=1000000),
	main="Normal Curve",
	xlab=" ",
	frame.plot=FALSE, axes=FALSE, ylab=" ", abline(v=c(-4, -3, -2,-1,0,1,2, 3, 4)),#, h=.053), 
	lty=1
)
mtext(text="Percent of Cases", side=1, at=-5, line=-3.75)
mtext(text="Under Portions of", side=1, at=-5, line=-2.75)
mtext(text="the Normal Curve", side=1, at=-5, line=-1.75)
mtext(text= "Standard   Deviations", side=1, at=0.05, line=-1.5)

mtext(text="0.13%", side=1, at=-3.5, line=-3.7)
mtext(text="2.14%", side=1, at=-2.5, line=-3.7)
mtext(text="13.59%", side=1, at=-1.5, line=-3.7)
mtext(text="34.13%", side=1, at=-.5, line=-3.7)
mtext(text="34.13%", side=1, at=.5, line=-3.7)
mtext(text="13.59%", side=1, at=1.5, line=-3.7)
mtext(text="2.14%", side=1, at=2.5, line=-3.7)
mtext(text="0.13%", side=1, at=3.5, line=-3.7)
# Tick marks for under the above values
#mtext(text="|", side=1, at=-3.5, line=-1.8)
#mtext(text="|", side=1, at=-2.5, line=-1.8)
#mtext(text="|", side=1, at=-1.5, line=-1.8)
#mtext(text="|", side=1, at=-.5, line=-1.8)
#mtext(text="|", side=1, at=.5, line=-1.8)
#mtext(text="|", side=1, at=1.5, line=-1.8)
#mtext(text="|", side=1, at=2.5, line=-1.8)
#mtext(text="|", side=1, at=3.5, line=-1.8)

# Add another axis parallel to x-axis for z-scores:
axis(side=1, line=-.5, 
	at=c(-4,-3,-2,-1,0,"+1","+2","+3","+4"), 
		#Where you want tick marks
	labels=c(-4,-3,-2,-1,0,1,2,3,4))
		#Labels for tick marks
# Add text label next to axis
mtext(text="z-scores", side=1, at=-5, line=-.5)

# Add another axis parallel to x-axis for T-scores:
axis(side=1, line=1.5, 
	at=c(-4,-3,-2,-1,0,1,2,3,4), 
		#Where you want tick marks
	labels=c(0,20,30,40,50,60,70,80,100))
		#Labels for tick marks
# Add text label next to axis
mtext(text="T-scores", side=1, at=-5, line=1.5)


# Add another axis parallel to x-axis for cumulative
# percentages:
axis(side=1, line=3.5, 
	at=c(-4,-3,-2,-1,0,1,2,3,4),
		#Where you want tick marks
	labels=c(0,0.1,2.3,15.9,50,84.1,97.7,99.9,100))
		#Labels for tick marks
# Add text label next to axis
mtext(text="Cumulative %s", side=1, at=-5, line=3.5)

# Add another axis parallel to x-axis for Whatever:

axis(side=1, line=5.5, 
	at=c(-4,-2.3,-1.7,-1.25,-.85,-.55,-.25,0,.25,.55,.85,1.25,1.7,2.3,4),
		#Where you want tick marks
	labels=c(" ",1,5,10,20,30,40,50,60,70,80,90,95,99," "))
		#Labels for tick marks
# Add text label next to axis
mtext(text="Percentile Rank", side=1, at=-5, line=5.5)

# Add another axis parallel to x-axis for SAT Scores:
axis(side=1, line=7.5, 
	at=c(-4,-3,-2,-1,0,1,2,3,4),
		#Where you want tick marks
	labels=c(" ",200,300,400,500,600,700,800," "))
		#Labels for tick marks
# Add text label next to axis
mtext(text="SAT Scores", side=1, at=-5, line=7.5)

# Add another axis parallel to x-axis for NCE scores:
axis(side=1, line=9.5, 
	at=c(-4,-2.3,-1.88,-1.4,-.92,-.45,0,.45,.92,1.4,1.88,2.3,4),
		#Where you want tick marks
	labels=c(" ",1,10,20,30,40,50,60,70, 80, 90, 99, " "))
		#Labels for tick marks
# Add text label next to axis
mtext(text="NCE Scores", side=1, at=-5, line=9.5)

#mtext(text="|", side=1, at=-4, line=10.5)
#mtext(text="|", side=1, at=-3, line=10.5)
#mtext(text="|", side=1, at=-2, line=10.5)
#mtext(text="|", side=1, at=-1, line=10.5)
#mtext(text="|", side=1, at=0, line=10.5)
#mtext(text="|", side=1, at=1, line=10.5)
#mtext(text="|", side=1, at=2, line=10.5)
#mtext(text="|", side=1, at=3, line=10.5)
#mtext(text="|", side=1, at=4, line=10.5)

# Add another axis parallel to x-axis for stanines:
#axis(side=1, line=11.5, 
	#at=c(-4,-1.75,-1.25,-.75,-.25,.25,.75,1.25,1.75,4),
		#Where you want tick marks
	#labels=c(" ",1,2,3,4,5,6,7,8,9))
		#Labels for tick marks
# Add text label next to axis
mtext(text="Stanines", side=1, at=-5, line=11.5)

# Add another axis parallel to x-axis for percent in stanines:
#axis(side=1, line=12.5, 
	#at=c(-4,-2.875,-1.5,-1,-.5,0,.5,1,1.5,2.875,4),
		#Where you want tick marks
	#labels=c(" ","4%","7%","12%","17%","20%","17%","12%","7%", "4%"," "))
		#Labels for tick marks
# Add text label next to axis
#mtext(text="% in Stanines", side=1, at=-5, line=12.5)

mtext(text=c("1","2","3","4","5","6","7","8", "9"), line = 11.5, side=1, at = c(-2.875,-1.5,-1,-.5,0,.5,1,1.5,2.875))

mtext(text=c("4%","7%","12%","17%","20%","17%","12%","7%", "4%"), ps=6, line = 13, side=1, at = c(-2.875,-1.5,-1,-.5,0,.5,1,1.5,2.875))


# Add another axis parallel to x-axis for Deviation IQs:
axis(side=1, line=15, 
	at=c(-4,-3,-2,-1,0,1,2,3,4),
		#Where you want tick marks
	labels=c(15,55,70,85,100,115,130,145,160))
		#Labels for tick marks
# Add text label next to axis
mtext(text="IQ Scores", side=1, at=-5.2, line=14)
mtext(text="(Stanford-Binet and", side=1, at=-5.2, line=15)
mtext(text= "Weschler scales)", side=1, at = -5.1, line=16)
axis(side=1, line=17.5, at=c(-4,-3,-2,-1,0,1,2,3,4)



################################Did not use below code, but could in the future############################.

#### Example with multiple plots:
par(mfrow=c(3,1), mgp=c(2,1,0),
	mar=c(3,3,3,1))
plot(density(normal),
	main="Normal Curve",
	xlab="Original Scores")

# Empty plot for z-score axis
# Get z-scores first (not needed if scores already z-scale)
Znormal <- scale(normal, center=TRUE, scale=TRUE)
ZnormalDensity <- density(Znormal)
AllZeros <- rep(0,times=length(ZnormalDensity$x))
plot(x=ZnormalDensity$x, y=AllZeros, 
	type="n",
	xlab="z-scores",
	ylab="",
	bty="n",
	xaxt="n", yaxt="n")
# Axis for z-scores
axis(side=1,	
	at=c(-4,-3,-2,-1,0,1,2,3,4),
		#Where you want tick marks
	labels=c(-4,-3,-2,-1,0,1,2,3,4))
		#Labels for tick marks
# Adding vertical lines for z-scores
abline(v=c(-4,-3,-2,-1,0,1,2,3,4))

# Empty plot for Percentages axis
plot(x=ZnormalDensity$x, y=AllZeros, 
	type="n",
	xlab="Cumulative %",
	ylab="",
	bty="n",
	xaxt="n", yaxt="n")
# Axis for z-scores
axis(side=1, 
	at=c(-4,-3,-2,-1,0,1,2,3,4),
		#Where you want tick marks
	labels=c(0,0.1,2.3,15.9,50,84.1,97.7,99.9,100))
		#Labels for tick marks
# Adding vertical lines for z-scores
abline(v=c(-4,-3,-2,-1,0,1,2,3,4))

x <- sample(1:100, 10, replace = T) # just 10 random numbers
y <- sample(1:100, 10, replace = T) # 10 more random numbers
par(mar = c(10, 5, 5, 5)) 
    # increasing the 1st number to 10 makes 10 lines below axis 1
plot(x~y) # normal plot
axis(1, at = c(20, 40, 60, 80), labels = c("1", "2", "3", "4"), line = 5, col = 4) 
    # the "line" indicates which of the 10 lines made above to put the axis on




