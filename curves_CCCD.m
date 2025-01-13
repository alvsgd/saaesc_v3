clc; clear all; close all;

% Carregar a curva simulada (arquivo "Simulação CCCD 1.txt")
simulacao = csvread('Simulação CCCD 1.txt');
t_simulacao = simulacao(:, 1); % Tempo da curva simulada
curva_simulada = simulacao(:, 2); % Tensão da curva simulada

% Transpor a curva simulada para que tenha o mesmo formato de linha
curva_simulada = curva_simulada'; 

% Parâmetros fixos
Ic = 0.2; % Corrente [A]
m = 0.002; % Massa [kg]
Vn = 5.5; % Tensão nominal [V]

% Lista de arquivos
arquivos = {
    '16.12.2024 teste6 CCCD 200mA 5.5V 0ciclos.txt',
    '16.12.2024 teste4 CCCD 200mA 5.5V 0ciclos.txt',
    '16.12.2024 teste5 CCCD 200mA 5.5V 0ciclos.txt',
    '16.12.2024 teste7 CCCD 200mA 5.5V 0ciclos.txt',
    '16.12.2024 teste8 CCCD 200mA 5.5V 0ciclos.txt',
    '16.12.2024 teste9 CCCD 200mA 5.5V 0ciclos.txt',
    '16.12.2024 teste13 CCCD 200mA 5.5V 0ciclos.txt',
    '16.12.2024 teste14 CCCD 200mA 5.5V 0ciclos.txt',
    '16.12.2024 teste15 CCCD 200mA 5.5V 0ciclos.txt',
    '16.12.2024 teste16 CCCD 200mA 5.5V 0ciclos.txt'
};

% Inicialização de vetores para armazenar os tempos e as curvas
tempos = cell(1, length(arquivos));
curvas = cell(1, length(arquivos));

% Carregar e armazenar os dados de cada arquivo
for i = 1:length(arquivos)
    Array = csvread(arquivos{i});
    tempos{i} = Array(:, 1);
    curvas{i} = Array(:, 2);
end

% ------------------------ Primeira Figura: Curvas e Curva Média ------------------------
figure;
hold on;

% Plotar todas as curvas lidas com linhas finas e legendas
for i = 1:length(arquivos)
    plot(tempos{i}, curvas{i}, 'LineWidth', 1.5); % Plotar cada curva com linha mais fina
end

% Calcular a curva média
tempo_max = max(cellfun(@(x) max(x), tempos));
t_geral = 0:0.05:tempo_max; % Tempo comum para todas as curvas
curvas_interp = zeros(length(arquivos), length(t_geral));

% Interpolar as curvas para o tempo comum
for i = 1:length(arquivos)
    curvas_interp(i, :) = interp1(tempos{i}, curvas{i}, t_geral, 'linear', 'extrap');
end

% Calcular a curva média
curva_media = mean(curvas_interp, 1);
curva_media(curva_media < 0) = NaN; % Substitui os valores negativos por NaN

% Plotar a curva média com linha preta, mais grossa e tracejada
plot(t_geral, curva_media, '--k', 'LineWidth', 3); % Curva média em preto, tracejada e grossa

% Calcular o desvio padrão para as barras de erro
desvio_padrao = std(curvas_interp, 0, 1);

% Calcular o desvio padrão médio
desvio_padrao_medio = mean(desvio_padrao);

% Plotar as barras de erro (a cada 20 amostras)
intervalo = 20; % Intervalo de 20 amostras
indices = 1:intervalo:length(t_geral);  % Índices espaçados de 20 em 20 amostras


% Adicionar legendas, título e rótulos
xlim([0 28]);
xlabel('Tempo [s]', 'FontSize', 14, 'FontName', 'CMU Serif');
ylabel('Tensão [V]', 'FontSize', 14, 'FontName', 'CMU Serif');
title('Curvas Experimentais de Carga e Descarga em Corrente Constante', 'FontSize', 14,'FontWeight', 'bold', 'FontName', 'CMU Serif');
legend([arrayfun(@(x) ['Curva ' num2str(x)], 1:length(arquivos), 'UniformOutput', false), 'Curva Média'], 'Location', 'best');
grid on;
hold off;

% ------------------------ Segunda Figura: Curva Simulada e Curva Média ------------------------
figure;
hold on;


% Plotar a curva simulada
plot(t_simulacao, curva_simulada, '-b', 'LineWidth', 2.5); % Curva simulada em azul

% Plotar a curva média com linha preta, mais grossa e tracejada
plot(t_geral, curva_media, '-r', 'LineWidth', 2.5); % Curva média em preto, tracejada e grossa

% Calcular o desvio padrão para as barras de erro
desvio_padrao_simulacao = std(curvas_interp, 0, 1);



% Plotar as barras de erro para a curva média (a cada 20 amostras)
errorbar(t_geral(indices), curva_media(indices), desvio_padrao_simulacao(indices), 'k', 'LineStyle', 'none', 'LineWidth', 1);

% Adicionar legendas, título e rótulos
ylim([0 6]);
xlim([0 28]);
xlabel('Tempo [s]', 'FontSize', 14, 'FontName', 'CMU Serif');
ylabel('Tensão [V]', 'FontSize', 14, 'FontName', 'CMU Serif');
title('Curva Simulada e Curva Experimental Média de Carga e Descarga em Corrente Constante', 'FontSize', 14,'FontWeight', 'bold', 'FontName', 'CMU Serif');
legend({'Curva Simulada', 'Curva Experimental Média', 'Erro Médio'}, 'Location', 'best');
grid on;
hold off;

% ------------------------ Cálculos de MAE, RMSE e R² ------------------------


curva_media = curva_media(~isnan(curva_media));
curva_simulada_interp = interp1(t_simulacao, curva_simulada, t_geral, 'linear'); % Interpolação linear
curva_simulada_interp = curva_simulada_interp(~isnan(curva_simulada_interp));

if length(curva_media) < length(curva_simulada_interp)
    curva_media = [curva_media, zeros(1, length(curva_simulada_interp) - length(curva_media))];
end

% MAE (Erro Médio Absoluto) - Somatório das diferenças absolutas dividido por n
MAE = sum(abs(curva_simulada_interp - curva_media)) / length(curva_simulada_interp);

% RMSE (Raiz do Erro Quadrático Médio) - Somatório dos quadrados das diferenças dividido por n, e raiz
RMSE = sqrt(sum((curva_simulada_interp - curva_media).^2) / length(curva_simulada_interp));

% R² (Coeficiente de Determinação) - Cálculo do R² para as duas curvas
SS_tot = sum((curva_simulada_interp- mean(curva_simulada_interp)).^2); % Soma dos quadrados totais
SS_res = sum((curva_simulada_interp - curva_media).^2); % Soma dos quadrados dos resíduos
R2 = 1 - (SS_res / SS_tot);


curva_media=curva_media(2:537);
curva_simulada_interp=curva_simulada_interp(2:537);

% Calcular o MRE (Erro Médio Relativo)
MRE = (sum(abs((curva_simulada_interp - curva_media) ./ curva_simulada_interp)) / length(curva_simulada_interp)) * 100;


% Exibir os resultados
disp(['MAE (Erro Médio Absoluto): ' num2str(MAE)]);
disp(['MRE (Erro Médio Relativo): ' num2str(MRE) '%']);
disp(['R² (Coeficiente de Determinação): ' num2str(R2)]);

disp(['Desvio Padrão Médio das curvas experimentais: ' num2str(desvio_padrao_medio)]);

