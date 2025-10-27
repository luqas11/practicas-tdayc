kp = 1.3;
ki = 0.6;
kd = 0.00013;
num = [47.2];
den = [1 16 124.8];
sys = tf(num, den);
ref = 0.1;

C = pid(kp, ki, kd);
T = feedback(C*sys, 1);

figure;

subplot(2,1,1);
step(T*ref);
grid on;
title('Respuesta al escalón');

subplot(2,1,2);
impulse(T);
grid on;
title('Respuesta al impulso');
