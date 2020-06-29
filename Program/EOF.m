%运用EOF进行拟合计算
clear;
clc;
tic;
%% 数据读取变换
matrix_c = zeros(0,0);
for year = 2018:2019
    for month = 1:12
        [Salt,Temp,Deep]=read_mat_data(2018,1,3.5,5.5,7.5,9.5,'N','E');
        [C,A] = sound_speed(Salt,Temp,Deep);
        matrix_c = [matrix_c data2line(C(1,1,:))];
    end
end
[N,L] = size(matrix_c);
R = zeros(N,L);
c_h = sum(matrix_c,2);




toc;