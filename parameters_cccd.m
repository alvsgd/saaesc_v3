clc; clear all; close all;

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
    '16.12.2024 teste16 CCCD 200mA 5.5V 0ciclos.txt',
};



% Inicialização de vetores para armazenar parâmetros
Capacitance = [];
ESR = [];
Tau = [];
PowerDensity = [];
EnergyDensity = [];

% Processar cada arquivo
for i = 1:length(arquivos)
    % Carregar dados
    Array = csvread(arquivos{i});
    t = Array(:, 1);
    v = Array(:, 2);

    % Cálculo dos parâmetros
    vmax = max(v);
    v0_discharge = v(find(v == vmax) + 2);
    dv = v0_discharge - v(end);
    dt = t(end) - t(find(v == vmax) + 2);
    C = (dt * Ic) / dv;

    deltav1 = v(2) - v(1);
    esr = deltav1 / Ic;

    tau = C * esr;
    Pd = (Vn^2) / (4 * esr * m);
    Ed = (C * Vn^2 / 2) / (3600 * m);

    % Armazenar resultados
    Capacitance = [Capacitance; C];
    ESR = [ESR; esr];
    Tau = [Tau; tau];
    PowerDensity = [PowerDensity; Pd];
    EnergyDensity = [EnergyDensity; Ed];

    % Exibir a tabela de parâmetros para cada arquivo
    Tabela_Parametros = table(C, esr, tau, Pd, Ed, ...
        'VariableNames', {'Capacitância [F]', 'Resistência equivalente [Ohm]', 'Constante de Tempo [s]', 'Densidade de Potência [W/kg]', 'Densidade de Energia [Wh/kg]'});
    
    disp(['Teste CCCD', num2str(i), ':']);
    disp(Tabela_Parametros);
end



%% Cálculo das estatísticas
stats = struct();
stats.Capacitance.media = mean(Capacitance);
stats.Capacitance.desvio_padrao = std(Capacitance);
stats.Capacitance.mediana = median(Capacitance);
stats.Capacitance.min = min(Capacitance);
stats.Capacitance.max = max(Capacitance);
stats.Capacitance.MAE = mean(abs(Capacitance - stats.Capacitance.media)); % Erro Médio Absoluto
stats.Capacitance.MRE = mean(abs((Capacitance - stats.Capacitance.media) ./ stats.Capacitance.media)) * 100; % Erro Médio Relativo

stats.ESR.media = mean(ESR);
stats.ESR.desvio_padrao = std(ESR);
stats.ESR.mediana = median(ESR);
stats.ESR.min = min(ESR);
stats.ESR.max = max(ESR);
stats.ESR.MAE = mean(abs(ESR - stats.ESR.media)); % Erro Médio Absoluto
stats.ESR.MRE = mean(abs((ESR - stats.ESR.media) ./ stats.ESR.media)) * 100; % Erro Médio Relativo

stats.Tau.media = mean(Tau);
stats.Tau.desvio_padrao = std(Tau);
stats.Tau.mediana = median(Tau);
stats.Tau.min = min(Tau);
stats.Tau.max = max(Tau);
stats.Tau.MAE = mean(abs(Tau - stats.Tau.media)); % Erro Médio Absoluto
stats.Tau.MRE = mean(abs((Tau - stats.Tau.media) ./ stats.Tau.media)) * 100; % Erro Médio Relativo

stats.PowerDensity.media = mean(PowerDensity);
stats.PowerDensity.desvio_padrao = std(PowerDensity);
stats.PowerDensity.mediana = median(PowerDensity);
stats.PowerDensity.min = min(PowerDensity);
stats.PowerDensity.max = max(PowerDensity);
stats.PowerDensity.MAE = mean(abs(PowerDensity - stats.PowerDensity.media)); % Erro Médio Absoluto
stats.PowerDensity.MRE = mean(abs((PowerDensity - stats.PowerDensity.media) ./ stats.PowerDensity.media)) * 100; % Erro Médio Relativo

stats.EnergyDensity.media = mean(EnergyDensity);
stats.EnergyDensity.desvio_padrao = std(EnergyDensity);
stats.EnergyDensity.mediana = median(EnergyDensity);
stats.EnergyDensity.min = min(EnergyDensity);
stats.EnergyDensity.max = max(EnergyDensity);
stats.EnergyDensity.MAE = mean(abs(EnergyDensity - stats.EnergyDensity.media)); % Erro Médio Absoluto
stats.EnergyDensity.MRE = mean(abs((EnergyDensity - stats.EnergyDensity.media) ./ stats.EnergyDensity.media)) * 100; % Erro Médio Relativo

% Exibir estatísticas no formato solicitado
disp('Estatísticas dos Parâmetros:');
disp('--------------------------------');
parametros = {'Capacitance', 'ESR', 'Tau', 'PowerDensity', 'EnergyDensity'};

for i = 1:length(parametros)
    param = parametros{i};
    fprintf('\nParâmetro: %s\n', param);
    fprintf('Média: %.4f\n', stats.(param).media);
    fprintf('Desvio padrão: %.4f\n', stats.(param).desvio_padrao);
    fprintf('Mediana: %.4f\n', stats.(param).mediana);
    fprintf('Mínimo: %.4f\n', stats.(param).min);
    fprintf('Máximo: %.4f\n', stats.(param).max);
    fprintf('Erro Médio Absoluto (MAE): %.4f\n', stats.(param).MAE);
    fprintf('Erro Médio Relativo (MRE): %.2f%%\n', stats.(param).MRE);
end

%% Carregar a curva simulada (arquivo "Simulação CCCD 1.txt")
simulacao = csvread('Simulação CCCD 1.txt');
t = simulacao(:, 1); % Tempo da curva simulada
v = simulacao(:, 2); % Tensão da curva simulada


plot (t,v);

 % Cálculo dos parâmetros
    vmax = max(v);
    v0_discharge = v(find(v == vmax) + 40);
    dv = v0_discharge - v(end);
    dt = t(end) - t(find(v == vmax) + 40);
    C = (dt * Ic) / dv;

    deltav1 = v(64) - v(1);
    esr = deltav1 / Ic;

    tau = C * esr;
    Pd = (Vn^2) / (4 * esr * m);
    Ed = (C * Vn^2 / 2) / (3600 * m);

    % Armazenar resultados
    Capacitance = [Capacitance; C];
    ESR = [ESR; esr];
    Tau = [Tau; tau];
    PowerDensity = [PowerDensity; Pd];
    EnergyDensity = [EnergyDensity; Ed];

    % Exibir a tabela de parâmetros para cada arquivo
    Tabela_Parametros = table(C, esr, tau, Pd, Ed, ...
        'VariableNames', {'Capacitância [F]', 'Resistência equivalente [Ohm]', 'Constante de Tempo [s]', 'Densidade de Potência [W/kg]', 'Densidade de Energia [Wh/kg]'});

disp("Parâmetros Simulados:");
    disp(Tabela_Parametros);


