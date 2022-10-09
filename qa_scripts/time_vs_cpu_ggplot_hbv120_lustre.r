library(ggplot2)
library(patchwork) # To display 2 charts together
library(dplyr)

# Script author: Liz Adams
# Affiliation: UNC CMAS Center 
# example from http://monashbioinformaticsplatform.github.io/2015-11-30-intro-r/ggplot.html
# 2nd example from https://r-graph-gallery.com/line-chart-dual-Y-axis-ggplot2.html

png(file = paste('hbv120','_','Time','_','CPUs','_lustre','.png',sep=''), width = 1024, height = 768, bg='white')
curr_wd<-getwd()
setwd(curr_wd)
csv_data<- read.csv("../docs/user_guide_cyclecloud/qa/scaling_HBv120_lustre.csv",sep="\t", skip =0, header = TRUE, comment.char = "",check.names = FALSE, quote="", )
print(csv_data)
#filter(csv_data, ComputeNode != HC44rs )

#csv_data2 <-  subset(csv_data, ComputeNode=="HB120"&InputData=="/data NetApp")
csv_data2 <- csv_data


p1 <- ggplot(csv_data2, aes(y=TotalTime, x=CPUs, size=InputData, color=COLROW, shape=Nodes_CPU)) +
    geom_point() + ggtitle("2 Day Benchmark Total Time versus CPUs") + scale_y_continuous(name = "Total Time (seconds)") + stat_smooth(method="lm")

p2 <- ggplot(csv_data2, aes(y=OnDemandCost, x=CPUs, size=InputData, color=COLROW, shape=Nodes_CPU)) +
    geom_point() + ggtitle("2 Day Benchmark On Demand Cost versus CPUs") + scale_y_continuous(name = "On Demand Cost ($)") + stat_smooth(method="lm")

# Display both charts side by side thanks to the patchwork package
p1 + p2
