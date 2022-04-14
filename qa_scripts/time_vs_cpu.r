# Script author: Liz Adams
# Affiliation: UNC CMAS Center 

csv_data<-read.csv("/shared/cyclecloud-cmaq/docs/user_guide_cyclecloud/timing_hc44rs.csv",sep="\t", skip =0, header = TRUE, comment.char = "",check.names = FALSE, quote="", )
print(csv_data)

# ------------- Do not change below unless modifying for a different workflow ---------------------


# plot data
   png(file = paste('HC44rs','_','Time','_','CPUs','.png',sep=''), width = 1024, height = 768, bg='white')

   plot(x = csv_data$CPUs,
        y = csv_data$TotalTime,
        xlab = "CPUs",
        ylab = "Total Time (2days)",
        main = "CMAQv533 Benchmark Run Time (seconds) vs CPUs on Cyclecloud using HC44rs Compute Nodes")
