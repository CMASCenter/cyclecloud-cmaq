# Script author: Jesse Bash
# Affiliation: US EPA Office of Research and Development
# This script assumes that the log files are located in ./CCTM/scripts as output by the CMAQ run script 
# These are the single output files, not the CTM_LOG files found in the $OUTDIR/LOGS directory
library(RColorBrewer)
sens.dir  <- '/shared/build/openmpi_gcc/CMAQ_v533/CCTM/scripts/'
base.dir  <- '/shared/build/openmpi_gcc/CMAQ_v533/CCTM/scripts/'
files   <- dir(sens.dir, pattern ='run_cctmv5.3.3_Bench_2016_12US2.64.8x8pe.2day.cyclecloud.lustre.codemod.pin.HBv64rs.log')
#b.files <- dir(base.dir,pattern='run_cctmv5.3.3_Bench_2016_12US2.576.24x24pe.2day.cyclecloud.data.codemod.nopin.redo.log')
#b.files <- dir(base.dir,pattern='run_cctmv5.3.3_Bench_2016_12US2.*.2day.cyclecloud.data.codemod.pin.log')
b.files <- c('run_cctmv5.3.3_Bench_2016_12US2.128.2x64.16x8pe.2day.cyclecloud.lustre.codemod.pin.HBv64rs.log','run_cctmv5.3.3_Bench_2016_12US2.3x64.192.16x12pe.2day.cyclecloud.lustre.codemod.pin.HBv64rs.log','run_cctmv5.3.3_Bench_2016_12US2.4x64.256.16x16pe.2day.cyclecloud.lustre.codemod.pin.HBv64rs.log','run_cctmv5.3.3_Bench_2016_12US2.5x64.320.20x16pe.2day.cyclecloud.lustre.codemod.pin.HBv64rs.log','run_cctmv5.3.3_Bench_2016_12US2.6x64.384.24x16pe.2day.cyclecloud.lustre.codemod.pin.HBv64rs.log','run_cctmv5.3.3_Bench_2016_12US2.7x64.448.28x16pe.2day.cyclecloud.lustre.codemod.pin.HBv64rs.log','run_cctmv5.3.3_Bench_2016_12US2.8x64.512.32x16pe.2day.cyclecloud.lustre.codemod.pin.HBv64rs.log','run_cctmv5.3.3_Bench_2016_12US2.9x64.576.24x24pe.2day.cyclecloud.lustre.codemod.pin.HBv64rs.log')
#Compilers <- c('intel','gcc','pgi')
Compilers <- c('')
# name of the base case timing. I am using the current master branch from the CMAQ_Dev repository.
# The project directory name is used for the sensitivity case. 
base.name <- c('128_2x64','192_3x64','256_4x64','320_6x64','384_6x64','448_7x64','512_8x64','576_9x64')
#base.name <- c('data_pin')
sens.name <- c('64_1x64')

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
         b.names <- append(b.names,paste(comp,all.names[i]))
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
   png(file = paste('all',sens.name,'_',base.name,'.png',sep=''), width = 1024, height = 768, bg='white')
  # png(file = paste(comp,'_',sens.name,'.png',sep=''), width = 1024, height = 768, bg='white')
   barplot(bar.data, main = 'Process Timing on /lustre using 64 cpus/node on HBv64rs',names.arg = b.names,ylab='seconds', col = my.colors, legend = n.proc, xlim = c(0.,xmax),ylim = c(0.,5600.))
   box()
   dev.off()
   totals <- apply(bar.data,c(2),sum) 
# print total runtime data to the screen
   for(i in 1:length(base.name)){
     print(paste('Run time for', base.name[i], ':',totals[i],'seconds'))
   }
}
