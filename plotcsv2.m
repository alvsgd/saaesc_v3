clear all; close all; clc;

Array=csvread('Simulação AD.txt');
ts = Array(:, 1);
vs = Array(:, 2);

Array=csvread('16.12.2024 teste10 Autodescarga 200mA 5.5V 0ciclos.txt');
t1 = Array(:, 1);
v1 = Array(:, 2);


Array=csvread('16.12.2024 teste3 Autodescarga 200mA 5.5V 0ciclos.txt');
t2 = Array(:, 1);
v2 = Array(:, 2);

Array=csvread('16.12.2024 teste11 Autodescarga 200mA 5.5V 0ciclos.txt');
t3 = Array(:, 1);
v3 = Array(:, 2);

Array=csvread('16.12.2024 teste12 Autodescarga 200mA 5.5V 0ciclos.txt');
t4 = Array(:, 1);
v4 = Array(:, 2);

Array=csvread('16.12.2024 teste17 Autodescarga 200mA 5.5V 0ciclos.txt');
t5 = Array(:, 1);
v5 = Array(:, 2);


Array=csvread('Simulação CCCD 1.txt');
xs = Array(:, 1);
ys = Array(:, 2);


Array=csvread('16.12.2024 teste6 CCCD 200mA 5.5V 0ciclos.txt');
x1 = Array(:, 1);
y1 = Array(:, 2);

Array=csvread('16.12.2024 teste4 CCCD 200mA 5.5V 0ciclos.txt');
x2 = Array(:, 1);
y2 = Array(:, 2);

Array=csvread('16.12.2024 teste5 CCCD 200mA 5.5V 0ciclos.txt');
x3 = Array(:, 1);
y3 = Array(:, 2);

Array=csvread('16.12.2024 teste7 CCCD 200mA 5.5V 0ciclos.txt');
x4 = Array(:, 1);
y4 = Array(:, 2);

Array=csvread('16.12.2024 teste8 CCCD 200mA 5.5V 0ciclos.txt');
x5 = Array(:, 1);
y5 = Array(:, 2);

Array=csvread('16.12.2024 teste9 CCCD 200mA 5.5V 0ciclos.txt');
x6 = Array(:, 1);
y6 = Array(:, 2);

Array=csvread('16.12.2024 teste13 CCCD 200mA 5.5V 0ciclos.txt');
x7 = Array(:, 1);
y7 = Array(:, 2);

Array=csvread('16.12.2024 teste14 CCCD 200mA 5.5V 0ciclos.txt');
x8 = Array(:, 1);
y8 = Array(:, 2);

Array=csvread('16.12.2024 teste15 CCCD 200mA 5.5V 0ciclos.txt');
x9 = Array(:, 1);
y9 = Array(:, 2);

Array=csvread('16.12.2024 teste16 CCCD 200mA 5.5V 0ciclos.txt');
x10 = Array(:, 1);
y10 = Array(:, 2);


% 
% c20=(526.52-520.3)*i / (4.1912-2.0254)
% c1=(22.24-16.44)*i / (4.279-2.3122)


figure;
plot(x1, y1, 'r', 'LineWidth', 2);   % Vermelho
hold on;  
plot(x2, y2, 'b', 'LineWidth', 2);   % Azul
plot(x3, y3, 'g', 'LineWidth', 2);   % Verde
plot(x4, y4, 'm', 'LineWidth', 2);   % Magenta
plot(x5, y5, 'c', 'LineWidth', 2);   % Ciano
plot(x6, y6, 'Color' , '#D95319', 'LineWidth', 2); % Laranja
plot(x7, y7, 'Color', '#E68920', 'LineWidth', 2); % Amarelo
plot(x8, y8, 'Color', '#7C2A8B', 'LineWidth', 2); % Roxo
plot(x9, y9, 'Color', '#555555', 'LineWidth', 2); % Cinza Escuro
plot(x10, y10, 'Color', '#F0A500', 'LineWidth', 2); % Ouro

plot(xs, ys, 'Color', 'k', 'LineStyle', '--', 'LineWidth', 2);



% plot(x11, y11, 'Color', '#9E1B32', 'LineWidth', 2); % Vinho
% plot(x12, y12, 'Color', '#40E0D0', 'LineWidth', 2); % Turquesa
% plot(x13, y13, 'Color', '#FFD700', 'LineWidth', 2); % Dourado
% plot(x14, y14, 'Color', '#808000', 'LineWidth', 2); % Oliva
% plot(x15, y15, 'Color', '#FFDAB9', 'LineWidth', 2); % Pêssego


% % Configurações adicionais
% legend('y1', 'y2', 'y3', 'y4', 'y5', 'y6', 'y7', 'y8', 'y9', 'y10');
% title('Curvas CCCD');
% xlabel('Tempo(s)');
% ylabel('Tensão(V)');
% grid on;
hold off;

v4=v4(1:39029);
t4=t4(1:39029);

v_mean=(v1+v2+v4+v5)/4;
t_mean=(t1+t2+t4+t5)/4;

figure;
TMAX = 720;
t_3tau= NaN;
for i = 1:length(t1)
    if isnan(t_3tau) && t1(i) >= TMAX
        t_3tau = t1(i);
    end
    if ~isnan(t_3tau)
        break;
    end  
end
index_max = find(t1 == t_3tau);

t1=t1(1:index_max);
v1=v1(1:index_max);

t2=t2(1:index_max);
v2=v2(1:index_max);

t3=t3(1:index_max);
v3=v3(1:index_max);

t4=t4(1:index_max);
v4=v4(1:index_max);

t5=t5(1:index_max);
v5=v5(1:index_max);

plot(t2, v2, 'b', 'LineWidth', 2); 
hold on;  
plot(t1, v1, 'r', 'LineWidth', 2);
% plot(t3, v3, 'g', 'LineWidth', 2); %FEIA
plot(t4, v4, 'm', 'LineWidth', 2);
plot(t5, v5, 'c', 'LineWidth', 2);
plot(ts, vs, 'Color', 'k', 'LineStyle', '--', 'LineWidth', 2);

