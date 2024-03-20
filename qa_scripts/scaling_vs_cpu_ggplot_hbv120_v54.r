library(ggplot2)
library(patchwork) # To display 2 charts together
library(ggrepel) # To add labels for the number of nodes

# Script author: Liz Adams
# Affiliation: UNC CMAS Center 
# example from http://monashbioinformaticsplatform.github.io/2015-11-30-intro-r/ggplot.html
# 2nd example from https://r-graph-gallery.com/line-chart-dual-Y-axis-ggplot2.html

curr_wd<-getwd()
setwd(curr_wd)
png(file = paste('hbv120_v54_beeond','_','Scaling','_','Cores','.png',sep=''), width = 1024, height = 768, bg='white')
csv_data<- read.csv("../docs/user_guide_cyclecloud/qa/scaling_HBv120.v54.csv",sep="\t", skip =0, header = TRUE, comment.char = "",check.names = FALSE, quote="", )
print(csv_data)
bad_rows <-
    is.na(csv_data$Cores) |
    is.na(csv_data$Scaling) |
    is.na(csv_data$Efficiency) |
    is.na(csv_data$MS_Opt_Pin)
p1 <- ggplot(csv_data[!bad_rows,], aes(y=Scaling, x=Cores,  group=interaction(ComputeNode,InputData), color=interaction(ComputeNode,InputData), shape=ComputeNode)) +
    geom_point() + ggtitle("2 Day Benchmark Scaling versus Cores using HB120rs_v3") +  scale_y_continuous(name = "Scaling") + stat_smooth(method="lm") + geom_point(size=3.0) + geom_label_repel(aes(label = Nodes))


p2 <- ggplot(csv_data[!bad_rows,], aes(y=Efficiency, x=Cores,  group=interaction(ComputeNode,InputData), color=interaction(ComputeNode,InputData), shape=ComputeNode )) +
    geom_point() + ggtitle("2 Day Benchmark Parallel Efficiency versus Cores using HB120rs_v3") + geom_line(size=1.5) + stat_smooth(method="lm") + geom_point(size=3.0) + geom_label_repel(aes(label = Nodes))

# Display both charts side by side thanks to the patchwork package
#p1 + geom_abline(intercept = 0, slope = .0552) + p2
p1
