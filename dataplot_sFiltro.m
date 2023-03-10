%%
clear all

%% Datos de entrada

vel_lin=importdata('v2.txt');

N = length(vel_lin); % numero de muestras
tm = 0.015; % tiempo de muestreo [s]
fm = 1/tm; % frecuencia de muestreo 
M = 25; % kg
B = 0.5; % N/(m/s)
V = 24; % V
d = 0.2; % m
r = d/2; % m

t = 0:tm:tm*(length(vel_lin)-1);

%% Funciones de transferencia
s = tf('s');

F_v_s = 1/(M*s+B); % funcion transf fuerza a velocidad
v_F_z = c2d(1/F_v_s,tm,'tustin'); % discretizado de la inversa
v_F_z.variable = 'z^-1'; % cambio de variable
b_v_F_z = cell2mat(v_F_z.numerator); % numerador de la ft discretizada (v a F)
a_v_F_z = cell2mat(v_F_z.Denominator); % denominador de la ft discretizada (v a F)

% aplicacion de la ecuacion en diferencias (v a F)
F = zeros(length(vel_lin),1);
% for i = 2:length(vel_lin)
%     F(i)=b_v_F_z*vel_lin((i-1):i)-a_v_F_z(2)*F(i-1);
% end
for i = 2:length(vel_lin)
    acc = (vel_lin(i-1)-vel_lin(i))/tm;
    F(i)=M*acc-B*vel_lin(i);
end

v_x_s = 1/s; % integral de la velocidad (posicion)
v_x_z = c2d(v_x_s,tm,'tustin'); % discretizada
v_x_z.variable = 'z^-1'; % cambio a z-1
b_v_x_z = cell2mat(v_x_z.numerator); % numerador de la ft discretizada (v a x)
a_v_x_z = cell2mat(v_x_z.Denominator); % denominador de la ft discretizada (v a x)

% aplicacion de la ecuacion en diferencias (v a x)
x_lin = zeros(length(vel_lin),1);
for i = 2:length(vel_lin)
    x_lin(i)=b_v_x_z*vel_lin((i-1):i)-a_v_x_z(2)*x_lin(i-1);
end

pot = F.*vel_lin; % potencia
i = pot/V; % intensidad de corriente
vel_ang = vel_lin/r; % velocidad angular

%% Ploteo de señales (sin filtrar)

figure(1)
subplot(2,3,1)
plot(t,vel_lin) % ploteo de la velocidad lineal
subplot(2,3,2)
plot(t,F) % ploteo de la fuerza
subplot(2,3,3)
plot(t,x_lin) % ploteo del desplazamiento
subplot(2,3,4)
plot(t,pot)
subplot(2,3,5)
plot(t,i)
subplot(2,3,6)
plot(t,vel_ang)

%% Ampliaciones

%% 1)FFT señal muestreada
FFT_vel_lin = fft(vel_lin); % transformada rapida de fourier

% se trata la función para plotear la transformada de fourier (se coge la
% parte superior hasta la mitad de los elementos)
FFT_vel_lin=FFT_vel_lin(1:N/2+1); % elimina la mitad superior
FFT_vel_lin=FFT_vel_lin/(N/2);    % normaiza la magnitude
FFT_vel_lin(1)=FFT_vel_lin(1)/2; 
vec_f=linspace(0,fm/2,N/2+1);  % vector de frecuencias

figure(2)
subplot(211)
plot(vec_f,abs(FFT_vel_lin)) 
title('FFT sin filtrar')
xlabel('f (Hz)')
ylabel('Magnitud')

%% 2)Filtro segundo grado (Butterworth)

fc = 1; % frecuencia de corte
% fc = 0.05; % frecuencia de corte (con ec. en diferencias)
[b_filt,a_filt] = butter(2,fc/(fm/2));
vel_lin_filtered = filtfilt(b_filt,a_filt,vel_lin);

FFT_vel_lin_filtered = fft(vel_lin_filtered); % transformada rapida de fourier

% se trata la función para plotear la transformada de fourier (se coge la
% parte superior hasta la mitad de los elementos)
FFT_vel_lin_filtered=FFT_vel_lin_filtered(1:N/2+1); % elimina la mitad superior
FFT_vel_lin_filtered=FFT_vel_lin_filtered/(N/2);    % normaiza la magnitude
FFT_vel_lin_filtered(1)=FFT_vel_lin_filtered(1)/2; 
vec_f=linspace(0,fm/2,N/2+1);  % vector de frecuencias

figure(2)
subplot(212)
plot(vec_f,abs(FFT_vel_lin_filtered)) 
title('FFT filtrada')
xlabel('f (Hz)')
ylabel('Magnitud')

figure(3)
freqz(b_filt,a_filt,[],fm)

% aplicacion de la señal filtrada a las funciones de transf.

% aplicacion de la ecuacion en diferencias (v a F)
F_filtered = zeros(length(vel_lin),1);
% for i = 2:length(vel_lin)
%     F_filtered(i)=b_v_F_z*vel_lin_filtered((i-1):i)-a_v_F_z(2)*F_filtered(i-1);
% end
for i = 2:length(vel_lin)
    acc = (vel_lin_filtered(i-1)-vel_lin_filtered(i))/tm;
    F_filtered(i)=M*acc-B*vel_lin_filtered(i);
end

x_lin_filtered = zeros(length(vel_lin),1);
for i = 2:length(vel_lin)
    x_lin_filtered(i)=b_v_x_z*vel_lin_filtered((i-1):i)-a_v_x_z(2)*x_lin_filtered(i-1);
end

pot_filtered = F_filtered.*vel_lin_filtered; % potencia
i_filtered = pot_filtered/V; % intensidad de corriente
vel_ang_filtered = vel_lin_filtered/r; % velocidad angular

figure(4)
subplot(2,3,1)
plot(t,vel_lin_filtered) % ploteo de la velocidad lineal
title('vel lin filtered')
subplot(2,3,2)
plot(t,F_filtered) % ploteo de la fuerza
title('F filtered')
subplot(2,3,3)
plot(t,x_lin_filtered) % ploteo del desplazamiento
title('x lin filtered')
subplot(2,3,4)
plot(t,pot_filtered)
title('pot filtered')
subplot(2,3,5)
plot(t,i_filtered)
title('i filtered')
subplot(2,3,6)
plot(t,vel_ang_filtered)
title('vel ang filtered')






