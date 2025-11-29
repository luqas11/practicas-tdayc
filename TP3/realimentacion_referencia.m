clear all; close all; clc;

% Medición sin simulación
%load('medicion_realimentacion_referencia_2.mat')

% Medición con simulación
load('medicion_realimentacion_referencia_2.mat')

T = 0.02;

A = [ 0    1.0000         0         0;
 -171  -26         0         0;
         0         0         0    1.0000;
   -25         0         0   -6.75]


B = [  0;
   75;
         0;
         0]

C = [1 0 0 0; 0 0 1 0]
D = 0

Ad = eye(4) + A*T
Bd = B*T
Cd = C
Dd = D;

k = 0.8;

K = place(Ad,Bd,[exp(T*(k*(-10))) exp(T*(k*(-11))) exp(T*(k*(-12))) exp(T*(k*(-13)))]);
eig(Ad-Bd*K)

F = pinv(C*(inv(eye(4)-(Ad-Bd*K)))*Bd)

figure(5)
subplot(2,2,1);
hold on
plot(out.tout, out.medicion.Data(1,:))
plot(out.tout, out.medicion.Data(2,:))
plot(out.tout, out.simulacion.Data(1,:))
grid minor
legend('Medición','Estimación','Simulación');
xlim([15 70])
title('theta')

subplot(2,2,2);
hold on
plot(out.tout, out.medicion.Data(3,:))
plot(out.tout, out.medicion.Data(4,:))
plot(out.tout, out.simulacion.Data(2,:))
grid minor
legend('Medición','Estimación','Simulación');
xlim([15 70])
title('theta_{dot}')

subplot(2,2,3);
hold on
plot(out.tout, out.medicion.Data(5,:))
plot(out.tout, out.medicion.Data(6,:))
plot(out.tout, out.simulacion.Data(3,:))
plot(out.tout, out.medicion.Data(9,:))
grid minor
legend('Medición','Estimación','Simulación', 'Referencia');
xlim([15 70])
ylim([-10 10])
title('p')

subplot(2,2,4);
hold on
plot(out.tout, out.medicion.Data(7,:))
plot(out.tout, out.medicion.Data(8,:))
plot(out.tout, out.simulacion.Data(4,:))
grid minor
legend('Medición','Estimación','Simulación');
xlim([15 70])
ylim([-80 80])
title('p_{dot}')
