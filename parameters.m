clc; clear all; close all;


% Inicializar vetores para armazenar os parâmetros
kv = [];
c0 = [];
C2 = [];
R2 = [];
r0 = [];
EPR = [];

Ic = 0.2;
Vn = 5.5;
tau2 = 80;
TMAX = 500;

% Lista de arquivos de dados
arquivos = {
    '16.12.2024 teste17 Autodescarga 200mA 5.5V 0ciclos.txt',
    '16.12.2024 teste10 Autodescarga 200mA 5.5V 0ciclos.txt',
    '16.12.2024 teste3 Autodescarga 200mA 5.5V 0ciclos.txt',
    '16.12.2024 teste12 Autodescarga 200mA 5.5V 0ciclos.txt'
};

% Inicializar uma matriz para armazenar todas as curvas
curvas = [];

for k = 1:length(arquivos)
    % Carregar os dados do arquivo
    Array = csvread(arquivos{k});
    t = Array(:, 1);
    v = Array(:, 2);

    % Armazenar a curva
    if isempty(curvas)
        curvas = v;
        tempo_comum = t;
    else
        curvas = [curvas, interp1(t, v, tempo_comum, 'linear', 'extrap')];
    end

    % Cálculo de parâmetros conforme o código original
    vmax = max(v);
    dv = vmax - v(2);
    tc = t(find(v == vmax, 1));
    C = (tc * Ic) / dv;

    % Parâmetros iniciais
    r0(k) = v(2) / Ic;

    % Pontos para calcular os parâmetros
    p1 = 0.4;
    p2 = 0.8;
    t1 = NaN;
    t2 = NaN;

    v_ajuste = v - v(2);
    t_ajuste = t - t(2);

    v_ajuste = v_ajuste(2:end);
    t_ajuste = t_ajuste(2:end);

    for i = 1:length(v_ajuste)
        if isnan(t1) && v_ajuste(i) >= p1 * Vn
            t1 = t_ajuste(i);
        end
        if isnan(t2) && v_ajuste(i) >= p2 * Vn
            t2 = t_ajuste(i);
        end
        if ~isnan(t1) && ~isnan(t2)
            break;
        end
    end

    % Índices e valores nos pontos
    index1 = find(t_ajuste == t1, 1);
    v1 = v_ajuste(index1);
    index2 = find(t_ajuste == t2, 1);
    v2 = v_ajuste(index2);

    % Cálculo dos parâmetros
    c0(k) = (t1 / v1 - (v1 * t2 - t1 * v2) / (v2 * v2 - v1 * v2)) * Ic;
    kv(k) = 2 * ((v1 * t2 - t1 * v2) / (v1 * v2 * v2 - v1 * v1 * v2)) * Ic;

    t3 = NaN;
    for i = 1:length(t)
        if isnan(t3) && t(i) >= tc + 3 * tau2
            t3 = t(i);
        end
        if ~isnan(t3)
            break;
        end
    end

    index3 = find(t == t3, 1);
    v2f = v(index3);

    C2(k) = (Ic * tc - (c0(k) + (kv(k) * v2f) / 2) * v2f) / v2f;
    R2(k) = tau2 / C2(k);

    vdis = v(find(v == vmax, 1) + 1);
    dv_dis = vdis - v2f;
    dt_dis = t3 - t(find(v == vmax, 1) + 1);
    Ileak = (C2(k) * dv_dis) / dt_dis;
    EPR(k) = vdis / Ileak;

    % Exibir os resultados para o arquivo atual
    disp(['Resultados para o arquivo: ', arquivos{k}]);
    Tabela_Parametros = table(r0(k), c0(k), kv(k), C2(k), R2(k), EPR(k), ...
        'VariableNames', {'R0', 'C0', 'kv', 'C2', 'R2', 'EPR'});
    disp(Tabela_Parametros);
end

% Exibir todos os vetores
disp('Parâmetros extraídos para todos os arquivos:');
disp('R0: '), disp(r0);
disp('C0: '), disp(c0);
disp('kv: '), disp(kv);
disp('C2: '), disp(C2);
disp('R2: '), disp(R2);
disp('EPR: '), disp(EPR);

% Calcular estatísticas para cada vetor de parâmetros
stats = struct();

% Parâmetros para os quais calcular estatísticas
parametros = {'r0', 'c0', 'kv', 'C2', 'R2', 'EPR'};

for i = 1:length(parametros)
    param = parametros{i};
    vetor = eval(param); % Obtém o vetor usando o nome como string
    
    % Estatísticas básicas
    stats.(param).media = mean(vetor);
    stats.(param).desvio_padrao = std(vetor);
    stats.(param).mediana = median(vetor);
    stats.(param).minimo = min(vetor);
    stats.(param).maximo = max(vetor);
    
    % Erros
    stats.(param).MAE = mean(abs(vetor - stats.(param).media));
    stats.(param).MRE = mean(abs((vetor - stats.(param).media) ./ stats.(param).media)) * 100;
end

% Exibir as estatísticas calculadas
disp('Estatísticas para os parâmetros:');
for i = 1:length(parametros)
    param = parametros{i};
    fprintf('\nParâmetro: %s\n', param);
    fprintf('Média: %.4f\n', stats.(param).media);
    fprintf('Desvio padrão: %.4f\n', stats.(param).desvio_padrao);
    fprintf('Mediana: %.4f\n', stats.(param).mediana);
    fprintf('Mínimo: %.4f\n', stats.(param).minimo);
    fprintf('Máximo: %.4f\n', stats.(param).maximo);
    fprintf('Erro Médio Absoluto (MAE): %.4f\n', stats.(param).MAE);
    fprintf('Erro Médio Relativo (MRE): %.2f%%\n', stats.(param).MRE);
