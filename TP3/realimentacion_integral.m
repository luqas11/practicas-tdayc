clear all; close all; clc;

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

% graficar medición sólo en el primero
k = 0.6;
Ki = place(Adi,Bdi,[exp(T*(k*(-10))) exp(T*(k*(-11))) exp(T*(k*(-12))) exp(T*(k*(-13))) exp(T*(k*(-14)))]);
eig(Adi-Bdi*Ki)
-Ki
K = -Ki(1:end-1)
H = -Ki(end)