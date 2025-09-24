% Transferencia del sistema
sys_cont
%bode(sys_cont)
pole(sys_cont)

% Parámetros del Bode
optionss=bodeoptions;
optionss.PhaseMatching='on';
optionss.PhaseMatchingValue=-180;
optionss.PhaseMatchingFreq=1;
optionss.Grid='on';

% Hago un primer diseño de control integral, veo en qué frecuencia C1*P0 resta 120°, y la elijo como mi wgc
C1 = zpk([], [0], 1);
%bode(C1*sys_cont, optionss)
wgc = 4.1

% Hago un segundo diseño de control integral
% Repito el diseño anterior, pero con una ganancia que haga que C2*P tenga
% 0dB en la wgc.
k = 1/abs(evalfr(C1*sys_cont, 1j*wgc));
C2 = C1*k
%bode(C2*sys_cont, optionss)

% Sistema compensado
C = minreal(C2);
L = minreal(C*sys_cont);
T = minreal(L/(1+L));

% Verificación de estabilidad
%bode(L, optionss)
closed_loop_poles = pole(T)

% Verificación de sobrepico y margen de fase
phase_margin = 180 + rad2deg(angle(evalfr(L, 1j*wgc))) % margen de fase del lazo abierto
overshoot = stepinfo(T).Overshoot % sobrepico de la respuesta al escalón del lazo cerrado
settling_time = stepinfo(T).SettlingTime % tiempo de establecimiento de la respuesta al escalón del lazo cerrado
% Si estos valores son incorrectos, reubico los polos y ceros de C1, y repito

%step(T)

Ts = 0.02;
num = [k*Ts]; 
den = [1 -1];
C_f = tf(num, den, Ts)
L_f = minreal(C_f*sys);
T_f = minreal(L_f/(1+L_f));

num = [k*Ts k*Ts]; 
den = [2 -2];
C_b = tf(num, den, Ts)
L_b = minreal(C_b*sys);
T_b = minreal(L_b/(1+L_b));

figure
hold on
step(T)
step(T_f)
step(T_b)

legend('Continua', 'Discreta forward', 'Discreta bilineal');
