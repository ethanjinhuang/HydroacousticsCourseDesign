%运用EOF进行拟合计算
clear;
clc;
tic;
%% 标准参数
Standard_deep = [0,10,20,30,50,70,75,100,125,150,200,250,300,400,500,600,700,800,900,1000,1100,1200,1300,1400,1500,1750];
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

% 对数据进行插值
[~,stdN] = size(Standard_deep);
std_mat = zeros(stdN,L);
for i = 1:1:L
    std_mat(:,i) = akima(Deep',matrix_c(:,i)',Standard_deep);
end




% 对C矩阵进行距平
X = std_mat - mean(std_mat,2)*ones(1,L);
clear C;

C = X*X'/L;
[EOF,E] = eig(C);
PC = EOF'*X;

E = diag(sort(diag(E),'descend'));

% EOF = fliplr(flipud(E));
% lambda = diag(E);
% EOF = fliplr(EOF);
% PC = flipud(PC);





toc;