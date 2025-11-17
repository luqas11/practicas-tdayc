%clear all, close all
%clc

load('identificacion_barra_carro_izquierda.mat')
out_temp = struct();
out_temp.position = out.position;
out_temp.angle = out.theta;
out_temp.action = out.step;
out_temp.tout = out.tout;
out = out_temp;
% 
% alpha = zeros (6,3);

Ts = 0.02;
t1 = int32(9.52/Ts); %17.48/Ts;
t2 = 10.52/Ts;%24.2/Ts;
position = double(out.position(t1:t2));
time = out.tout(t1:t2);
angle = double(out.angle(t1:t2));
action = out.action(t1:t2);


position_filt = function_identificacion(position, 3);
angle_filt = function_identificacion(angle, 5);
u = angle_filt(3:end);
alpha(1,:) = function_regresion(position_filt, angle_filt);
%%
t1 = 29.56/Ts; %17.48/Ts;
t2 = 30.56/Ts;%24.2/Ts;
position = double(out.position(t1:t2));
time = out.tout(t1:t2);
angle = double(out.angle(t1:t2));
action = out.action(t1:t2);
position_filt = function_identificacion(position, 3);
angle_filt = function_identificacion(angle, 5);
u = angle_filt(3:end);
alpha(2,:) = function_regresion(position_filt, angle_filt);
%%
t1 = 49.6/Ts; %17.48/Ts;
t2 = 50.6/Ts;%24.2/Ts;
position = double(out.position(t1:t2));
time = out.tout(t1:t2);
angle = double(out.angle(t1:t2));
action = out.action(t1:t2);
position_filt = function_identificacion(position, 3);
angle_filt = function_identificacion(angle, 5);
u = angle_filt(3:end);
alpha(3,:) = function_regresion(position_filt, angle_filt);
%% Carga de mediciones con caída a la derecha 
load('identificacion_barra_carro_derecha.mat')
out_temp = struct();
out_temp.position = out.position;
out_temp.angle = out.theta;
out_temp.action = out.step;
out_temp.tout = out.tout;
out = out_temp;

t1 = int32(89.76/Ts); %17.48/Ts;
t2 = int32(90.76/Ts);%24.2/Ts;
position = double(out.position(t1:t2));
time = out.tout(t1:t2);
angle = double(out.angle(t1:t2));
action = out.action(t1:t2);
position_filt = function_identificacion(position, 3);
angle_filt = function_identificacion(angle, 5);
u = angle_filt(3:end);
alpha(4,:) = function_regresion(position_filt, angle_filt);
%%
t1 = 109.82/Ts; %17.48/Ts;
t2 = 110.82/Ts;%24.2/Ts;
position = double(out.position(t1:t2));
time = out.tout(t1:t2);
angle = double(out.angle(t1:t2));
action = out.action(t1:t2);
position_filt = function_identificacion(position, 3);
angle_filt = function_identificacion(angle, 5);
u = angle_filt(3:end);
alpha(5,:) = function_regresion(position_filt, angle_filt);
%%
t1 = 129.82/Ts; %17.48/Ts;
t2 = 130.82/Ts;%24.2/Ts;
position = double(out.position(t1:t2));
time = out.tout(t1:t2);
angle = double(out.angle(t1:t2));
action = out.action(t1:t2);
position_filt = function_identificacion(position, 3);
angle_filt = function_identificacion(angle, 5);
u = angle_filt(3:end);
alpha(6,:) = function_regresion(position_filt, angle_filt);
alpha
alpha_prom = mean(alpha, 1)
%%
close all 
num = [alpha_prom(3) 0 0]; 
den = [1 -alpha_prom(1) -alpha_prom(2)];
Ts = 0.02;

sys_d = tf(num, den, Ts)
[y_, t_] = lsim(sys_d, u, time(1:end-2));

% p_cont = log(pole(sys))/Ts 
% K = - 9.5;
% [num, dem] = zp2tf([],p_cont,K);

beta1 = 1/(alpha_prom(1)-1)
pole1 = log(beta1)/Ts

beta2 = 1/alpha_prom(2)
pole2 = log(beta2)/Ts

K = - 25;
[num, dem] = zp2tf([],[0 pole1],K);
sys_cont =  tf(num,dem)
[y_2, t_2] = lsim(sys_cont, u, time(1:end-2));

% K = - 0.005;
% [num, dem] = zp2tf([],[1 (beta1+0.05)],K);
% sys_d2 =  tf(num,dem, Ts)
% [y_d2, t_d2] = lsim(sys_d2, u, time(1:end-2));

figure(5)
hold on
plot(time, position_filt)
plot(t_, y_)
plot(t_2, y_2)
grid minor
legend('Medición','Discreta' ,'Continua');