end

% Calcular a curva média
curva_media = mean(curvas, 2);

% Plotar todas as curvas e a curva média
figure;
hold on;
for k = 1:size(curvas, 2)
    plot(tempo_comum, curvas(:, k), 'LineWidth', 1);
end
plot(tempo_comum, curva_media, 'k--', 'LineWidth', 2); % Curva média
hold off;

xlim([0 500])
xlabel('Tempo (s)');
ylabel('Tensão (V)');
title('Curvas de Descarga e Curva Média');
legend([arrayfun(@(x) sprintf('Arquivo %d', x), 1:length(arquivos), 'UniformOutput', false), 'Curva Média'], ...
    'Location', 'best');
grid on;

simulacao = csvread('Simulação AD.txt');
t_simulacao = simulacao(:, 1); % Tempo da curva simulada
curva_simulada = simulacao(:, 2); % Tensão da curva simulada



% Cálculo dos parâmetros para a curva simulada

% Determinar vmax e calcular dv e tc
vmax_simulada = max(curva_simulada);
tc_simulada = t_simulacao(find(curva_simulada == vmax_simulada, 1));

% Limitação do tempo até TMAX
t_3tau_simulada = NaN;
for i = 1:length(t_simulacao)
    if isnan(t_3tau_simulada) && t_simulacao(i) >= TMAX
        t_3tau_simulada = t_simulacao(i);
    end
    if ~isnan(t_3tau_simulada)
        break;
    end
end
index_max_simulada = find(t_simulacao == t_3tau_simulada, 1);
t_simulacao = t_simulacao(1:index_max_simulada);
curva_simulada = curva_simulada(1:index_max_simulada);

plot(t_simulacao, curva_simulada);

% Parâmetro R0
r0_simulada = (curva_simulada(64)-curva_simulada(1)) / Ic;

% Pontos para calcular os parâmetros
p1 = 0.4;
p2 = 0.8;
t1_simulada = NaN;
t2_simulada = NaN;

v_ajuste_simulada = curva_simulada - curva_simulada(97);
t_ajuste_simulada = t_simulacao - t_simulacao(97);

v_ajuste_simulada = v_ajuste_simulada(97:end);
t_ajuste_simulada = t_ajuste_simulada(97:end);

for i = 1:length(v_ajuste_simulada)
    if isnan(t1_simulada) && v_ajuste_simulada(i) >= p1 * Vn
        t1_simulada = t_ajuste_simulada(i);
    end
    if isnan(t2_simulada) && v_ajuste_simulada(i) >= p2 * Vn
        t2_simulada = t_ajuste_simulada(i);
    end
    if ~isnan(t1_simulada) && ~isnan(t2_simulada)
        break;
    end
end

% Índices e valores nos pontos
index1_simulada = find(t_ajuste_simulada == t1_simulada, 1);
v1_simulada = v_ajuste_simulada(index1_simulada);
index2_simulada = find(t_ajuste_simulada == t2_simulada, 1);
v2_simulada = v_ajuste_simulada(index2_simulada);

% Cálculo dos parâmetros C0 e kv
c0_simulada = (t1_simulada / v1_simulada - (v1_simulada * t2_simulada - t1_simulada * v2_simulada) / (v2_simulada * v2_simulada - v1_simulada * v2_simulada)) * Ic;
kv_simulada = 2 * ((v1_simulada * t2_simulada - t1_simulada * v2_simulada) / (v1_simulada * v2_simulada * v2_simulada - v1_simulada * v1_simulada * v2_simulada)) * Ic;

% Cálculo de C2 e R2
t3_simulada = NaN;
for i = 1:length(t_simulacao)
    if isnan(t3_simulada) && t_simulacao(i) >= tc_simulada + 3 * tau2
        t3_simulada = t_simulacao(i);
    end
    if ~isnan(t3_simulada)
        break;
    end
end

index3_simulada = find(t_simulacao == t3_simulada, 1);
v2f_simulada = curva_simulada(index3_simulada);

C2_simulada = (Ic * tc_simulada - (c0_simulada + (kv_simulada * v2f_simulada) / 2) * v2f_simulada) / v2f_simulada;
R2_simulada = tau2 / C2_simulada;

% Cálculo de EPR
vdis_simulada = curva_simulada(find(curva_simulada == vmax_simulada, 1) + 1);
dv_dis_simulada = vdis_simulada - v2f_simulada;
dt_dis_simulada = t3_simulada - t_simulacao(find(curva_simulada == vmax_simulada, 1) + 1);
Ileak_simulada = (C2_simulada * dv_dis_simulada) / dt_dis_simulada;
EPR_simulada = vdis_simulada / Ileak_simulada;

% Exibir os resultados para a curva simulada
disp('Resultados para a curva simulada:');
Tabela_Parametros_Simulada = table(r0_simulada, c0_simulada, kv_simulada, C2_simulada, R2_simulada, EPR_simulada, ...
    'VariableNames', {'R0', 'C0', 'kv', 'C2', 'R2', 'EPR'});
disp(Tabela_Parametros_Simulada);


