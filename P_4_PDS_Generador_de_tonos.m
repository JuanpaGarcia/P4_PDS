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


 %%tomar solo los valores positivos de la señal 
 counter = 1;
 for s=1 : (length(string1_xn)-1)
     if(string1_xn(s) > 0)
         positive_signal(counter) = string1_xn(s);
         counter = counter + 1;
     end
 end
 %Graficar la parte positiva de nuestra señal
 figure;
 plot(positive_signal);
 title('Señal string1m solo positiva');

%Código generar la envolvente 
%la generamos con un promedio de ciertas muestras tomadas en un intervalo

positive_sorrounding_signal=0;
counter = 1;
sub_cycle = 1;

number_of_elements_in_sorrounding_signal = 200; %variando este parametro nos acercamos más o menos a una señal continua 

 for s=1 : number_of_elements_in_sorrounding_signal
     data_hold=0;
       for sub_cycle=1 : ((length(positive_signal)-1)/number_of_elements_in_sorrounding_signal)
           data_hold = data_hold + positive_signal(counter);
           counter = counter + 1;
       end
       positive_sorrounding_signal(s) = data_hold/((length(positive_signal)-1)/number_of_elements_in_sorrounding_signal);
 end
 
 figure;
 plot(positive_sorrounding_signal);
 title('Señal como linea continua o envolvente');


