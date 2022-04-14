# Script author: Liz Adams
# Affiliation: UNC CMAS Center 

csv_data<-read.csv("/shared/cyclecloud-cmaq/docs/user_guide_cyclecloud/timing_hc44rs.csv",sep="\t", skip =0, header = TRUE, comment.char = "",check.names = FALSE, quote="", )
print(csv_data)

# ------------- Do not change below unless modifying for a different workflow ---------------------


# plot data
   png(file = paste('HC44rs','_','Time','_','Cost','_','CPUs','.png',sep=''), width = 1024, height = 768, bg='white')
   x <- csv_data$CPUs
   y1 <- csv_data$TotalTime
   y2 <- csv_data$OnDemandCost
   labels <- csv_data$NodesbyCPU

# Draw first plot using axis y1
# sets the bottom, left, top and right margins respectively of the plot region in number of lines of text, + 0.2 gives extra room on the right margin for second legend.
par(mar = c(7, 5, 5, 4) + 0.2) 

plot(x, y1, pch = 13, col = 2, xlab = "CPUs", ylab = "2 Day Total Time (sec)", main = "CMAQv533 Benchmark 2 Day Run Time (seconds) and OnDemand Cost vs CPUs on Cyclecloud using HC44rs Compute Nodes")

text(x, y1, labels, cex=0.65, pos=3,col="black")

# set parameter new=True for a new axis
par(new = TRUE)  

# Draw second plot using axis y2
plot(x, y2, pch = 15, col = 3, axes = FALSE, xlab = "", ylab = "")

axis(side = 4, at = pretty(range(y2)))
mtext("OnDemand Cost $", side = 4, line = 3, col="green")
text(x, y2, labels, cex=0.65, pos=3,col="black")
legend("top", legend=c("Total Time", "OnDemand Cost"),
       col=c("red", "green"), lty=1:2, cex=0.8)
