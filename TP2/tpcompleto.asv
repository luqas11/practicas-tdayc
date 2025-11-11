close all, clear all
clc
load('pi_ref10v2.mat') 

A1 = [0 1;-102.4 -20];
B1 = [0; 48.5];
C1 = [1 0];
D1 = 0;


A2 = [0 1;0 -9.382];
B2 = [0; -30];
C2 = [1 0];
D2 = 0;

sys1 = ss(A1,B1,C1,D1);   % Servo + Barra
sys2 = ss(A2,B2,C2,D2);   % Barra + Carro

% Conexión en serie
sys_total = series(sys1, sys2);

% Extraer matrices equivalentes
[A,B,C,D] = ssdata(sys_total)

G_total = tf(sys_total);

% figure(1); bode(G_total); grid on
% [GM, PM, Wcg, Wcp] = margin(G_total);   % márgenes de ganancia y fase
% GM_dB = 20*log10(GM);                     % GM en dB
% disp([GM_dB, PM, Wcg, Wcp])

p = pole(G_total)
z = zero(G_total);
% 
% figure(2)
% rlocus(G_total)


%%
close all

Ts = 0.02;
t1 = 10/Ts; %17.48/Ts;
t2 = 100/Ts;%24.2/Ts;
position = double(out.position(t1:end));
time = out.tout(t1:end);
angle = double(out.angle(t1:end));
action = out.action(t1:end);
pos_ref = out.pos_ref(t1:end);

s=tf('s')

% k0 =4;
% Kp = k0*0.25; %% k0*0.45 ; 
% Ki = 0;
% Kd = 0; %%k0*0.00005;

%%%%%%%%% PD %%%%%%%%%%%%%%%%%%%
% k0 =2.5;
% Kp = k0*0.4;  
% Ki = k0*0.2;
% Kd = 0; 


%%%%%%%%% PI %%%%%%%%%%%%%%%%%%%
 k0 =2.5;
 Kp = k0*0.4;
 Ki = 0;
 Kd = k0*0.0001;

% --- PID controller ---
Cd = Kd*s + Kp + Ki/s;
Cd = -Cd; 

L=minreal(G_total*Cd);
L_lc = minreal(L /(1 + L)); 


[y_c, t_c] = lsim(L_lc, pos_ref, time);

figure(2)
hold on
grid minor
plot(t_c, y_c)
plot(time, position)
plot(time, pos_ref)
legend('Planta identificada','Medición','Posicion de Referencia');
xlim([10 100])



% figure(3)
% hold on
% grid minor
% plot(t_c, y_c)
% legend('Action de entrada');
% xlim([0 8])
