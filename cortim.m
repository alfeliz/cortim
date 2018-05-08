######################################################################################################
#
#  Octave program to synchronize the Cordin expansion to the electrical 
#    signals in each shot, when this is possible.
#
# It uses the function:
#	 display_rounded_matrix			To write correctly the final output files.
#
######################################################################################################
#   This script will work ONLY in the folder with all the Cordin radial expansion 
#     AND the files of teh synchro data, last data from folder 2018-03-06

more off; %To make the lines display when they appear in the script, not at the end of it.

clear; %Just in case there is some data in memory.

tic; %Total time of the script.


main_folder = pwd; #Store the folder were this program is executed in a string variable.

shots = dir("*-rad.txt"); #Taking all the shots by the name of the plasma radial data.

for i=1:numel(shots)
  #Reading files and so on:
  shot = shots(i).name; #Radial file with data to be synchronized.
  str = shot(1:regexp(shot,'-')-1) #Shot for name of Synchro data file.
  time_file = horzcat(str,'-synchro.txt'); #Synchro data file.
  fid_time = fopen(time_file,'r'); #ID of the Synchro file to read it.
  delay =str2num(textscan(fid_time,'%s'){1}{4})*1e6; #Read the file and take only the Cordin delay in µs
  fid_rad = fopen(shot,'r'); #ID of the radial data file.
  rad = textscan(fid_rad,'%f %f', 'HeaderLines', 1); #Read the radial data as a structure.
  radius = [rad{1}, rad{2} ]; #Transforming the strucutred data into a matrix.
  radius = sort(radius,1); #sort the matrix.
  radius(:,1) = radius(:,1) + delay; #Adding the delay.
  #Closing fid files:
  fclose(fid_time);
  fclose(fid_rad);
  #Saving data as a pro:
  file_sav = horzcat(str,'-rad-adj.txt');
  redond = [2 6];
  output = fopen(file_sav,"w"); #Opening the file.
  fdisp(output,"time(µs)	plasma_rad(mm)"); #First line.
  display_rounded_matrix(radius, redond, output); 
  fclose(output);
endfor;


toc;


#That's...that's all, folks! 
