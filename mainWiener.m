
% Sinal de Audio   
[y,Fs] = audioread('audio1.mp3'); % A função 'audioread' lê o arquivo de 
%audio, sendo 'y' o sinal e 'Fs' a frequência do sinal
signal=y(1:15*Fs,1)'; % Selecionando uma faixa do sinal


% % Parâmetros do sinal
Na=length(signal);
Ts = 1/Fs;
t = (0:Na-1)*Ts; % Vetor de tempo


%FILTRANDO O SINAL COM UM FILTRO PASSA-FAIXA

% Definir a frequência central e a largura de banda do filtro
fc = 500; % Frequência central em Hz
bw = 5; % Largura de banda em Hz

% Calcular as frequências de corte
f_min = (fc - bw/2) / (Fs/2);
f_max = (fc + bw/2) / (Fs/2);

% Projetar o filtro FIR passa-banda
ordem_pf = 1000; % Ordem do filtro
coef_filter = fir1(ordem_pf, [f_min, f_max]);

%filtros em cascata
sinal_filtrado_pf1 = filter(coef_filter,1,signal);
sinal_filtrado_pf2 = filter(coef_filter,1,sinal_filtrado_pf1);
sinal_filtrado_pf3 = filter(coef_filter,1,sinal_filtrado_pf2 );


% Ruído
n = randn(1,length(t)); % Ruído gaussiano com amplitude 1

% Sinal ruidoso
x_r = sinal_filtrado_pf3 + n;



% Filtro de Wiener
ordem_wiener = 500; % Ordem do filtro de Wiener
wiener_signal = wienerFilter(x_r, sinal_filtrado_pf3, ordem_wiener);

%filtrando o resultado de saída de wiener
sinal_filtrado= filter(coef_filter,1,wiener_signal );




%Escutando o sinal original (apenas 5 segundos)
 % sinal_reduzido=y(1:5*Fs,1)'; 
 % sound(sinal_reduzido)

%Escutando o sinal ruidoso
% sinal_reduzido = x_r(1:5*Fs);
% sound(sinal_reduzido,Fs)

%Escutando o sinal filtrado com o filtro de wiener

% sinal_reduzido = signal_finaly(1:5*Fs);
% sound(sinal_reduzido,Fs)


% Plotagem dos resultados
figure;

subplot(4,1,1);
plot(t, signal);
title('Sinal Original');
xlabel('Tempo (s)');
ylabel('Amplitude');

subplot(4,1,2);
plot(t, n);
title('Ruído');
xlabel('Tempo (s)');
ylabel('Amplitude');


subplot(4,1,3);
plot(t,x_r);
title('Sinal Com Ruído');
xlabel('Tempo (s)');
ylabel('Amplitude');


subplot(4,1,4);
plot(t,sinal_filtrado);
title('Sinal Filtrado');
xlabel('Tempo (s)');
ylabel('Amplitude');


% Calcular a FFT do sinal filtrado
fft_result_filtered = fft(sinal_filtrado);

% Calcular a FFT do sinal ruidoso
fft_xr = fft(x_r);

% Rearranjar as frequências
fft_shifted_filtered = fftshift(fft_result_filtered);
fft_shifted_filtered_xr = fftshift(fft_xr);

% Calcular as frequências correspondentes
frequencies_filtered = (-length(fft_result_filtered)/2:length(fft_result_filtered)/2-1)*(Fs/length(fft_result_filtered));

% Plotar o espectro de magnitude recentralizado do sinal filtrado
figure;
subplot(2,1,1);
plot(frequencies_filtered, abs(fft_shifted_filtered));
title('Espectro de Magnitude do Sinal de Áudio Filtrado');
xlabel('Frequência (Hz)');
ylabel('Magnitude');

% Plotar o espectro de magnitude recentralizado do sinal ruidoso
subplot(2,1,2);
plot(frequencies_filtered, abs(fft_shifted_filtered_xr));
title('Espectro de Magnitude do Sinal de Áudio Ruidoso');
xlabel('Frequência (Hz)');
ylabel('Magnitude');



