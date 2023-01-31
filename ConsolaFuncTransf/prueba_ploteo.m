clear all
output = csvread("output.txt");

muestras = 10000;
tm = 0.005;
t = linspace(0,muestras*tm,muestras);

figure(1)
subplot(311)
plot(t,output(:,1))
title('Force')

subplot(312)
plot(t,output(:,2))
title('Torque')

subplot(313)
plot(t,output(:,3))
title('Position')