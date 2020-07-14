%% 

%% 
clc;
clear all;
close all;

%% Entrada do audio
%[y,Fs] = audioread('audio.wav');
[y,Fs] = audioread('audio_1.wav');
[x,Fx] = audioread('audio_2.wav');

%% Efeito de eco
%alpha = 1.5; D = 8000; 
%b = [1,zeros(1,D),alpha]; 
%x = filter(b,1,y); 

%% Constantes
dt = 1/Fs;

%a = 0.8;              
%c = 0.8;
a = 0.9;              
c = 0.9;
L = 1000;

N = length(x);

%% Vetores
xin = zeros(L,1);
xx = zeros(1,L);

w1 = zeros(1,L);
w2 = zeros(L,1);

f1 = 0*x;
f2 = 0*x;
e1 = 0*x;
e2 = 0*x;

%% LMS algorithm
for i=1:N
    xx = [x(i) xx(1:end-1)];
    f1(i) = w1*xx';
    error = y(i)-f1(i);
    e1(i) = error; 
    %mu = 0.006;
    mu = 0.01;
    w1 = w1 + mu*xx*error;
end

%% NLMS algorithm
for i=1:N
    xin = [x(i); xin(1:end-1)];
    f2(i) = w2'*xin;
    error = y(i)-f2(i);                       
    e2(i)=error;                            
    mu=a/(c+xin'*xin);                      
    wtemp = w2 + 2*mu*error*xin;             
    w2 = wtemp;
end

%% Graficos de entrada e eco
figure
subplot(2,1,1)
plot(0:dt:(length(y)*dt)-dt, y,'b-')                                                
xlabel('segundos','FontSize', 12);
ylabel('x(t)','FontSize', 12);
title('Sinal de entrada: x(n)','FontSize', 14)
grid on
axis([0 ((length(y)*dt)-dt) -2 2]);

subplot(2,1,2)
plot(0:dt:(length(x)*dt)-dt,x,'b-')                                      
xlabel('segundos','FontSize', 12);
ylabel('eco(t)','FontSize', 12);
title('Sinal com Eco: y(n)','FontSize', 14)
grid on
axis([0 ((length(x)*dt)-dt) -2 2]);

%% Graficos do algoritmo LMS
figure
subplot(2,1,1)
plot(0:dt:(length(f1)*dt)-dt,f1,'b-')                                             
xlabel('segundos','FontSize', 12);
ylabel('y(t)','FontSize', 12);
title('Saída com algoritmo LMS','FontSize', 14)
grid on

subplot(2,1,2)
plot(0:dt:(length(e1)*dt)-dt,e1,'r-')                                              
xlabel('segundos','FontSize', 12);
ylabel('e(t)','FontSize', 12);
title('Erro da saída LMS','FontSize', 14)
grid on

%% Graficos do algoritomo NLMS
figure
subplot(2,1,1)
plot(0:dt:(length(f2)*dt)-dt,f2,'b-')                                               
xlabel('segundos','FontSize', 12);
ylabel('y(t)','FontSize', 12);
title('Saída com algoritmo NLMS','FontSize', 14)
grid on

subplot(2,1,2)
plot(0:dt:(length(e2)*dt)-dt,e2,'r-')                                            
xlabel('segundos','FontSize', 12);
ylabel('e(t)','FontSize', 12);
title('Erro da saída NLMS','FontSize', 14)
grid on

%% Audios
%sound(y,Fs);pause(15);
sound(x,Fs);pause(20);
sound(f1,Fs);pause(20);
sound(f2,Fs);