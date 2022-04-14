# Script author: Liz Adams
# Affiliation: UNC CMAS Center 

csv_data<-read.csv("/shared/cyclecloud-cmaq/docs/user_guide_cyclecloud/timing_hc44rs.csv",sep="\t", skip =0, header = TRUE, comment.char = "",check.names = FALSE, quote="", )
print(csv_data)

# ------------- Do not change below unless modifying for a different workflow ---------------------


# Give the second plot file a name.
   png(file = paste('HC44rs','_','Cost','_','CPUs','.png',sep=''), width = 1024, height = 768, bg='white')

   plot(x = csv_data$CPUs,
        y = csv_data$OnDemandCost,
      xlab = "CPUs",
       ylab = "On Demand Cost (2days)",
      main = "CMAQv533 Benchmark On Demand Cost vs CPUs on Cyclecloud uinsg HC44rs Compute Nodes")
