clear all; close all; clc;

load('medicion_realimentacion_integral.mat')

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

C2 = [0 0 1 0]
Ai = [A zeros(4,1); C2 0]

Ad = eye(4) + A*T
Bd = B*T
Cd = C
Dd = D;

Cd2 = C2

Adi = [Ad zeros(4,1); -Cd2*T eye(1)]
Bdi = [Bd; 0]
Cdi = [Cd2 0]

k = 0.6;
Ki = place(Adi,Bdi,[exp(T*(k*(-10))) exp(T*(k*(-11))) exp(T*(k*(-12))) exp(T*(k*(-13))) exp(T*(k*(-14)))]);
eig(Adi-Bdi*Ki)
-Ki
K = -Ki(1:end-1)
H = -Ki(end)

tout = out.tout(1:end-8);

figure(5)
subplot(2,2,1);
hold on
plot(tout, out.medicion.Data(1,:))
plot(tout, out.medicion.Data(2,:))
plot(out.tout, out.simulacion.Data(:,1))
grid minor
legend('Medición','Estimación','Simulación');
xlim([3 51])
ylim([-10 10])
title('theta')

subplot(2,2,2);
hold on
plot(tout, out.medicion.Data(3,:))
plot(tout, out.medicion.Data(4,:))
plot(out.tout, out.simulacion.Data(:,2))
grid minor
legend('Medición','Estimación','Simulación');
xlim([3 51])
ylim([-100 100])
title('theta_{dot}')

subplot(2,2,3);
hold on
plot(tout, out.medicion.Data(5,:))
plot(tout, out.medicion.Data(6,:))
plot(out.tout, out.simulacion.Data(:,3))
plot(tout, out.medicion.Data(9,:))
grid minor
legend('Medición','Estimación','Simulación', 'Referencia');
xlim([3 51])
ylim([-10 10])
title('p')

subplot(2,2,4);
hold on
plot(tout, out.medicion.Data(7,:))
plot(tout, out.medicion.Data(8,:))
plot(out.tout, out.simulacion.Data(:,4))
grid minor
legend('Medición','Estimación','Simulación');
xlim([3 51])
ylim([-100 100])
title('p_{dot}')
