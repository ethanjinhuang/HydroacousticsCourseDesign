clear;
clc;
[latmin,latmax,logmin,logmax]=tran(3.5,5.5,7.5,9.5,'N','E');
[Salt,Temp,Deep]=readData('BOA_Argo_2004_01.mat',latmin,latmax,logmin,logmax);