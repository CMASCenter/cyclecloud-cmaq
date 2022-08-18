library(ggplot2)
library(patchwork) # To display 2 charts together

# Script author: Liz Adams
# Affiliation: UNC CMAS Center 
# example from http://monashbioinformaticsplatform.github.io/2015-11-30-intro-r/ggplot.html
# 2nd example from https://r-graph-gallery.com/line-chart-dual-Y-axis-ggplot2.html

curr_wd<-getwd()
setwd(curr_wd)
png(file = paste('hbv120','_','Scaling','_','CPUs','.png',sep=''), width = 1024, height = 768, bg='white')
csv_data<- read.csv("../docs/user_guide_cyclecloud/qa/scaling_HBv120.update6.csv",sep="\t", skip =0, header = TRUE, comment.char = "",check.names = FALSE, quote="", )
print(csv_data)
bad_rows <-
    is.na(csv_data$CPUs) |
    is.na(csv_data$Scaling) |
    is.na(csv_data$Efficiency) |
    is.na(csv_data$MS_Opt_Pin)
p1 <- ggplot(csv_data[!bad_rows,], aes(y=Scaling, x=CPUs, color=MS_Opt_Pin, size=ComputeNode)) +
    geom_point() + ggtitle("2 Day Benchmark Scaling versus CPU using HBv120") +  xlim(0,400) + ylim(0,55)


p2 <- ggplot(csv_data[!bad_rows,], aes(y=Efficiency, x=CPUs, color=MS_Opt_Pin, size=ComputeNode)) +
    geom_point() + ggtitle("2 Day Benchmark Parallel Efficiency versus CPU using HBv120")

# Display both charts side by side thanks to the patchwork package
p1 + geom_abline(intercept = 0, slope = .0552) + p2
