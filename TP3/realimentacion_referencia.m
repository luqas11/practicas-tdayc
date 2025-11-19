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

Ad = eye(4) + A*T
Bd = B*T
Cd = C
Dd = D;

k = 0.8;

K = place(Ad,Bd,[exp(T*(k*(-10))) exp(T*(k*(-11))) exp(T*(k*(-12))) exp(T*(k*(-13)))]);
eig(Ad-Bd*K)

F = pinv(C*(inv(eye(4)-(Ad-Bd*K)))*Bd)
