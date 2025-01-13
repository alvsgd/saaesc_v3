clc; clear all; close all;

% Carregar a curva simulada de autodescarga
simulacao = csvread('Simulação AD.txt');
t_simulacao = simulacao(:, 1); % Tempo da curva simulada
curva_simulada = simulacao(:, 2); % Tensão da curva simulada

% Lista de arquivos de autodescarga
arquivos = {
    '16.12.2024 teste10 Autodescarga 200mA 5.5V 0ciclos.txt',
    '16.12.2024 teste3 Autodescarga 200mA 5.5V 0ciclos.txt',
    '16.12.2024 teste12 Autodescarga 200mA 5.5V 0ciclos.txt',
    '16.12.2024 teste17 Autodescarga 200mA 5.5V 0ciclos.txt'
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

% Limitar os vetores de tempo
tempo_limite = 500;
for i = 1:length(arquivos)
    indices_validos = tempos{i} <= tempo_limite;
    tempos{i} = tempos{i}(indices_validos);
    curvas{i} = curvas{i}(indices_validos);
end
t_simulacao = t_simulacao(t_simulacao <= tempo_limite);
curva_simulada = curva_simulada(1:length(t_simulacao));

% ------------------------ Curvas e Curva Média ------------------------
t_geral = 0:0.05:tempo_limite; % Tempo comum para todas as curvas
curvas_interp = zeros(length(arquivos), length(t_geral));

% Interpolar as curvas para o tempo comum
for i = 1:length(arquivos)
    curvas_interp(i, :) = interp1(tempos{i}, curvas{i}, t_geral, 'linear', 'extrap');
end

% Calcular a curva média e remover valores negativos
curva_media = mean(curvas_interp, 1);

% Ajustar tamanho dos vetores curva_media e curva_simulada
curva_simulada_interp = interp1(t_simulacao, curva_simulada, t_geral, 'linear');
curva_simulada_interp = curva_simulada_interp(~isnan(curva_simulada_interp));

% Encontrar o tamanho mínimo entre curva_media e curva_simulada_interp
tamanho_minimo = min(length(curva_media), length(curva_simulada_interp));

% Restringir os vetores ao tamanho mínimo
curva_media2 = curva_media(1:tamanho_minimo);
curva_simulada_interp = curva_simulada_interp(1:tamanho_minimo);

% ------------------------ Cálculo do Desvio Padrão Médio ------------------------

% Calcular o desvio padrão das curvas experimentais
desvio_padrao = std(curvas_interp, 0, 1);

% Calcular o desvio padrão médio
desvio_padrao_medio = mean(desvio_padrao);

% ------------------------ Figura 1: Curvas Individuais e Média ------------------------
figure;
hold on;

% Configurar o fundo branco
set(gcf, 'Color', 'w');

% Plotar todas as curvas de autodescarga
for i = 1:length(arquivos)
    plot(t_geral, curvas_interp(i, :), 'LineWidth', 4);
end

% Plotar a curva média
plot(t_geral, curva_media, '--k', 'LineWidth', 3);

% Adicionar legendas, título e rótulos
xlim([0 500]);
xlabel('Tempo [s]', 'FontSize', 14, 'FontName', 'CMU Serif');
ylabel('Tensão [V]', 'FontSize', 14, 'FontName', 'CMU Serif');
title('Curvas Experimentais de Autodescarga', 'FontSize', 14,'FontWeight', 'bold', 'FontName', 'CMU Serif');
legend([arrayfun(@(x) ['Curva ' num2str(x)], 1:length(arquivos), 'UniformOutput', false), {'Curva Média'}], 'Location', 'best');
grid on;
hold off;

% ------------------------ Figura 2: Curva Simulada e Curva Média ------------------------
figure;
hold on;

% Configurar o fundo branco
set(gcf, 'Color', 'w');

% Plotar a curva simulada
plot(t_simulacao, curva_simulada, '-b', 'LineWidth', 4);

% Plotar a curva média
plot(t_geral, curva_media, '-.r', 'LineWidth', 4);

% Adicionar legendas, título e rótulos
xlim([0 500]);
xlabel('Tempo [s]', 'FontSize', 14, 'FontName', 'CMU Serif');
ylabel('Tensão [V]',  'FontSize', 14, 'FontName', 'CMU Serif');
title('Curva Simulada e Curva Experimental Média de Autodescarga', 'FontSize', 14, 'FontWeight', 'bold', 'FontName', 'CMU Serif');
legend({'Curva Simulada', 'Curva Experimental Média'}, 'Location', 'best');
grid on;
hold off;


% ------------------------ Figura 2: Curva Simulada e Curva Média - Barra de erros ------------------------
figure;
hold on;

% Configurar o fundo branco
set(gcf, 'Color', 'w');

% Plotar a curva simulada
plot(t_simulacao, curva_simulada, '-b', 'LineWidth', 2);

% Plotar a curva média
plot(t_geral, curva_media, '-r', 'LineWidth', 2);

% Adicionar barras de erro a cada 20 amostras
intervalo = 500; % A cada 20 amostras
indices = 1:intervalo:length(curva_media);  % Índices espaçados de 20 em 20 amostras

% Plotar as barras de erro para a curva média
errorbar(t_geral(indices), curva_media(indices), desvio_padrao(indices), 'k', 'LineStyle', 'none', 'LineWidth', 1);

% Adicionar legendas, título e rótulos
xlim([0 500]);
xlabel('Tempo [s]', 'FontSize', 14, 'FontName', 'CMU Serif');
ylabel('Tensão [V]',  'FontSize', 14, 'FontName', 'CMU Serif');
title('Curva Simulada e Curva Experimental Média de Autodescarga', 'FontSize', 14, 'FontWeight', 'bold', 'FontName', 'CMU Serif');
legend({'Curva Simulada', 'Curva Experimental Média', 'Erro Médio'}, 'Location', 'best');
grid on;
hold off;

% ------------------------ Cálculo de MAE, RMSE e R² ------------------------
% MAE
MAE = sum(abs(curva_simulada_interp - curva_media2)) / tamanho_minimo;

% RMSE
RMSE = sqrt(sum((curva_simulada_interp - curva_media2).^2) / tamanho_minimo);

% R²
SS_tot = sum((curva_simulada_interp - mean(curva_simulada_interp)).^2);
SS_res = sum((curva_simulada_interp - curva_media2).^2);
R2 = 1 - (SS_res / SS_tot);


% Calcular o MRE (Erro Médio Relativo)
MRE = (sum(abs((curva_simulada_interp - curva_media) ./ curva_simulada_interp)) / length(curva_simulada_interp)) * 100;


% Exibir os resultados
disp(['MAE (Erro Médio Absoluto): ' num2str(MAE)]);
disp(['MRE (Erro médio Relativo): ' num2str(MRE) '%']);
disp(['R² (Coeficiente de Determinação): ' num2str(R2)]);

disp(['Desvio Padrão Médio das curvas experimentais: ' num2str(desvio_padrao_medio)]);
