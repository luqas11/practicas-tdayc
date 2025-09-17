% Las muestras que tomamos de la planta
output = out.d1;
time = out.tout;
u = out.d2;

% Tomamos sólo de t=5 a t=50
mask = (time >= 5) & (time <= 50);
time = time(mask);
output = output(mask);
u = u(mask);

%figure
%hold on
%plot(time, output)
%plot(time, u)

y = output(3:end);
x1 = output(2:end-1);
x2 = output(1:end-2);
u = u(3:end);

x = [x1 x2 u];

alpha = inv(x' * x) * x' * y;

num = [alpha(3) 0 0]; 
den = [1 -alpha(1) -alpha(2)];
Ts = 0.02;
sys = tf(num, den, Ts);

[y_, t_] = lsim(sys, u, time(1:end-2));

figure
hold on
plot(time, output)
plot(t_, y_)

sys_cont = d2c(sys)

[y_, t_] = lsim(sys_cont, u, time(1:end-2));

plot(t_, y_)

legend('Medición', 'Continua', 'Discreta');