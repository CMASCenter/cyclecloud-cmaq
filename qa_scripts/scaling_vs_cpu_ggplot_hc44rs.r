library(ggplot2)
library(patchwork) # To display 2 charts together

# Script author: Liz Adams
# Affiliation: UNC CMAS Center 
# example from http://monashbioinformaticsplatform.github.io/2015-11-30-intro-r/ggplot.html
# 2nd example from https://r-graph-gallery.com/line-chart-dual-Y-axis-ggplot2.html

curr_wd<-getwd()
setwd(curr_wd)
png(file = paste('hc44rs','_','Scaling','_','CPUs','.png',sep=''), width = 1024, height = 768, bg='white')
csv_data<- read.csv("../docs/user_guide_cyclecloud/qa/scaling_HC44rs.csv",sep="\t", skip =0, header = TRUE, comment.char = "",check.names = FALSE, quote="", )
print(csv_data)
p1 <- ggplot(csv_data, aes(y=Scaling, x=CPUs, size=Nodes, color=COLROW)) +
    geom_point() + ggtitle("2 Day Benchmark Scaling versus CPU using HC44rs") +  xlim(0,288) + ylim(0,16)
    

p2 <- ggplot(csv_data, aes(y=Efficiency, x=CPUs, size=Nodes, color=COLROW)) +
    geom_point() + ggtitle("2 Day Benchmark Parallel Efficiency versus CPU using HC44rs")

# Display both charts side by side thanks to the patchwork package
p1 + geom_abline(intercept = 0, slope = .0555) + p2
