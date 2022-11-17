#!/bin/csh -f

cd /lustre/data/output/output_CCTM_v533_gcc_2016_CONUS_96_12x8pe_lustre3_codemod_pin_precision/LOGS
set z="."
foreach i (`ls -d $z/*1222`)
 grep 'completed...'  $i > $i.proc.complete
 sed -e 's/\s\+/,/g'  $i.proc.complete > $i.proc.complete.csv
 awk -F',' '{sum+=$4;sum2+=$6} END{print sum,sum2;}' $i.proc.complete.csv >> sum.proc.complete.1222.csv
 # Column 4 contains the sum of the valuses Processing,completed..., 
 # Column 6 contains the sum of the values for Data,Output,completed...,0.350,seconds
end

foreach j (`ls -d $z/*1223`)
 grep 'completed...'  $j > $j.proc.complete
 sed -e 's/\s\+/,/g'  $j.proc.complete > $j.proc.complete.csv
 awk -F',' '{sum+=$4;sum2+=$6} END{print sum,sum2;}' $j.proc.complete.csv >> sum.proc.complete.1223.csv
 # Column 4 contains the sum of the valuses Processing,completed..., 
 # Column 6 contains the sum of the values for Data,Output,completed...,0.350,seconds
end

