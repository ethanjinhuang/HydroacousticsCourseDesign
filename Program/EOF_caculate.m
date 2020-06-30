%运用EOF进行拟合计算
clear;
clc;
tic;
%% 标准参数
Standard_deep = [0,10,20,30,50,70,75,100,125,150,200,250,300,400,500,600,700,800,900,1000,1100,1200,1300,1400,1500,1750];
%% 数据读取变换,读取某一个点的数据，使之形成横轴为时间变化，纵轴为深度变化的二维矩阵
matrix_c = zeros(0,0);
for year = 2015:2019
    for month = 1:12
        [Salt,Temp,Deep]=read_mat_data(year,month,3.5,5.5,7.5,9.5,'N','E');
        [C_org,A] = sound_speed(Salt,Temp,Deep);
        matrix_c = [matrix_c data2line(C_org(1,1,:))];
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

C = X*X'/L;
[EOF,E] = eig(C);

E = fliplr(flipud(E));      %特征根
EOF = fliplr(flipud(EOF));  %空间特征向量
PC = EOF'*X;                %空间特征向量对应的时间系数（主成分）

mean_c = mean(std_mat,2);   %平均声速（1列）
mean_c = flipud(mean_c);

alphi = inv(EOF)*(fliplr(flipud(std_mat))-mean_c*ones(1,L));



approx_c_1 = mean_c ;
approx_c_2 = mean_c + alphi(:,1).*EOF(:,1)+alphi(:,2).*EOF(:,2);
approx_c_3 = mean_c + alphi(:,1).*EOF(:,1)+alphi(:,2).*EOF(:,2)+alphi(:,3).*EOF(:,3);




%% 显示部分
% 显示数据预处理：
real_data1 = matrix_c(:,2);


% 绘图
subplot(1,3,1);
plot(real_data1,Deep,'r-');
set(gca,'YDir','reverse');
hold on;
plot(approx_c_1,fliplr(Standard_deep),'bx');
xlabel('声速m/s');
ylabel('深度m');
legend('Org-data','1-stair','Location','southeast');
hold off;

subplot(1,3,2);
plot(real_data1,Deep,'r-');
set(gca,'YDir','reverse');
hold on;
plot(approx_c_2,fliplr(Standard_deep),'bx');
xlabel('声速m/s');
ylabel('深度m');
legend('Org-data','2-stair','Location','southeast');
hold off;

subplot(1,3,3);
plot(real_data1,Deep,'r-');
set(gca,'YDir','reverse');
hold on;
plot(approx_c_3,fliplr(Standard_deep),'bx');
xlabel('声速m/s');
ylabel('深度m');
legend('Org-data','3-stair','Location','southeast');
hold off;

%approx_c = mean_c + EOF(:,1)*E(1,1)+EOF(:,2)*E(2,2)+EOF(:,3)*E(3,3)+ EOF(:,11).*E(11,11)+EOF(:,12).*E(12,12);
%approx_c = mean_c + sum(EOF*E,2);

% 计算贡献率
E_exp = diag(E/sum(sum(E))); 



toc;