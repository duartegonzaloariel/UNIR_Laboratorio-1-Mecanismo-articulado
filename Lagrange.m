% ============================================
% Polinomio de Lagrange
% ============================================
clc;
clear;
close all;

% Datos
alpha = [0 5 10 15 20 25 30];
beta = [1.6595 1.5434 1.4186 1.2925 1.1712 1.0585 0.9561];

% Punto donde queremos interpolar
x_eval = 17;

n = length(alpha);
L = zeros(1,n);

% Cálculo de los polinomios base de Lagrange
for i = 1:n
    L(i) = 1;
    for j = 1:n
        if i ~= j
            L(i) = L(i) * (x_eval - alpha(j)) / (alpha(i) - alpha(j));
        end
    end
end

% Evaluación del polinomio
beta_interp = sum(beta .* L);

fprintf('Valor interpolado de beta en alpha = 17°: %.6f rad\n', beta_interp);

% (Opcional) graficar
xx = linspace(0,30,200);
yy = zeros(size(xx));

for k = 1:length(xx)
    for i = 1:n
        Li = 1;
        for j = 1:n
            if i ~= j
                Li = Li * (xx(k) - alpha(j)) / (alpha(i) - alpha(j));
            end
        end
        yy(k) = yy(k) + beta(i)*Li;
    end
end

figure;
plot(alpha, beta, 'o', 'LineWidth', 2);
hold on;
plot(xx, yy, '-', 'LineWidth', 1.5);
plot(x_eval, beta_interp, 'r*', 'MarkerSize', 10);
grid on;

xlabel('\alpha (grados)');
ylabel('\beta (rad)');
title('Interpolación de Lagrange');
legend('Datos', 'Polinomio interpolante', 'Valor en 17°');