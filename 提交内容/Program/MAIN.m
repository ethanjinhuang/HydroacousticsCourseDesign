clear;
clc;
tic;

[Salt,Temp,Deep]=read_mat_data(2019,1,12.5,12.5,115.5,115.5,'N','E');
[C,A] = sound_speed(Salt,Temp,Deep);
point1_C = data2line(C(1,1,:));

plot(point1_C,Deep);
set(gca,'YDir','reverse')

toc;