clc; clear all; close all;
Array = csvread('CCCD - Exemplo.txt');
t = Array(:, 1);
v = Array(:, 2);

% Criar a figura
figure;

% Configurar o fundo branco
set(gcf, 'Color', 'w');

% Plotar a curva CCCD
plot(t, v, 'b', 'LineWidth', 2);
hold on;

% Coordenadas dos pontos a serem marcados
t1 = t(248); % Exemplo: índice do ponto no eixo x
v1 = v(248); % Exemplo: valor correspondente no eixo y

indicemax = find(v == max(v));
t2 = t(indicemax);
v2 = v(indicemax);

indicev3 = find(v == 5.89393);
t3 = t(indicev3);
v3 = v(indicev3);

t4 = t(end-1);
v4 = v(end-1);

% Marcar o ponto com um símbolo e rótulo
plot(t1, v1, 'ok', 'MarkerSize', 7, 'LineWidth', 1.5); % Ponto marcado
plot(t2, v2, 'ok', 'MarkerSize', 7, 'LineWidth', 1.5);
plot(t3, v3, 'ok', 'MarkerSize', 7, 'LineWidth', 1.5);
plot(t4, v4, 'ok', 'MarkerSize', 7, 'LineWidth', 1.5);

% Adicionar rótulos nos eixos com a fonte Computer Modern
text(t1 + 1.6, v1, '$(T_1, V_1)$', 'HorizontalAlignment', 'center', ...
    'FontSize', 14, 'Interpreter', 'latex', 'FontName', 'CMU Serif');
text(t2 - 1.6, v2, '$(T_2, V_2)$', 'HorizontalAlignment', 'center', ...
    'FontSize', 14, 'Interpreter', 'latex', 'FontName', 'CMU Serif');
text(t2 + 1.6, 5.9, '$(T_3, V_3)$', 'HorizontalAlignment', 'center', ...
    'FontSize', 14, 'Interpreter', 'latex', 'FontName', 'CMU Serif');
text(t4 - 2, 0.2, '$(T_4, V_4)$', 'HorizontalAlignment', 'center', ...
    'FontSize', 14, 'Interpreter', 'latex', 'FontName', 'CMU Serif');


xlim([-1 27.5]);
ylim([0 7.4]);

% Adicionar título e legenda com a fonte Computer Modern
title('Exemplo de Curva CCCD', 'FontSize', 14, 'FontWeight', 'bold', 'FontName', 'CMU Serif');

% Remover valores numéricos dos eixos
set(gca, 'XTick', [], 'YTick', [], 'FontName', 'CMU Serif');

% Adicionar rótulos genéricos (opcional, para fins de explicação)
xlabel('Tempo (s)', 'FontSize', 14, 'FontName', 'CMU Serif');
ylabel('Tensão (V)', 'FontSize', 14, 'FontName', 'CMU Serif');


hold off;

clc;clear all;


Array = csvread('AD - Exemplo.txt');
t = Array(:, 1);
v = Array(:, 2);

Vn = max(v)

figure;

% Configurar o fundo branco
set(gcf, 'Color', 'w');

plot(t, v, 'b', 'LineWidth', 2);
hold on;

  % Pontos para calcular os parâmetros
    p1 = 0.4;
    p2 = 0.8;
    t1 = NaN;
    t2 = NaN;


    t0 = NaN;
    for i = 1:length(t)
        if isnan(t0) && t(i) > 0.00372
            t0 = t(i);
        end
        if ~isnan(t0)
            break;
        end
    end

    v0=v(find(t==t0));


    for i = 1:length(v)
        if isnan(t1) && v(i) >= p1*Vn
            t1 = t(i);
        end
        if isnan(t2) && v(i) >= p2*Vn
            t2 = t(i);
        end
        if ~isnan(t1) && ~isnan(t2)
            break;
        end
    end

       % Índices e valores nos pontos
    index1 = find(t == t1, 1);
    t1 = t(index1);
    v1 = v(index1);

    index2 = find(t == t2, 1);
    t2 = t(index2);
    v2 = v(index2);


    t3 = NaN;
    for i = 1:length(t)
        if isnan(t3) && t(i) > 14.2701
            t3 = t(i);
        end
        if ~isnan(t3)
            break;
        end
    end

v3=v(find(t==t3));

t4 = NaN;
    for i = 1:length(t)
        if isnan(t4) && t(i) > 98
            t4 = t(i);
        end
        if ~isnan(t4)
            break;
        end
    end

v4=v(find(t==t4));

t5=t(end-5);
v5=v(end-5);

% Marcar o ponto com um símbolo e rótulo
plot(t0, v0, 'ok', 'MarkerSize', 7, 'LineWidth', 1.5); % Ponto marcado
plot(t1, v1, 'ok', 'MarkerSize', 7, 'LineWidth', 1.5); % Ponto marcado
plot(t2, v2, 'ok', 'MarkerSize', 7, 'LineWidth', 1.5);
plot(t3, v3, 'ok', 'MarkerSize', 7, 'LineWidth', 1.5);
plot(t4, v4, 'ok', 'MarkerSize', 7, 'LineWidth', 1.5);
plot(t5, v5, 'ok', 'MarkerSize', 7, 'LineWidth', 1.5);

