clear all; close all; clc;

load('medicion_observador_2.mat')

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

k = 1.5;

L = place(Ad',Cd',[exp(T*(k*(-8))) exp(T*(k*(-9))) exp(T*(k*(-10))) exp(T*(k*(-11)))]);
L = L'
eig(Ad-L*Cd)

%sys_total = ss(A-B*K,B,C,D);
%[y_c, t_c, x] = impulse(7.5*sys_total, out.tout);

tout = out.tout(1:end-2);

figure(5)
subplot(2,2,1);
hold on
plot(tout, out.medicion.Data(1,:))
plot(tout, out.medicion.Data(2,:))
plot(out.tout, out.simulacion.Data(1,:))
grid minor
legend('Medición','Estimación', 'Simulación');
xlim([8 14])
title('theta')

subplot(2,2,2);
hold on
plot(tout, out.medicion.Data(3,:))
plot(tout, out.medicion.Data(4,:))
plot(out.tout, out.simulacion.Data(2,:))
grid minor
legend('Medición','Estimación', 'Simulación');
xlim([8 14])
%ylim([-200 200])
title('theta_{dot}')

subplot(2,2,3);
hold on
plot(tout, out.medicion.Data(5,:))
plot(tout, out.medicion.Data(6,:))
plot(out.tout, out.simulacion.Data(3,:))
grid minor
legend('Medición','Estimación', 'Simulación');
xlim([8 14])
title('p')

subplot(2,2,4);
hold on
plot(tout, out.medicion.Data(7,:))
plot(tout, out.medicion.Data(8,:))
plot(out.tout, out.simulacion.Data(4,:))
grid minor
legend('Medición','Estimación', 'Simulación');
xlim([8 14])
title('p_{dot}')
