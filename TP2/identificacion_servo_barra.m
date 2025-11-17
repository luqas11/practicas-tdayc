close all, clear all
clc
load('identificacion_servo_barra.mat')

Ts = 1/50;

t1 = 500;
t2 = 2500;

output = out.theta(t1:t2);
time = out.tout(t1:t2);
step = out.step(t1:t2);

K = 75;
[num, den] = zp2tf([], [-13+1.55i -13-1.55i], K);
sys_cont = tf(num, den)
[y_c, t_c] = lsim(sys_cont, step, time);

num = [0.02645 0 0];
den = [1 -1.552 0.6123];
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