% Adicionar rótulos nos eixos com a fonte Computer Modern
text(t0 + 5, v0, '$(T_0, V_0)$', 'HorizontalAlignment', 'center', ...
    'FontSize', 14, 'Interpreter', 'latex', 'FontName', 'CMU Serif');
text(t1 + 6, v1, '$(T_1, V_1)$', 'HorizontalAlignment', 'center', ...
    'FontSize', 14, 'Interpreter', 'latex', 'FontName', 'CMU Serif');
text(t2 + 6, v2, '$(T_2, V_2)$', 'HorizontalAlignment', 'center', ...
    'FontSize', 14, 'Interpreter', 'latex', 'FontName', 'CMU Serif');
text(t3 + 6, v3 + 0.2, '$(T_3, V_3)$', 'HorizontalAlignment', 'center', ...
    'FontSize', 14, 'Interpreter', 'latex', 'FontName', 'CMU Serif');
text(t4 - 5, v4 - 0.3, '$(T_4, V_4)$', 'HorizontalAlignment', 'center', ...
    'FontSize', 14, 'Interpreter', 'latex', 'FontName', 'CMU Serif');
text(t5 - 5, v5 - 0.3, '$(T_5, V_5)$', 'HorizontalAlignment', 'center', ...
    'FontSize', 14, 'Interpreter', 'latex', 'FontName', 'CMU Serif');

xlim([-1 120]);
ylim([0 7.4]);

% Adicionar título e legenda com a fonte Computer Modern
title('Exemplo de Curva de Autodescarga', 'FontSize', 14, 'FontWeight', 'bold', 'FontName', 'CMU Serif');

% Remover valores numéricos dos eixos
set(gca, 'XTick', [], 'YTick', [], 'FontName', 'CMU Serif');

% Adicionar rótulos genéricos (opcional, para fins de explicação)
xlabel('Tempo (s)', 'FontSize', 14, 'FontName', 'CMU Serif');
ylabel('Tensão (V)', 'FontSize', 14, 'FontName', 'CMU Serif');


hold off;
clc; clear all; 


Array = csvread('CCCD V i.txt');
t = Array(:, 1);
v = Array(:, 2);
i = Array(:, 3);

% Criar a figura
figure;

% Configurar o fundo branco
set(gcf, 'Color', 'w');

% Plotar a tensão
yyaxis left
plot(t, v, 'LineWidth', 2); 
ylabel('Tensão (V)', 'FontSize', 14, 'FontName', 'CMU Serif'); 
ylim([0 6])

% Plotar a corrente
yyaxis right
plot(t, i, '--', 'LineWidth', 2); 
ylabel('Corrente (A)', 'FontSize', 14, 'FontName', 'CMU Serif'); 
ylim([-0.3 0.3])

xlim([-0.1 26.88])

% Adicionar título
title('Simulação CCCD: Tensão e Corrente no Supercapacitor', 'FontSize', 14, 'FontWeight', 'bold', 'FontName', 'CMU Serif');

% Adicionar rótulos para o eixo X
xlabel('Tempo (s)', 'FontSize', 14, 'FontName', 'CMU Serif');

grid on;

% Adicionar legendas
legend('Tensão', 'Corrente', 'Location', 'best', 'FontSize', 12, 'FontName', 'CMU Serif');


hold off;
clc; clear all; 



Array = csvread('AD V i.txt');
t = Array(:, 1);
v = Array(:, 2);
i = Array(:, 3);

% Criar a figura
figure;

% Configurar o fundo branco
set(gcf, 'Color', 'w');

% Plotar a tensão
yyaxis left
plot(t, v, 'LineWidth', 2); 
ylabel('Tensão (V)', 'FontSize', 14, 'FontName', 'CMU Serif'); 
ylim([0 5.6])

% Plotar a corrente
yyaxis right
plot(t, i, '--', 'LineWidth', 2); 
ylabel('Corrente (A)', 'FontSize', 14, 'FontName', 'CMU Serif'); 
ylim([0 0.28])

xlim([-0.1 500])

% Adicionar título
title('Simulação Autodescarga: Tensão e Corrente no Supercapacitor', 'FontSize', 14, 'FontWeight', 'bold', 'FontName', 'CMU Serif');

% Adicionar rótulos para o eixo X
xlabel('Tempo (s)', 'FontSize', 14, 'FontName', 'CMU Serif');

% Adicionar o grid para ambos os eixos
grid on;


% Adicionar legendas
legend('Tensão', 'Corrente', 'Location', 'best', 'FontSize', 12, 'FontName', 'CMU Serif');


