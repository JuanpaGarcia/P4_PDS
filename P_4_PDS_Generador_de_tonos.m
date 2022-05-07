clear all;
close all;

%add each signal to an array and frequency variable
[string1_xn, f1] = audioread('string1m_fs.wav'); 
[string2_xn, f2] = audioread('string2m_fs.wav');
[string3_xn, f3] = audioread('string3m_fs.wav');
[string4_xn, f4] = audioread('string4m_fs.wav');
[string5_xn, f5] = audioread('string5m_fs.wav');

%optional reproduce de sound
%sound(string1_xn, f1);

%%
%display singals in time domain

figure;
t1 = 0:(1/f1):((1/f1) * (length(string1_xn)-1));
plot(t1,string1_xn);
xlim([0 ((1/f1) *length(string1_xn))]);
title('Señal string1m en el tiempo');

figure;
t2 = 0:(1/f2):((1/f2) * (length(string2_xn)-1));
plot(t2,string2_xn);
xlim([0 ((1/f2) *length(string2_xn))]);
title('Señal string2m en el tiempo');

figure;
t3 = 0:(1/f3):((1/f3) * (length(string3_xn)-1));
plot(t3,string3_xn);
xlim([0 ((1/f3) *length(string3_xn))]);
title('Señal string3m en el tiempo');

figure;
t4 = 0:(1/f4):((1/f4) * (length(string4_xn)-1));
plot(t4,string4_xn);
xlim([0 ((1/f4) *length(string4_xn))]);
title('Señal string4m en el tiempo');

figure;
t5 = 0:(1/f5):((1/f5) * (length(string5_xn)-1));
plot(t5,string5_xn);
xlim([0 ((1/f5) *length(string5_xn))]);
title('Señal string5m en el tiempo');
%%
%%Parte de Abstraer una serie de puntos de un alto valor en la señal


%%tomar solo los valores positivos de la señal con nuestra función
positive_signal_1 = positive_wave(string1_xn);

%Código generar la envolvente 
array_length = 250;
positive_sorrounding_signal_1 = sorround_signal(positive_signal_1,array_length);

%plot original, positive signal and sorrounding signal
figure;
tiledlayout(3,1);
nexttile

plot(t1,string1_xn)
title('Señal string1m en el tiempo');

nexttile
plot(positive_signal_1)
title('Señal string1m solo positiva');

nexttile
plot(positive_sorrounding_signal_1)
title('Señal string1m envolvente');

%repetimos el proceso para las demás señales de audio
 
positive_signal_2 = positive_wave(string2_xn);
positive_sorrounding_signal_2 = sorround_signal(positive_signal_2,array_length);
figure;
tiledlayout(3,1);
nexttile

plot(t2,string2_xn)
title('Señal string2m en el tiempo');
nexttile
plot(positive_signal_2)
title('Señal string2m solo positiva');
nexttile
plot(positive_sorrounding_signal_2)
title('Señal string2m envolvente');

positive_signal_3 = positive_wave(string3_xn);
positive_sorrounding_signal_3 = sorround_signal(positive_signal_3,array_length);
figure;
tiledlayout(3,1);
nexttile

plot(t3,string3_xn)
title('Señal string3m en el tiempo');
nexttile
plot(positive_signal_3)
title('Señal string3m solo positiva');
nexttile
plot(positive_sorrounding_signal_3)
title('Señal string3m envolvente');

positive_signal_4 = positive_wave(string4_xn);
positive_sorrounding_signal_4 = sorround_signal(positive_signal_4,array_length);
figure;
tiledlayout(3,1);
nexttile

plot(t4,string4_xn)
title('Señal string4m en el tiempo');
nexttile
plot(positive_signal_4)
title('Señal string4m solo positiva');
nexttile
plot(positive_sorrounding_signal_4)
title('Señal string4m envolvente');

positive_signal_5 = positive_wave(string5_xn);
positive_sorrounding_signal_5 = sorround_signal(positive_signal_5,array_length);
figure;
tiledlayout(3,1);
nexttile

plot(t5,string5_xn)
title('Señal string5m en el tiempo');
nexttile
plot(positive_signal_5)
title('Señal string5m solo positiva');
nexttile
plot(positive_sorrounding_signal_5)
title('Señal string5m envolvente');

