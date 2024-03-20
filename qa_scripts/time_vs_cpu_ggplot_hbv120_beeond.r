library(ggplot2)
library(patchwork) # To display 2 charts together
library(dplyr)
library(ggrepel)

# Script author: Liz Adams
# Affiliation: UNC CMAS Center 
# example from http://monashbioinformaticsplatform.github.io/2015-11-30-intro-r/ggplot.html
# 2nd example from https://r-graph-gallery.com/line-chart-dual-Y-axis-ggplot2.html

png(file = paste('hbv120', '_', 'v5.4plus', '_','Time','_','CPUs','.png',sep=''), width = 1024, height = 768, bg='white')
curr_wd<-getwd()
setwd(curr_wd)
csv_data<- read.csv("../docs/user_guide_cyclecloud/qa/scaling_HBv120.v54.csv",sep="\t", skip =0, header = TRUE, comment.char = "",check.names = FALSE, quote="", )
print(csv_data)
bad_rows <-
    is.na(csv_data$TotalTime) |
    is.na(csv_data$Day1_Timing_sec) |
    is.na(csv_data$CPUs) |
    is.na(csv_data$OnDemandCost) |
    is.na(csv_data$MS_Opt_Pin) |
    is.na(csv_data$SpotCost) 
    
#filter(csv_data, ComputeNode != "HB120rs_v3" )

csv_data2 <-  subset(csv_data, InputData=="Beeond")
print(csv_data2)




p1 <- ggplot(csv_data[!bad_rows,], aes(y=as.numeric(TotalTime), x=CPUs, group=interaction(ComputeNode,InputData), color=interaction(ComputeNode,InputData), shape=ComputeNode,)) +
    geom_point() + ggtitle("2 Day Benchmark Total Time versus CPUs") + scale_y_continuous(name = "Total Time (seconds)") + stat_smooth(method="lm") + geom_point(size=3.0) + geom_label_repel(aes(label = Nodes))

p2 <- ggplot(csv_data[!bad_rows,], aes(y=as.numeric(OnDemandCost), x=CPUs, group=interaction(ComputeNode,InputData), color=interaction(ComputeNode,InputData), shape=ComputeNode,  )) +
    geom_point() + ggtitle("2 Day Benchmark On Demand Cost versus CPUs") + scale_y_continuous(name = "On Demand Cost ($)") + stat_smooth(method="lm") + geom_point(size=3.0) + geom_label_repel(aes(label = Nodes))

p3 <- ggplot(csv_data[!bad_rows,], aes(y=as.numeric(SpotCost), x=CPUs, group=InputData, color=InputData)) +
    geom_point() + ggtitle("2 Day Benchmark Spot Cost versus CPUs") + scale_y_continuous(name = "On Demand Cost ($)") + stat_smooth(method="lm") + geom_path(linewidth = 1)

# Display both charts side by side thanks to the patchwork package
p1 + p2 
