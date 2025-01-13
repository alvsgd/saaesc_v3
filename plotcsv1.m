
clc; clear all; close all;
Array=csvread('16.12.2024 teste17 Autodescarga 200mA 5.5V 0ciclos.txt');
x4 = Array(:, 1);
y4 = Array(:, 2);



Array=csvread('Simulação AD tau40.txt');
t = Array(:, 1);
v = Array(:, 2);


t0=NaN;

% for i = 1:length(v)
%     if isnan(t0) && v(i) <= 0
%         t0 = t(i);
%     end
%     if ~isnan(t0)
%         break;
%     end  
% end
% 
% index0=find(t == t0)
% v=v(1:index0);
% t=t(1:index0);

Ic=0.2;

vmax = max(v);
dv=vmax-v(2);
tc=t(find(v == vmax));
C_simulado=(tc*Ic)/dv

vmax_ = max(y4);
dv_=vmax_-y4(2);
tc_=x4(find(y4 == vmax_));
C_medido=(tc_*Ic)/dv_


figure;

plot(x4, y4, 'm', 'LineWidth', 2);   % Magenta
hold on;
plot(t, v, 'c', 'LineWidth', 2);   % Ciano

