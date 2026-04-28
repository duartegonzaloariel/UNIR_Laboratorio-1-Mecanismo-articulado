% ============================================
% DERIVADA NUMERICA POR DIFERENCIAS FINITAS
% ============================================

clc;
clear;
close all;

% Datos de la tabla
alpha_deg = [0 5 10 15 20 25 30];
beta = [1.6595 1.5434 1.4186 1.2925 1.1712 1.0585 0.9561];

% Convertir alpha a radianes
alpha = deg2rad(alpha_deg);

% Paso
h = alpha(2) - alpha(1);

% Vector para guardar la derivada
dbeta_dalpha = zeros(size(beta));

% Diferencia progresiva de orden 2 para alpha = 0
dbeta_dalpha(1) = (-3*beta(1) + 4*beta(2) - beta(3)) / (2*h);

% Diferencia central de orden 2 para puntos intermedios
for i = 2:length(beta)-1
    dbeta_dalpha(i) = (beta(i+1) - beta(i-1)) / (2*h);
end

% Diferencia regresiva de orden 2 para alpha = 30
n = length(beta);
dbeta_dalpha(n) = (3*beta(n) - 4*beta(n-1) + beta(n-2)) / (2*h);

% Mostrar resultados en tabla
T = table(alpha_deg', beta', dbeta_dalpha', ...
    'VariableNames', {'alpha_deg', 'beta_rad', 'dbeta_dalpha'});

disp(T);

% Graficar beta
figure;
plot(alpha_deg, beta, 'o-', 'LineWidth', 2);
grid on;
xlabel('\alpha (grados)');
ylabel('\beta (rad)');
title('\beta en función de \alpha');

% Graficar derivada
figure;
plot(alpha_deg, dbeta_dalpha, 'o-', 'LineWidth', 2);
grid on;
xlabel('\alpha (grados)');
ylabel('d\beta/d\alpha');
title('Derivada numérica de \beta respecto de \alpha');