### We look at using K-mean cluster to classify NZ land parcels into four clusters

# Load in the data
data <- read.csv("aims-address-position.csv")

# Load in google map API, and get the region we need
library("ggmap")
register_google(key="AIzaSyATSrQE8GK7gU6JyT7oo7XtQKYmXcbkqZs")
NZMap <- get_map("New Zealand", zoom=5)

set.seed(20)
# Perform K-mean on the whole dataset
clusters <- kmeans(data[,8:9], 4)
data$Region <- as.factor(clusters$cluster)

set.seed(123)
# For visualsization, only need to plot 5% of the total data points. Otherwise plotting takes too long.
train_ind <- sample(seq_len(nrow(data)), size = 100000) 
datasub = data[train_ind,]

str(clusters)

# Plot out locations of land parcels
ggmap(NZMap) + geom_point(aes(x = shape_X, y = shape_Y),data = datasub,colour = "blue") +
  ggtitle("New Zealand Land Title Location") + xlim(165,180) + ylim(-47,-34)

cent = data.frame(clusters$centers)

# Plot out 4 clusters found by k-mean algorithm
ggmap(NZMap) + geom_point(aes(x = shape_X, y = shape_Y, colour = as.factor(Region)),data = datasub) +
  geom_point(aes(x=shape_X,y=shape_Y),data=cent,colour=c(5,4,2,1),pch=8,size=10) +
     ggtitle("New Zealand Land Title Location Using KMean") + xlim(165,180) + ylim(-47,-34)