%%
%Generación de la transformada de fourier de las señales
number_of_elements_in_fourier_transform = 40000;
fft_string1_xn = fft(string1_xn,number_of_elements_in_fourier_transform);
length_string1_xn = length(string1_xn);
P2 = abs(fft_string1_xn/length_string1_xn);
P1 = P2(1:length_string1_xn/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = f1 *(0:(length_string1_xn/2))/length_string1_xn;

figure;
% tiledlayout(2,1);
% nexttile
plot(f,P1);
xlim([0 2500]);
title('Single-Sided Amplitude Spectrum of string1_xn');
xlabel('f (Hz)');
ylabel('|string1_xn(f)|'); 

%comentar lo de la señal envolvente

% fft_string1_sorrounding = fft(positive_sorrounding_signal_1,number_of_elements_in_fourier_transform);
% length_string1_sorrounding_xn = length(positive_sorrounding_signal_1);
% P2 = abs(fft_string1_sorrounding/length_string1_sorrounding_xn);
% P1 = P2(1:length_string1_sorrounding_xn/2+1);
% P1(2:end-1) = 2*P1(2:end-1);
% nexttile
% plot(f,P1);
% xlim([0 4000]);
% title('Single-Sided Amplitude Spectrum of string1_envolvente');
% xlabel('f (Hz)');
% ylabel('|string1_xn(f)|'); 

%señal 2
fft_string2_xn = fft(string2_xn,number_of_elements_in_fourier_transform);
length_string2_xn = length(string2_xn);
P2 = abs(fft_string2_xn/length_string2_xn);
P1 = P2(1:length_string2_xn/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = f1 *(0:(length_string2_xn/2))/length_string2_xn;

figure;
% tiledlayout(2,1);
% nexttile
plot(f,P1);
xlim([0 2500]);
title('Single-Sided Amplitude Spectrum of string2_xn');
xlabel('f (Hz)');
ylabel('|string1_xn(f)|'); 

%señal 3
fft_string3_xn = fft(string3_xn,number_of_elements_in_fourier_transform);
length_string3_xn = length(string3_xn);
P2 = abs(fft_string3_xn/length_string3_xn);
P1 = P2(1:length_string3_xn/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = f1 *(0:(length_string3_xn/2))/length_string3_xn;

figure;
% tiledlayout(2,1);
% nexttile
plot(f,P1);
xlim([0 2500]);
title('Single-Sided Amplitude Spectrum of string3_xn');
xlabel('f (Hz)');
ylabel('|string1_xn(f)|'); 

%señal 4
fft_string4_xn = fft(string4_xn,number_of_elements_in_fourier_transform);
length_string4_xn = length(string4_xn);
P2 = abs(fft_string4_xn/length_string4_xn);
P1 = P2(1:length_string4_xn/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = f1 *(0:(length_string4_xn/2))/length_string4_xn;

figure;
% tiledlayout(2,1);
% nexttile
plot(f,P1);
xlim([0 2500]);
title('Single-Sided Amplitude Spectrum of string4_xn');
xlabel('f (Hz)');
ylabel('|string1_xn(f)|');

%señal 5
fft_string5_xn = fft(string5_xn,number_of_elements_in_fourier_transform);
length_string5_xn = length(string5_xn);
P2 = abs(fft_string5_xn/length_string5_xn);
P1 = P2(1:length_string5_xn/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = f1 *(0:(length_string5_xn/2))/length_string5_xn;

figure;
% tiledlayout(2,1);
% nexttile
plot(f,P1);
xlim([0 2500]);
title('Single-Sided Amplitude Spectrum of string5_xn');
xlabel('f (Hz)');
ylabel('|string1_xn(f)|');
%%
%Generación de espectrograma
no_pieces_s = 2000;
DFT_dots = 10000;
%Señal 1
figure;
spectrogram(string1_xn,no_pieces_s,0,DFT_dots,f1, 'yaxis');
title('Espectrograma de la señal string1_xn');
 ylim([0 4])
%Señal 2
figure;
spectrogram(string2_xn,no_pieces_s,0,DFT_dots,f2, 'yaxis');
title('Espectrograma de la señal string2_xn');
 ylim([0 4])
%Señal 3
figure;
spectrogram(string3_xn,no_pieces_s,0,DFT_dots,f3, 'yaxis');
 ylim([0 4])
title('Espectrograma de la señal string3_xn');
%Señal 4
figure;
spectrogram(string4_xn,no_pieces_s,0,DFT_dots,f4, 'yaxis');
 ylim([0 4])
title('Espectrograma de la señal string4_xn');
%Señal 5
figure;
spectrogram(string5_xn,no_pieces_s,0,DFT_dots,f5, 'yaxis');
 ylim([0 4])
title('Espectrograma de la señal string5_xn');
%%
%Generación de la onda en matlab

% Para la primera onda 
%Usar 6 ondas senoidales de frecuecuencias
%fundamental 148.29
%armonicos 73.9609,222.44,445,519.58,594.103

generated_s1 = sin(2*pi*148.29*t1) + 0.678361*sin(2*pi*73.9609*t1) + 0.2250187269*sin(2*pi*222*t1); 
generated_s1 = generated_s1+ 0.1068021*sin(2*pi*519.58*t1) + 0.10404168*sin(2*pi*594.103*t1); 
generated_s1 = generated_s1 + 0.1122066*sin(2*pi*445*t1);

%generar la envolvente por interpolar
f = array_length/((1/f1) * (length(string1_xn)-1));
t_sorround = 0:1/f: ( (1/f)* (array_length-1) );

new_sorrounding_1 = interp1(t_sorround,positive_sorrounding_signal_1,t1);

figure;
plot(t1,new_sorrounding_1);
title('Sorroundingg signal new');
%generar tono de guitarra
tono1 = new_sorrounding_1 .* generated_s1;

figure;
plot(t1,tono1);
title('Generated Signal 1');

% Para la segunda onda 
%Usar 6 ondas senoidales de frecuecuencias

generated_s2 = sin(2*pi*184.203*t2) + 0.324008208*sin(2*pi*368.611*t2) + 0.551646451*sin(2*pi*553.02*t2);
generated_s2 = generated_s2 + 0.4082825389*sin(2*pi*737*t2) + 0.061063432*sin(2*pi*992.043*t2) ;
generated_s2 = generated_s2 + 0.44251823*sin(2*pi*1106.66*t2) + 0.441064165*sin(2*pi*1291.68*t2) ;
generated_s2 = generated_s2 + 0.754699695*sin(2*pi*1476.71*t2) + 0.505166917*sin(2*pi*1662.15*t2); 
generated_s2 = generated_s2 + 0.236297409*sin(2*pi*2219.28*t2);
%generar la envolvente por interpolar
f = array_length/((1/f2) * (length(string2_xn)-1));
t_sorround = 0:1/f: ( (1/f)* (array_length-1) );

new_sorrounding_2 = interp1(t_sorround,positive_sorrounding_signal_2,t2);

figure;
plot(t2,new_sorrounding_2);
title('Sorroundingg signal 2 new');
%generar tono de guitarra
tono2 = new_sorrounding_2 .* generated_s2;

figure;
plot(t2,tono2);
title('Generated Signal 2');

% Para la tercera onda 
%Usar 6 ondas senoidales de frecuecuencias

generated_s3 = sin(2*pi*134.553*t3) + 0.568135947*sin(2*pi*269.106*t3) + 0.509614153*sin(2*pi*404.038*t3); 
generated_s3 = generated_s3 + 0.473060678*sin(2*pi*809.402*t3) + 0.225704201*sin(2*pi*945.092*t3) ;
generated_s3 = generated_s3 + 0.220656893*sin(2*pi*1081.35*t3) + 0.339939843*sin(2*pi*1217.99*t3) ;
generated_s3 = generated_s3 + 0.315972393*sin(2*pi*1492.02*t3) + 0.135849521*sin(2*pi*2186.96*t3) ;
generated_s3 = generated_s3 + 0.155626224*sin(2*pi*2328.9*t3);
%generar la envolvente por interpolar
f = array_length/((1/f3) * (length(string3_xn)-1));
t_sorround = 0:1/f: ( (1/f)* (array_length-1) );

new_sorrounding_3 = interp1(t_sorround,positive_sorrounding_signal_3,t3);

figure;
plot(t3,new_sorrounding_3);
title('Sorroundingg signal 3 new');
%generar tono de guitarra
tono3 = new_sorrounding_3 .* generated_s3;

figure;
plot(t3,tono3);
title('Generated Signal 3');

%%
 
 function y = positive_wave(x_n_signal)
    counter = 1;
     for s=1 : (length(x_n_signal)-1)
         if(x_n_signal(s) > 0)
            y(counter) = x_n_signal(s);
            counter = counter + 1;
        end
    end
 end

 function y = sorround_signal(x_n_signal,number_of_elements_in_sorrounding_signal)
 %la generamos con un promedio de ciertas muestras tomadas en un intervalo
 counter = 1;
     for s=1 : number_of_elements_in_sorrounding_signal
     data_hold=0;
       for sub_cycle=1 : ((length(x_n_signal)-1)/number_of_elements_in_sorrounding_signal)
           data_hold = data_hold + x_n_signal(counter);
           counter = counter + 1;
       end
       y(s) = data_hold/((length(x_n_signal)-1)/number_of_elements_in_sorrounding_signal);
    end
 end

%   function y = sorround_signal(x_n_signal,number_of_elements_in_sorrounding_signal)
%  %la generamos con un promedio de ciertas muestras tomadas en un intervalo
%  counter = 1;
%      for s=1 : number_of_elements_in_sorrounding_signal
%      data_hold=0;
%        for sub_cycle=1 : ((length(x_n_signal)-1)/number_of_elements_in_sorrounding_signal)
%            a = max(x_n_signal(counter));
%            if a > data_hold
%                data_hold = a;
%            end
%            data_hold = data_hold + x_n_signal(counter);
%            counter = counter + 1;
%        end
%        y(s) = data_hold;
%     end
%  end


 
 
 
 
 
 
 
 
 
 