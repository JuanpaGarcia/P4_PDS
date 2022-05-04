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

figure;
t = 0:(1/f1):((1/f1) * (length(string1_xn)-1));
plot(t,string1_xn);
xlim([0 ((1/f1) *length(string1_xn))]);
title('Señal string1m en el tiempo');

figure;
t = 0:(1/f2):((1/f2) * (length(string2_xn)-1));
plot(t,string2_xn);
xlim([0 ((1/f2) *length(string2_xn))]);
title('Señal string2m en el tiempo');

figure;
t = 0:(1/f3):((1/f3) * (length(string3_xn)-1));
plot(t,string3_xn);
xlim([0 ((1/f3) *length(string3_xn))]);
title('Señal string3m en el tiempo');

figure;
t = 0:(1/f4):((1/f4) * (length(string4_xn)-1));
plot(t,string4_xn);
xlim([0 ((1/f4) *length(string4_xn))]);
title('Señal string4m en el tiempo');

figure;
t = 0:(1/f5):((1/f5) * (length(string5_xn)-1));
plot(t,string5_xn);
xlim([0 ((1/f5) *length(string5_xn))]);
title('Señal string5m en el tiempo');
%%






