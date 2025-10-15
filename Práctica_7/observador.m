
% Polos
p = [-8-7.8i, -8+7.8i];
K = 47.2;
[num, den] = zp2tf([], p, K);
sys_cont = tf(num, den)

T = 0.02;

A = [0 1 ; -124.8 -16];
B = [0; 47.2];
C = [1 0];
D = 0;

Ad = eye(2) + A*T
Bd = B*T
Cd = C
Dd = D;

syms a1 a2
L = [a1 ; a2];
eig(Ad - L*Cd)

k = 10;
eq1 = 29/25 - (a1^2 + (16*a1)/25 + (2*a2)/25 - 304/3125)^(1/2)/2 - a1/2 == exp(T*(k*(-8)));
eq2 = (a1^2 + (16*a1)/25 + (2*a2)/25 - 304/3125)^(1/2)/2 - a1/2 + 29/25 == exp(T*(k*(-8)));

sol = solve([eq1, eq2], [a1, a2])
a1 = sol.a1;
a2 = sol.a2;

L = [a1 ; a2]
eig(A)
eig(Ad - L*Cd)
