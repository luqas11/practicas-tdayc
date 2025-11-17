close all, clear all
clc
load('identificacion_barra_carro_derecha.mat')

Ts = 1/50;

% Prueba 1:
%129.82 -> 6491
%t1 = 6491;
%t2 = 6491 + 50;
%K = -2.7;

% Prueba 2:
%109.82 -> 5491
%t1 = 5491;
%t2 = 5491 + 50;
%K = -2.7;

% Prueba 3:
%89.76 -> 4488
t1 = 4488;
t2 = 4488+50;
%K = -2.7;

output = out.position(t1:t2);
time = out.tout(t1:t2);
step = out.step(t1:t2);

% output = out.theta;
% time = out.tout;
% step = out.step;

K = -3.15;
[num, dem] = zp2tf([], [0 -0.107], K);
sys_cont =  tf(num,dem)
[y_c, t_c] = lsim(sys_cont, step, time);

num = [-0.001388 0 0];
den = [1 -2.077 1.088];
sys_d = tf(num, den, Ts)
[y_d, t_d] = lsim(sys_d, step, time);

figure(1)
hold on
plot(time, output)
plot(time, y_d)
plot(time, y_c)
%plot(time, step)

xlim([t1/50 t2/50])
legend('Medición','Discreta','Continua');