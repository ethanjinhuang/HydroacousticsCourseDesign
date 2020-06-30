%运用EOF进行拟合计算
clear;
clc;
tic;
%% 数据读取变换,读取某一个点的数据，使之形成横轴为时间变化，纵轴为深度变化的二维矩阵
matrix_c = zeros(0,0);
for year = 2018:2019
    for month = 1:12
        [Salt,Temp,Deep]=read_mat_data(year,month,3.5,5.5,7.5,9.5,'N','E');
        [C,A] = sound_speed(Salt,Temp,Deep);
        matrix_c = [matrix_c data2line(C(1,1,:))];
    end
end
[N,L] = size(matrix_c);
% 对C矩阵进行距平
X = matrix_c - mean(matrix_c,2)*ones(1,L);
clear C matrix_c;

C = X*X'/L;
[EOF,E] = eig(C);
PC = EOF'*X;

% EOF = fliplr(flipud(E));
% lambda = diag(E);
% EOF = fliplr(EOF);
% PC = flipud(PC);





toc;