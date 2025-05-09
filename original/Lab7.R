## STAT318/462 Lab7: Clustering 
#
# In this lab you will work through Section 10.5 of the course
# textbook, An Introduction to Statistical Learning (there is a
# link to this textbook on the Learn page). The R code from 
# Section 8.3 is given below. I have added R code for computing 
# the silhouette coefficient and distance matrices.


################ K-Means Clustering ########################################

# Construct a dataset to cluster
set.seed(2)
x=matrix(rnorm(50*2), ncol=2)
x[1:25,1]=x[1:25,1]+3
x[1:25,2]=x[1:25,2]-4
plot(x)

# Cluster the data (k=2)
km.out=kmeans(x,2,nstart=20)
km.out$cluster
plot(x, col=(km.out$cluster+1), main="K-Means Clustering Results with K=2", xlab="", ylab="", pch=20, cex=2)

# Cluster the data (k=3)
set.seed(4)
km.out=kmeans(x,3,nstart=20)
km.out
plot(x, col=(km.out$cluster+1), main="K-Means Clustering Results with K=3", xlab="", ylab="", pch=20, cex=2)

# Cluster the data (k=3, multiple restarts)
set.seed(3)
km.out=kmeans(x,3,nstart=1)
km.out$tot.withinss
km.out=kmeans(x,3,nstart=100)
km.out$tot.withinss
plot(x, col=(km.out$cluster+1), main="K-Means Clustering Results with K=3", xlab="", ylab="", pch=20, cex=2)
#s <- silhouette(km.out$cluster, dist(x))
#plot(s)



# silhouette coefficient
library(cluster)
silval <- rep(0, 9)
for (k in 2:10) {
C <- kmeans(x,k,nstart=20)
s <- silhouette(C$cluster, dist(x))
xx <- summary(s)
silval[k-1] <- xx$avg.width
}
plot(2:10,silval,xlab="k",type="b")

############### Hierarchical Clustering #####################################

# computing a distance matrix
EG = matrix(c(1,2,6,2,3,1,1,3,4,5),nrow=5,ncol=2)
EG
dist(EG,'manhattan',diag = TRUE, upper = TRUE)

## Hierarchically cluster the data using the three linkage methods
hc.complete=hclust(dist(x), method="complete")
hc.average=hclust(dist(x), method="average")
hc.single=hclust(dist(x), method="single")

# Plot the three dendrograms on the same plot
par(mfrow=c(1,3))
plot(hc.complete,main="Complete Linkage", xlab="", sub="", cex=.9)
plot(hc.average, main="Average Linkage", xlab="", sub="", cex=.9)
plot(hc.single, main="Single Linkage", xlab="", sub="", cex=.9)

dev.off()
# Cut the trees to define clusters
cutree(hc.complete, 2)
plot(x,col = cutree(hc.complete, 2))
plot(x,col = cutree(hc.average, 2))
plot(x,col = cutree(hc.single, 2))
plot(x,col = cutree(hc.single, 4))


################ Another simulated data set to play with ##################


## This function generates bivariate normal RVs
rbivariate <- function(mean.x = 0, sd.x=1, mean.y=0, sd.y=1, r=0, n=100) {
   z1 <- rnorm(n)
   z2 <- rnorm(n)
   x <- sqrt(1-r^2)*sd.x*z1 + r*sd.x*z2 + mean.x
   y <- sd.y*z2 + mean.y
   return(cbind(x,y))
}

## Here is a simulated data set 
set.seed(10)
c1 = rbivariate(mean.x=1.5,sd.x=.1,mean.y=.5,sd.y=.1,n=50)
c2 = rbivariate(mean.x=0,sd.x=.5,mean.y=0,sd.y=.5,n=200)
c3 = rbivariate(mean.x=1.5,sd.x=.1,mean.y=-.5,sd.y=.1,n=50)
mydata = rbind(c1,c2,c3)
plot(mydata)

# apply k-means
km.out=kmeans(mydata,3)
km.out$tot.withinss
plot(mydata, col=(km.out$cluster+1), main="K-Means Clustering Results with K=3", xlab="", ylab="", pch=20, cex=2)

# apply k-means with 1000 restarts (k=3)
km.out=kmeans(mydata,3,nstart=1000)
km.out$tot.withinss
plot(mydata, col=(km.out$cluster+1), main="K-Means Clustering Results with K=3", xlab="", ylab="", pch=20, cex=2)

# silhouette coefficient
library(cluster)
silval <- rep(0, 9)
for (k in 2:10) {
C <- kmeans(mydata,k,nstart=100)
s <- silhouette(C$cluster, dist(mydata))
xx <- summary(s)
silval[k-1] <- xx$avg.width
}
plot(2:10,silval,type="b")

# apply k-means with 100 restarts (k=7)
km.out=kmeans(mydata,7,nstart=100)
km.out$tot.withinss
plot(mydata, col=(km.out$cluster+1), main="K-Means Clustering Results with K=7", xlab="", ylab="", pch=20, cex=2)

# specify the 'correct' ceneters
km.out=kmeans(mydata,centers=rbind(c(1.5,0.5),c(0,0),c(1.5,-0.5)),nstart=100)
km.out$tot.withinss
plot(mydata, col=(km.out$cluster+1), main="K-Means Clustering Results with K=3", xlab="", ylab="", pch=20, cex=2)


## What about hierarchical clustering?
hc.complete=hclust(dist(mydata), method="complete")
plot(hc.complete,main="Complete Linkage", xlab="", sub="", cex=.9)
plot(mydata, col=cutree(hc.complete, 3))

hc.single=hclust(dist(mydata), method="single")
plot(hc.complete,main="Single Linkage", xlab="", sub="", cex=.9)
plot(mydata, col=cutree(hc.single, 3))

hc.average=hclust(dist(mydata), method="average")
plot(hc.complete,main="Average Linkage", xlab="", sub="", cex=.9)
plot(mydata, col=cutree(hc.average, 3))



