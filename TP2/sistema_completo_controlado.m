close all, clear all
clc
load('medicion_pd_imp.mat') 
% load('pd_imp.mat') 
t1 = 31*50;
t2 = 34*50;
out_temp = struct();
out_temp.position = double(out.position(t1:t2));
out_temp.pos_ref = double(out.ref(t1:t2));
out_temp.tout = double(out.tout(t1:t2));
out_temp.action = double(out.action(t1:t2));
out = out_temp;

A1 = [0 1;-171 -26];
B1 = [0; 75];
C1 = [1 0];
D1 = 0;


A2 = [0 1;0 -6.71];
B2 = [0; -25];
C2 = [1 0];
D2 = 0;

n1 = size(A1,1);
n2 = size(A2,1);

A = [ A1               zeros(n1,n2) ;
      B2*C1            A2           ];

B = [ B1          ;
      B2*D1       ];
      
C = [ D2*C1   C2  ];

D =  D2*D1;  



sys1 = ss(A1,B1,C1,D1);   % Servo + Barra
sys2 = ss(A2,B2,C2,D2);   % Barra + Carro

sys_total = ss(A,B,C,D);
G_total = tf(sys_total);

%figure(1); bode(G_total); grid on
%[GM, PM, Wcg, Wcp] = margin(G_total);   % márgenes de ganancia y fase
%GM_dB = 20*log10(GM);                     % GM en dB
%disp([GM_dB, PM, Wcg, Wcp])

p = pole(G_total);
z = zero(G_total);
% 
% figure(2)
% rlocus(G_total)


%%
close all

Ts = 0.02;
position = out.position;
time = out.tout;
%angle = double(out.angle(t1:end));
%action = out.action(t1:end);
pos_ref = out.pos_ref;
action = out.action;

s=tf('s');


%%%%%%%%% P %%%%%%%%%%%%%%%%%%%
%k0 =4;
%Kp = k0*0.25;
%Ki = 0;
%Kd = 0;

%%%%%%%%% PI %%%%%%%%%%%%%%%%%%%
 %k0 = 3;
 %Kp = k0*0.4;  
 %Ki = k0*0.2;
 %Kd = 0; 


%%%%%%%%% PD %%%%%%%%%%%%%%%%%%%
k0 = 4;
Kp = k0*0.4;
Ki = 0;
Kd = k0*0.0001;

% --- PID controller ---
Cd = Kd*s + Kp + Ki/s;
Cd = -Cd; 

L=minreal(G_total*Cd);
L_lc = minreal(L /(1 + L)); 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[y_c, t_c] = impulse(-L_lc, time)

%[y_c, t_c] = lsim(L_lc, pos_ref, time);
% 
figure(2)
hold on
grid minor
plot(t_c, y_c)
plot(time, position)
%plot(time, pos_ref)
legend('Planta identificada','Medición','Posicion de Referencia');
xlim([t1/50 t2/50])

%figure(4)
%hold on
%grid minor
%plot(time, action)
%plot(time, pos_ref)
%legend('Respuesta del actuador','Posicion de Referencia');
%xlim([t1/50 t2/50])