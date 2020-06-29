clear;
clc;
tic;

[Salt,Temp,Deep]=read_mat_data(2018,1,3.5,5.5,7.5,9.5,'N','E');
[C,A] = sound_speed(Salt,Temp,Deep);
point1_C = data2line(C(1,1,:));

plot(point1_C,Deep);
set(gca,'YDir','reverse')

toc;