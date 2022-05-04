clear all;
close all;

%add each signal to an array and frequency variable
[string1_xn, f1] = audioread('string1m_fs.wav'); 
[string2_xn, f2] = audioread('string2m_fs.wav');
[string3_xn, f3] = audioread('string3m_fs.wav');
[string4_xn, f4] = audioread('string4m_fs.wav');
[string5_xn, f5] = audioread('string5m_fs.wav');

%optional reproduce de sound
%sound(string5_xn, f1);

%%
%display singals in time domain
% 
% figure;
% t = 0:(1/f1):((1/f1) * (length(string1_xn)-1));
% plot(t,string1_xn);
% xlim([0 ((1/f1) *length(string1_xn))]);
% title('Señal string1m en el tiempo');
% 
% figure;
% t = 0:(1/f2):((1/f2) * (length(string2_xn)-1));
% plot(t,string2_xn);
% xlim([0 ((1/f2) *length(string2_xn))]);
% title('Señal string2m en el tiempo');
% 
% figure;
% t = 0:(1/f3):((1/f3) * (length(string3_xn)-1));
% plot(t,string3_xn);
% xlim([0 ((1/f3) *length(string3_xn))]);
% title('Señal string3m en el tiempo');
% 
% figure;
% t = 0:(1/f4):((1/f4) * (length(string4_xn)-1));
% plot(t,string4_xn);
% xlim([0 ((1/f4) *length(string4_xn))]);
% title('Señal string4m en el tiempo');
% 
% figure;
% t = 0:(1/f5):((1/f5) * (length(string5_xn)-1));
% plot(t,string5_xn);
% xlim([0 ((1/f5) *length(string5_xn))]);
% title('Señal string5m en el tiempo');
%%
%%Parte de Abstraer una serie de puntos de un alto valor en la señal


%%tomar solo los valores positivos de la señal con nuestra función
positive_signal_1 = positive_wave(string1_xn);

%Código generar la envolvente 
array_length = 200;
positive_sorrounding_signal = sorround_signal(positive_signal_1,array_length);

%plot original, positive signal and sorrounding signal
figure;
tiledlayout(3,1);
nexttile
t = 0:(1/f1):((1/f1) * (length(string1_xn)-1));
plot(t,string1_xn)
title('Señal string1m en el tiempo');

nexttile
plot(positive_signal_1)
title('Señal string1m solo positiva');

nexttile
plot(positive_sorrounding_signal)
title('Señal string1m envolvente');

%repetimos el proceso para las demás señales de audio
 
positive_signal_2 = positive_wave(string2_xn);
positive_sorrounding_signal_2 = sorround_signal(positive_signal_2,array_length);
figure;
tiledlayout(3,1);
nexttile
t = 0:(1/f1):((1/f1) * (length(string2_xn)-1));
plot(t,string2_xn)
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
t = 0:(1/f1):((1/f1) * (length(string3_xn)-1));
plot(t,string3_xn)
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
t = 0:(1/f1):((1/f1) * (length(string4_xn)-1));
plot(t,string4_xn)
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
t = 0:(1/f1):((1/f1) * (length(string5_xn)-1));
plot(t,string5_xn)
title('Señal string5m en el tiempo');
nexttile
plot(positive_signal_5)
title('Señal string5m solo positiva');
nexttile
plot(positive_sorrounding_signal_5)
title('Señal string5m envolvente');
 
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

