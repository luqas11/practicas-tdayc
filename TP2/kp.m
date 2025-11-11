close all, clear all
clc
load('kp0.mat')

Ts = 1/50;

t1 = 201;
t2 = 6160;

% output = out.theta(t1:t2);
% time = out.tout(t1:t2);
% step = out.step(t1:t2);

output = out.position;
time = out.tout;


figure(1)
hold on
plot(time, output)
