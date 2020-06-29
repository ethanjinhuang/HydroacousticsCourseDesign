function [Salt,Temp,Deep] = read_mat_data(year,month,lat_min_num,lat_max_num,log_min_num,log_max_num,NS,EW)
% ------数据读取函数------
% -   输入数据：
%         year：         年
%         month：        月
%         lat_min_num：  纬度起点
%         lat_max_num：  纬度终点
%         log_min_num：  经度起点
%         log_max_num：  经度终点
%         NS：           南北纬   
%         EW：           东西经
% -   输出数据:
%         温度、盐度、深度矩阵
% ----------END----------

filename = strcat('BOA_Argo_',num2str(year),'_',num2str(month,'%02d'),'.mat');
[latmin,latmax,logmin,logmax]=tran_pos(lat_min_num,lat_max_num,log_min_num,log_max_num,NS,EW);
file_dir = strcat('..\\DATA\\全球海洋Argo网格数据集\\',filename);
load(file_dir);
Salt=salt(logmin:logmax,latmin:latmax,:);
Temp=temp(logmin:logmax,latmin:latmax,:);
Deep=pres;

end