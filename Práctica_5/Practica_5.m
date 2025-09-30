clear all; close all; clc;
% Práctica 0
% Modelado del sistema:

% Punto a:
% Constantes del problema:
Qi = 8 / (1000*60);
d = 0.01065;
l1 = 0.1;
l2 = 0.4;
L = 0.9;
Ao = pi * (d/2)^2;
g = 9.8;

% Ecuaciones no lineales del sistema:
% h_dot = (Qi - Ao*u*sqrt(2*g*x1)) / (l1 + (x1/L)*(l2-l1))^2;

% Punto c:
% Variables del sistema de estados:
% x1 = h
% u = u
% y = h

% Valores de equilibrio
x1e = 0.45;
ue = Qi / (Ao*sqrt(2*g*x1e));
ye = x1e;

% Variables simbólicas
syms x1 u y;
x = x1;

% Ecuaciones del sistema no lineal
f = (Qi - Ao*u*sqrt(2*g*x1)) / (l1 + (x1/L)*(l2-l1))^2;
y = x1;

% Jacobianos
A = jacobian(f,x);
B = jacobian(f,u);
C = jacobian(y,x);
D = jacobian(y,u);

% Evaluación de jacobianos
A = subs(A, str2sym({'x1', 'u', 'y'}), {x1e, ue, ye});
B = subs(B, str2sym({'x1', 'u', 'y'}), {x1e, ue, ye});
C = subs(C, str2sym({'x1', 'u', 'y'}), {x1e, ue, ye});
D = subs(D, str2sym({'x1', 'u', 'y'}), {x1e, ue, ye});

A0 = eval(subs(A));
B0 = eval(subs(B));
C0 = eval(subs(C));
D0 = eval(subs(D));

% Punto d:
% Transferencia del sistema linealizado
P0 = zpk(ss(A0, B0, C0, D0))
%bode(P0)

% Diseño en Matlab:

% Punto b:
% Veo que la planta es estable, así que no necesito separar en Pap y Pmp
pole(P0)

% Parámetros del Bode
optionss=bodeoptions;
optionss.PhaseMatching='on';
optionss.PhaseMatchingValue=-180;
optionss.PhaseMatchingFreq=1;
optionss.Grid='on';

% Hago un primer diseño de control integral, veo en qué frecuencia C1*P0 resta 120°, y la elijo como mi wgc
C1 = zpk(-0.002, [0 -0.03], -1);
%bode(C1*P0, optionss)
wgc = 0.0181

% Hago un segundo diseño de control integral
% Repito el diseño anterior, pero con una ganancia que haga que C2*P tenga
% 0dB en la wgc.
k = 1/abs(evalfr(C1*P0, 1j*wgc));
C2 = C1*k
%bode(C2*P0, optionss)

% Sistema compensado
C = minreal(C2);
L = minreal(C*P0);
T = minreal(L/(1+L));

% Verificación de estabilidad
%bode(L, optionss)
closed_loop_poles = pole(T)

% Verificación de sobrepico y margen de fase
phase_margin = 180 + rad2deg(angle(evalfr(L, 1j*wgc))) % margen de fase del lazo abierto
overshoot = stepinfo(T).Overshoot % sobrepico de la respuesta al escalón del lazo cerrado
settling_time = stepinfo(T).SettlingTime % tiempo de establecimiento de la respuesta al escalón del lazo cerrado
% Si estos valores son incorrectos, reubico los polos y ceros de C1, y repito
