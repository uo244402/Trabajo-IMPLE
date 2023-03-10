clear all
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Generacion de parametros para ecuaciones en diferencias (discretizado de fts)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Parametros
tm = 0.015; % tiempo de muestreo [s]
fm = 1/tm; % frecuencia de muestreo 
M = 25; % kg
B = 0.5; % N/(m/s)
V = 24; % V
d = 0.2; % m
r = d/2; % m

%% Funciones de transferencia y discretizado
s = tf('s');

% speed2force (m/s to N)
F_v_s = 1/(M*s+B); % funcion transf fuerza a velocidad
v_F_z = c2d(1/F_v_s,tm,'tustin'); % discretizado de la inversa
v_F_z.variable = 'z^-1'; % cambio de variable
b_v_F_z = cell2mat(v_F_z.numerator); % numerador de la ft discretizada (v a F)
a_v_F_z = cell2mat(v_F_z.Denominator); % denominador de la ft discretizada (v a F)

% speed2pos (m/s to m)
v_x_s = 1/s; % integral de la velocidad (posicion)
v_x_z = c2d(v_x_s,tm,'tustin'); % discretizada
v_x_z.variable = 'z^-1'; % cambio a z-1
b_v_x_z = cell2mat(v_x_z.numerator); % numerador de la ft discretizada (v a x)
a_v_x_z = cell2mat(v_x_z.Denominator); % denominador de la ft discretizada (v a x)

% force2torque (N to Nm)
%Tq = F*r/i; % b0 = i/r = 20/0.2

% potencia (W)
%pot = F.*vel_lin; % potencia

% corriente (A)
%i = pot/V; % b0 = 1/V

% velocidad angular (1/s)
%vel_ang = vel_lin/r; % b0 = 1/r

