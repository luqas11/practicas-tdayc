
% Polos
p = [-8-7.8i, -8+7.8i];
K = 47.2;
[num, den] = zp2tf([], p, K);
sys_cont = tf(num, den)

T = 0.02;

A = [0 1 0; -124.8 -16 0; 0 0 1];
B = [0; 47.2; 0];
C = [1 0 0; 0 1 1];
D = 0;

Ad = eye(3) + A*T - [0 0 0; 0 0 0; 0 0 T]
Bd = B*T
Cd = C
Dd = D;

k = 3;

L = place(Ad',Cd',[exp(T*(k*(-8))) exp(T*(k*(-8))) exp(T*(k*(-9)))]);
L = L'
eig(Ad-L*Cd)
