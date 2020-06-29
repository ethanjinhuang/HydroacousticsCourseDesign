function c = sound_speed(temper,salt,deep,data_size)
%-------声速计算程序------
%   输入：温度（n x n）、盐度（n x n）、深度（n x n）、矩阵纬度 ( n )
%   输出：声速矩阵c（n x n）
%-----------END-----------

%% 常数确定
g = 9.8;        %重力常数
P0 = 101300;    %标准大气压

%暂定输入数据为：  temp,salt,deep
data_size = 8; %暂定矩阵大小
% 模拟数据
temper = zeros(data_size,data_size);
salt = zeros(data_size,data_size);
deep = zeros(data_size,data_size);

%% 计算
% 计算压强
pressure = (deep./100.*P0 + P0)./P0;
% 三参数模型
ct = 4.6233.*temper - 0.054585*power(temper, 2) + 0.0002822*power(temper, 3) + 5.07*power(10, -7)*power(temper, 4);
cp = 0.160518*pressure + 1.0279*power(10, -5)*pressure .* pressure + 3.451*power(10, -9)*power(pressure, 3) - 3.503*power(10, -12)*power(pressure, 4);
cs = 1.391*(salt - 35) - 0.078*(salt - 35).*(salt - 35);
cstp = (salt - 35).*(-1.197*power(10, -3)*temper + 2.61*power(10, -4)*pressure - 1.96*power(10, -7)*power(pressure, 2) - 2.09*power(10, -6)*pressure .* temper) + pressure .* (-2.796*power(10, -4).*temper + 1.3302*power(10, -5).*temper .* temper - 6.644*power(10, -8)*power(temper, 3)) + pressure .* pressure .* (-2.39*power(10, -7).*temper + 9.286*power(10, -10).*temper .* temper) - 1.745*power(10, -10)*power(pressure, 3).*temper;
c = 1449.22 + ct + cs + cp + cstp;

end