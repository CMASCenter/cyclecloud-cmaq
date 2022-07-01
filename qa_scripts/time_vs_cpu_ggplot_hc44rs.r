library(ggplot2)
library(patchwork) # To display 2 charts together

# Script author: Liz Adams
# Affiliation: UNC CMAS Center 
# example from http://monashbioinformaticsplatform.github.io/2015-11-30-intro-r/ggplot.html
# 2nd example from https://r-graph-gallery.com/line-chart-dual-Y-axis-ggplot2.html

#setwd("/proj/ie/proj/CMAS/CMAQ/cyclecloud-cmaq/qa_scripts/")
curr_wd<-getwd()
setwd(curr_wd)

png(file = paste('hc44rs','_','Time','_','CPUs','.png',sep=''), width = 1024, height = 768, bg='white')
csv_data<- read.csv("../docs/user_guide_cyclecloud/qa/scaling_HC44rs.csv",sep="\t", skip =0, header = TRUE, comment.char = "",check.names = FALSE, quote="", )
print(csv_data)
p1 <- ggplot(csv_data, aes(y=TotalTime, x=CPUs, size=Nodes, color=COLROW)) +
    geom_point() + ggtitle("2 Day Benchmark Total Time versus CPUs") + scale_y_continuous(name = "Total Time (seconds)")

p2 <- ggplot(csv_data, aes(y=OnDemandCost, x=CPUs, size=Nodes, color=COLROW)) +
    geom_point() + ggtitle("2 Day Benchmark On Demand Cost versus CPUs") + scale_y_continuous(name = "On Demand Cost ($)")

# Display both charts side by side thanks to the patchwork package
p1 + p2
