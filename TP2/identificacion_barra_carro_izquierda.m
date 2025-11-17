close all, clear all
clc
load('identificacion_barra_carro_izquierda.mat')

Ts = 1/50;

% Prueba 1:
%9.52 -> 476
%t1 = 476;
%t2 = 476 + 50;
%K = -3.6;

% Prueba 2:
%29.56 -> 1478
t1 = 1478;
t2 = 1478 + 50;
%K = -3.6;

% Prueba 3:
%49.6 -> 2480
%t1 = 2480;
%t2 = 2480 + 50;
%K = -3.6;

output = out.position(t1:t2);
time = out.tout(t1:t2);
step = out.step(t1:t2);

% output = out.theta;
% time = out.tout;
% step = out.step;

K = -3.4;
[num, den] = zp2tf([], [0 -0.126], K);
sys_cont =  tf(num,den)
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