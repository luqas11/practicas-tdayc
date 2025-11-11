close all, clear all
clc
load('identificacion-v2.mat')

Ts = 1/50;

t1 = 201;
t2 = 6160;

output = out.theta(t1:t2);
time = out.tout(t1:t2);
step = out.step(t1:t2);

% output = out.theta;
% time = out.tout;
% step = out.step;

figure(1)
hold on
plot(time, output)
plot(time, step)

%%
% Identificación de parametros
close all

y = output(3:end);
x1 = output(2:end-1);
x2 = output(1:end-2);
u = step(3:end);

x = [x1 x2 u];

alpha = inv(x' * x) * x' * y;

num = [alpha(3) 0 0]; 
den = [1 -alpha(1) -alpha(2)];
Ts = 0.02;
sys_d = tf(num, den, Ts);

[y_d, t_d] = lsim(sys_d, u, time(1:end-2));

p_cont = log(pole(sys_d))/Ts 
K = 100.1;

[num, dem] = zp2tf([],p_cont,K);
sys_cont =  tf(num,dem)
[y_2, t_2] = lsim(sys_cont, u, time(1:end-2));

figure(2)
hold on
plot(time, output)
plot(t_d, y_d)
plot(t_2, y_2)
grid minor
xlim([10 20])
legend('Medición','Discreta','Continuo estimado');