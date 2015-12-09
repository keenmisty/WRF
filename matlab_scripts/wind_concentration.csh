#!/bin/csh -f

set Matlab_HOME = /ees/soft/Matlab2010a
set PATH = /ees/users/EMG/ees2/daijn/matlab/matlab_test
cd $PATH

set FileName = wind_concentration.m

rm -rf print.out
${Matlab_HOME}/bin/matlab -nodesktop -nosplash -nojvm -r "run ./$FileName;quit" >& print.out

exit 0
