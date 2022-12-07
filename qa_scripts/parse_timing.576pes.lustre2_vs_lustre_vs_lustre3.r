# Script author: Jesse Bash
# Affiliation: US EPA Office of Research and Development
# This script assumes that the log files are located in ./CCTM/scripts as output by the CMAQ run script 
# These are the single output files, not the CTM_LOG files found in the $OUTDIR/LOGS directory
library(RColorBrewer)
sens.dir  <- '/shared/build/openmpi_gcc/CMAQ_v533/CCTM/scripts/'
base.dir  <- '/shared/build/openmpi_gcc/CMAQ_v533/CCTM/scripts/'
files   <- dir(sens.dir, pattern ='run_cctmv5.3.3_Bench_2016_12US2.576.24x24pe.2day.cyclecloud.lustre2.codemod.pin.log')
b.files <- c('run_cctmv5.3.3_Bench_2016_12US2.576.24x24pe.2day.cyclecloud.lustre.codemod.pin.log','run_cctmv5.3.3_Bench_2016_12US2.576.24x24pe.2day.cyclecloud.lustre3.codemod.pin.log')
Compilers <- c('gcc')
# name of the base case timing. I am using the current master branch from the CMAQ_Dev repository.
# The project directory name is used for the sensitivity case. 
base.name <- c('lustre_200','lustre3_250')
#base.name <- c('data_pin')
sens.name <- c('lustre2_150')

# ------------- Do not change below unless modifying for a different workflow ---------------------
# compilers being considered
#Compilers <- c('intel','gcc','pgi')
#Compilers <- c('intel')
# parse directory and file information
#sens.name <- strsplit(files,'/')
#n.lev     <- length(sens.name[[1]])
#sens.name <- sens.name[[1]][n.lev]
all.names <- NULL
for(i in 1:length(files)){
   all.names <- append(all.names,sens.name)
}
files <- paste(sens.dir,files,sep="")
for(i in 1:length(files)){
   all.names <- append(all.names,base.name)
}
files <- append(files,paste(base.dir,b.files,sep=''))
for( comp in Compilers) {
   bar.data <- NULL
   b.names <- NULL
   for(i in 1:length(files)){
# ignore debug simulations and get compiler information
#      if(i%in%grep('debug',files)==F & i%in%grep(comp,files)){
         file <- files[i]
         b.names <- append(b.names,paste(all.names[i]))
         data.in  <- scan(file,what='character',sep='\n')
# get timing info
         Timing <-  as.numeric(substr(data.in[grep('completed...',data.in)],36,42))
         Process <- substr(data.in[grep('completed...',data.in)],12,22)
         n.proc <- unique(Process)
         n.proc <- n.proc[grep('Proc',n.proc,invert=T)]
# Aggrigate data
         tmp.data <- NULL
         for(i in n.proc){
           valid <- which(i==Process)
           tmp.data <- append(tmp.data,sum(Timing[valid]))
         }
         bar.data <- cbind(bar.data,tmp.data)
   #   }
   }
# plot data
   my.colors <- brewer.pal(11, "Paired")
   #my.colors <- terrain.colors(length(n.proc))
   xmax <- dim(bar.data)[2]*1.5
   png(file = paste('576_cpu_pin_lustre2_vs_lustre_vs_lustre3_',comp,'_all',sens.name,'_',base.name,'.png',sep=''), width = 1024, height = 768, bg='white')
  # png(file = paste(comp,'_',sens.name,'.png',sep=''), width = 1024, height = 768, bg='white')
   barplot(bar.data, main = 'Process Timing on /lustre using 576 cpus/node on HBv3 120 with pinning',names.arg = b.names,ylab='seconds', col = my.colors, legend = n.proc, xlim = c(0.,xmax),ylim = c(0.,3000.))
   box()
   dev.off()
   totals <- apply(bar.data,c(2),sum)
# print total runtime data to the screen
   for(i in 1:length(base.name)){
     print(paste('Run time for', base.name[i], ':',totals[i],'seconds'))
   }
}
