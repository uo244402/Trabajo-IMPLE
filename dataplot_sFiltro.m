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

v_F_s = 1/(M*s+B); % funcion transf fuerza a velocidad
invv_F_z = c2d(1/v_F_s,tm,'tustin'); % discretizado
invv_F_z.variable = 'z^-1';
b_v_F_z = cell2mat(invv_F_z.numerator);
a_v_F_z = cell2mat(invv_F_z.Denominator);

F = zeros(length(vel_lin)+1);
for i = 1:length(vel_lin)+1
    F(i+1)=b_v_F_z.*vel_lin((i+1):i)'-a_v_F_z(2)*F(i);
end

%F = lsim(1/v_F_z,vel_lin,t); % fuerza transmitida

x_v_s = 1/s; % integral de la velocidad
x_v_z = c2d(x_v_s,tm,'tustin'); % discretizada
x_v_z.variable = 'z^-1';

x_lin = lsim(x_v_z,vel_lin,t); % desplazamiento
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

fc = 1; % frecuencia de corte (en 0.5, viendo los armonicos del ruido)
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
bode(b_filt,a_filt)

F_filtered = lsim(1/invv_F_z,vel_lin_filtered,t); % fuerza transmitida
x_lin_filtered = lsim(x_v_z,vel_lin_filtered,t); % desplazamiento
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






