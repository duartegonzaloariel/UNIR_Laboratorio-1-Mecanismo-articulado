clc;
clear;
close all;

% Datos completos
alpha = [0 5 10 15 20 25 30];
beta = [1.6595 1.5434 1.4186 1.2925 1.1712 1.0585 0.9561];

% Punto donde se quiere calcular la segunda derivada
x_eval = 17;

% Seleccionar los 4 puntos más cercanos a alpha = 17
alpha_sel = [10 15 20 25];
beta_sel = [1.4186 1.2925 1.1712 1.0585];

% Ajuste polinomial de grado 3 usando los 4 puntos
p = polyfit(alpha_sel, beta_sel, 3);

% Segunda derivada del polinomio
p_der2 = polyder(polyder(p));

% Evaluar la segunda derivada en alpha = 17
beta_segunda = polyval(p_der2, x_eval);

% Mostrar resultado
fprintf('La segunda derivada de beta respecto de alpha en alpha = 17° es: %.6f\n', beta_segunda);

% Graficar el polinomio interpolante
xx = linspace(10,25,200);
yy = polyval(p, xx);

figure;
plot(alpha_sel, beta_sel, 'o', 'LineWidth', 2);
hold on;
plot(xx, yy, '-', 'LineWidth', 1.5);
plot(x_eval, polyval(p, x_eval), 'r*', 'MarkerSize', 10);
grid on;

xlabel('\alpha (grados)');
ylabel('\beta (rad)');
title('Interpolación polinomial con 4 puntos cercanos');
legend('Datos seleccionados', 'Polinomio interpolante', 'Valor en 17°');