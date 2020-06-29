clear;
clc;
tic;

[eng,pos,data] = read_data_from_single_file("..\\DATA\\201912\\1900979_370.dat");

toc;

%disp(['reading finish! total cost']);