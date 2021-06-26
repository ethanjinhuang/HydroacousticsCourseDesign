function [c,A] = sound_speed(temper,salt,deep)
%-------声速计算------
%   输入：温度（n x n）、盐度（n x n）、深度（n x n）、矩阵纬度 ( n )
%   输出：声速矩阵c（n x n）
%-----------END-----------

%% 常数确定
g = 9.8;        %重力常数
P0 = 101300;    %标准大气压
[row_num,column_num,deepth_num] = size(temper);
c = zeros(row_num,column_num,deepth_num);
%% 计算声速
% 计算压强
for i=1:1:deepth_num 
    pressure = (deep(i)./100.*P0 + P0)./P0;
    % 三参数模型
    ct = 4.6233.*temper(:,:,i) - 0.054585*power(temper(:,:,i), 2) + 0.0002822*power(temper(:,:,i), 3) + 5.07*power(10, -7)*power(temper(:,:,i), 4);
    cp = 0.160518*pressure + 1.0279*power(10, -5)*pressure .* pressure + 3.451*power(10, -9)*power(pressure, 3) - 3.503*power(10, -12)*power(pressure, 4);
    cs = 1.391*(salt(:,:,i) - 35) - 0.078*(salt(:,:,i) - 35).*(salt(:,:,i) - 35);
    cstp = (salt(:,:,i) - 35).*(-1.197*power(10, -3)*temper(:,:,i) + 2.61*power(10, -4)*pressure - 1.96*power(10, -7)*power(pressure, 2) - 2.09*power(10, -6)*pressure .* temper(:,:,i)) + pressure .* (-2.796*power(10, -4).*temper(:,:,i) + 1.3302*power(10, -5).*temper(:,:,i) .* temper(:,:,i) - 6.644*power(10, -8)*power(temper(:,:,i), 3)) + pressure .* pressure .* (-2.39*power(10, -7).*temper(:,:,i) + 9.286*power(10, -10).*temper(:,:,i) .* temper(:,:,i)) - 1.745*power(10, -10)*power(pressure, 3).*temper(:,:,i);
    c(:,:,i) = 1449.22 + ct + cs + cp + cstp;
end
%% 计算声速梯度
A = zeros(row_num,column_num,deepth_num - 1);
for i=2:1:deepth_num
   A(:,:,i - 1) = (c(:,:,i) - c(:,:,i-1))./  c(:,:,i) * (deep(i) - deep(i-1));
end

end