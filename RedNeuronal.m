clc;
clear;
close all;

%% =========================================================
%% 1. GENERACIÓN DE DATOS
%% =========================================================
% Parámetros del mecanismo
a = 100;
b = 120;
c = 150;
d = 180;

% Ecuación implícita y su derivada respecto a beta
F  = @(beta, alpha) (d - a*cos(alpha) - b*cos(beta)).^2 + ...
                    (a*sin(alpha) + b*sin(beta)).^2 - c^2;

dF = @(beta, alpha) 2*(d - a*cos(alpha) - b*cos(beta))*(b*sin(beta)) + ...
                    2*(a*sin(alpha) + b*sin(beta))*(b*cos(beta));

% Generar 150 valores de alpha entre 0 y 30 grados
alpha_deg = linspace(0, 30, 150);
alpha_rad = deg2rad(alpha_deg);

% Resolver con Newton-Raphson para cada alpha
beta_data = zeros(size(alpha_rad));
beta0 = 1.5;

for i = 1:length(alpha_rad)
    beta_k = beta0;
    for iter = 1:100
        f_val  = F(beta_k,  alpha_rad(i));
        df_val = dF(beta_k, alpha_rad(i));
        beta_k = beta_k - f_val / df_val;
        if abs(f_val) < 1e-10
            break;
        end
    end
    beta_data(i) = beta_k;
    beta0 = beta_k;
end

fprintf('Datos generados: %d pares (alpha, beta)\n', length(alpha_deg));

%% =========================================================
%% 2. PREPARACIÓN DE DATOS PARA LA RED
%% =========================================================
% Normalizar entradas y salidas entre 0 y 1 para mejorar el entrenamiento
alpha_min = min(alpha_deg);
alpha_max = max(alpha_deg);
beta_min  = min(beta_data);
beta_max  = max(beta_data);

alpha_norm = (alpha_deg - alpha_min) / (alpha_max - alpha_min);
beta_norm  = (beta_data  - beta_min)  / (beta_max  - beta_min);

% La red espera vectores columna -> transponer
X = alpha_norm';   % entrada:  150 x 1
Y = beta_norm';    % salida:   150 x 1

% Dividir en entrenamiento (80%) y validación (20%)
n_total = length(X);
n_train = round(0.8 * n_total);
idx = randperm(n_total);

X_train = X(idx(1:n_train))';       % 1 x n_train
Y_train = Y(idx(1:n_train))';       % 1 x n_train
X_val   = X(idx(n_train+1:end))';   % 1 x n_val
Y_val   = Y(idx(n_train+1:end))';   % 1 x n_val

%% =========================================================
%% 3. DEFINICIÓN Y ENTRENAMIENTO DE LA RED NEURONAL
%% =========================================================
% Red con una capa oculta de 10 neuronas y activación sigmoide (tansig)
net = fitnet(10, 'trainlm');
net.trainParam.showWindow = false;
net.trainParam.epochs     = 1000;
net.trainParam.goal       = 1e-6;

% Asignar partición manual
net.divideFcn = 'divideind';
net.divideParam.trainInd = idx(1:n_train);
net.divideParam.valInd   = idx(n_train+1:end);
net.divideParam.testInd  = [];

% Entrenar
[net, tr] = train(net, X', Y');

fprintf('Entrenamiento finalizado en %d épocas\n', tr.num_epochs);

%% =========================================================
%% 4. PREDICCIÓN EN alpha = 17 GRADOS
%% =========================================================
alpha_eval     = 17;
alpha_eval_norm = (alpha_eval - alpha_min) / (alpha_max - alpha_min);

% Predicción normalizada
beta_pred_norm = net(alpha_eval_norm);

% Desnormalizar
beta_pred = beta_pred_norm * (beta_max - beta_min) + beta_min;

fprintf('\nPredicción de la red neuronal en alpha = 17°:\n');
fprintf('  beta = %.6f rad\n', beta_pred);
fprintf('\nComparación con otros métodos:\n');
fprintf('  Lagrange:         1.243136 rad\n');
fprintf('  Analítico exacto: 1.243089 rad\n');
fprintf('  Red neuronal:     %.6f rad\n', beta_pred);
fprintf('  Error vs exacto:  %.2e rad (%.4f%%)\n', ...
    abs(beta_pred - 1.243089), ...
    abs(beta_pred - 1.243089)/1.243089 * 100);

%% =========================================================
%% 5. VISUALIZACIÓN
%% =========================================================
% Curva completa predicha por la red
alpha_plot_norm = linspace(0, 1, 300);
beta_plot_norm  = net(alpha_plot_norm);
alpha_plot      = alpha_plot_norm * (alpha_max - alpha_min) + alpha_min;
beta_plot       = beta_plot_norm  * (beta_max  - beta_min)  + beta_min;

% Datos originales de la tabla (7 puntos)
alpha_tabla = [0 5 10 15 20 25 30];
beta_tabla  = [1.6595 1.5434 1.4186 1.2925 1.1712 1.0585 0.9561];

figure;
plot(alpha_deg, beta_data, '.', 'Color', [0.7 0.7 0.7], ...
    'MarkerSize', 8, 'DisplayName', 'Datos generados (150 puntos)');
hold on;
plot(alpha_plot, beta_plot, 'b-', 'LineWidth', 2, ...
    'DisplayName', 'Predicción red neuronal');
plot(alpha_tabla, beta_tabla, 'ko', 'MarkerSize', 8, 'LineWidth', 1.5, ...
    'DisplayName', 'Datos originales tabla');
plot(alpha_eval, beta_pred, 'r*', 'MarkerSize', 12, 'LineWidth', 2, ...
    'DisplayName', sprintf('Pred. en 17° = %.6f rad', beta_pred));
grid on;
xlabel('\alpha (grados)');
ylabel('\beta (rad)');
title('Aproximación mediante red neuronal');
legend('Location', 'northeast');