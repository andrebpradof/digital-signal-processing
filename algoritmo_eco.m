%% Algoritmos de filtros adaptativos para remoção de eco
%SEL0615 - Processamento Digital de Sinais

%Alunos
%Andre Baconcelo Prado Furlanetti - N USP: 10748305
%Diego da Silva Parra - N USP: 10716550
%Mateus Fernandes Doimo - N USP: 10691971

%% Limpar variaveis
clc;
clear all;
close all;

%% Entrada do audio
% Teste 1
%[x,Fs] = audioread('audio.wav');

% Teste 2
%[x,Fs] = audioread('audio_1.wav');
%[y,Fx] = audioread('audio_2.wav');


% Teste 3
[x,Fs] = audioread('audio_music.wav');
[y,Fx] = audioread('audio_music_eco.wav');

%% Efeito de eco
%alpha = 1.5; D = 8000; 
%b = [1,zeros(1,D),alpha]; 
%y = filter(b,1,x); 

%% Constantes
dt = 1/Fs;  % Transformar para segundos - periodo

%a = 0.8;              
%c = 0.8;
a = 1;    % Tamanho da etapa normalizado (0 < a < 2)              
c = 0.9;    % Fator de segurança (pequena constante positiva)
L = 1000;   % Numero de passos

N = length(y);

%% Vetores
xin = zeros(L,1);
xx = zeros(1,L);

w1 = zeros(1,L);
w2 = zeros(L,1);

f1 = 0*y;   % Funcao com eco removido LMS
f2 = 0*y;   % Funcao com eco removido NLMS
e1 = 0*y;   % Erro do LMS
e2 = 0*y;   % Erro do NLMS

%% LMS algorithm
for i=1:N
    xx = [y(i) xx(1:end-1)];
    f1(i) = w1*xx';
    error = x(i)-f1(i);
    e1(i) = error; %erro 
    %mu = 0.006;
    mu = 0.01; %Parâmetro de tamanho de etapa na amostra n
    w1 = w1 + mu*xx*error;
end

%% NLMS algorithm
for i=1:N
    xin = [y(i); xin(1:end-1)];
    f2(i) = w2'*xin;
    error = x(i)-f2(i);                       
    e2(i)=error;                            
    mu=a/(c+xin'*xin); %Parâmetro de tamanho de etapa na amostra n                      
    wtemp = w2 + 2*mu*error*xin;             
    w2 = wtemp;
end

%% Graficos de entrada e eco
figure
subplot(2,1,1)
plot(0:dt:(length(x)*dt)-dt, x,'b-')                                                
xlabel('segundos','FontSize', 12);
ylabel('x(t)','FontSize', 12);
title('Sinal de entrada: x(n)','FontSize', 14)
grid on
axis([0 ((length(x)*dt)-dt) -2 2]);

subplot(2,1,2)
plot(0:dt:(length(y)*dt)-dt,y,'b-')                                      
xlabel('segundos','FontSize', 12);
ylabel('eco(t)','FontSize', 12);
title('Sinal com Eco: y(n)','FontSize', 14)
grid on
axis([0 ((length(y)*dt)-dt) -2 2]);

%% Graficos do algoritmo LMS
figure
subplot(2,1,1)
plot(0:dt:(length(f1)*dt)-dt,f1,'b-')                                             
xlabel('segundos','FontSize', 12);
ylabel('y(t)','FontSize', 12);
title('Saída com algoritmo LMS','FontSize', 14)
grid on
axis([0 ((length(f1)*dt)-dt) -2 2]);

subplot(2,1,2)
plot(0:dt:(length(e1)*dt)-dt,e1,'r-')                                              
xlabel('segundos','FontSize', 12);
ylabel('e(t)','FontSize', 12);
title('Erro da saída LMS','FontSize', 14)
grid on
axis([0 ((length(e1)*dt)-dt) -0.4 0.4]);

%% Graficos do algoritomo NLMS
figure
subplot(2,1,1)
plot(0:dt:(length(f2)*dt)-dt,f2,'b-')                                               
xlabel('segundos','FontSize', 12);
ylabel('y(t)','FontSize', 12);
title('Saída com algoritmo NLMS','FontSize', 14)
grid on
axis([0 ((length(f2)*dt)-dt) -2 2]);

subplot(2,1,2)
plot(0:dt:(length(e2)*dt)-dt,e2,'r-')                                            
xlabel('segundos','FontSize', 12);
ylabel('e(t)','FontSize', 12);
title('Erro da saída NLMS','FontSize', 14)
grid on
axis([0 ((length(e2)*dt)-dt) -0.4 0.4]);

%% Audios
%sound(x,Fs);pause(15);  % Sinal original
%sound(y,Fs);pause(20);  % Sinal com eco
%sound(f1,Fs);pause(20); % Sinal com filtro NLMS
%sound(f2,Fs);           % Sinal com filtro NLMS    