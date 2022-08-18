library(ggplot2)
library(patchwork) # To display 2 charts together
library(dplyr)

# Script author: Liz Adams
# Affiliation: UNC CMAS Center 
# example from http://monashbioinformaticsplatform.github.io/2015-11-30-intro-r/ggplot.html
# 2nd example from https://r-graph-gallery.com/line-chart-dual-Y-axis-ggplot2.html

png(file = paste('hbv120','_','Cost','_','TotalTime','.png',sep=''), width = 1024, height = 768, bg='white')
curr_wd<-getwd()
setwd(curr_wd)
csv_data<- read.csv("../docs/user_guide_cyclecloud/qa/scaling_HBv120.update6.csv",sep="\t", skip =0, header = TRUE, comment.char = "",check.names = FALSE, quote="", )
print(csv_data)
bad_rows <-
    is.na(csv_data$TotalTime) |
    is.na(csv_data$Day1_Timing_sec) |
    is.na(csv_data$CPUs) |
    is.na(csv_data$OnDemandCost) |
    is.na(csv_data$MS_Opt_Pin) |
    is.na(csv_data$SpotCost)
    
#filter(csv_data, ComputeNode != HC44rs )

csv_data2 <-  subset(csv_data, ComputeNode=="HB120"&InputData=="/data NetApp")


p1 <- ggplot(csv_data2[!bad_rows,], aes(y=OnDemandCost, x=TotalTime, size=Nodes, color=MS_Opt_Pin)) +
    geom_point() + ggtitle("2 Day Benchmark OnDemandCost versus Total Time") + scale_y_continuous(name = "OnDemand Cost ($)") + stat_smooth(method="lm")

p2 <- ggplot(csv_data2[!bad_rows,], aes(y=TotalTime, x=CPUs, size=Nodes, color=MS_Opt_Pin)) +
    geom_point() + ggtitle("2 Day Benchmark TotalTime versus CPUs") + scale_y_continuous(name = "TotalTime (sec)") + stat_smooth(method="lm")

# Display both charts side by side thanks to the patchwork package
p1 + p2
