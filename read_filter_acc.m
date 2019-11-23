%%PLOT E ANALISI DATI IMU
%Race UP Team - 2019

%NOTE
    %ACCELEROMETRO:
        %L'IMU è posizionato sul fianco DX del pilota, il "sopra" guarda l'interno
        %della vettura.
        %L'asse x e' normale: coincide con l'asse longitudinale della macchina, il
        %verso e' concorde con l'avanzare della vettura.
        %L'asse y e' verticale, come se fosse l'asse z.
        %L'asse z e'come se fosse l'asse y, a segno invertito.
    %TEMPO:
        %Il tempo e' espresso in millisecondi. Il primo istante non e' 0 ma
        %il tempo trascorso dopo la configurazione del dispositivo.


%apertura file di log
fid = fopen('LOG2.TXT');
data = textscan(fid, '%f,%f,%f,%f,%f,%f,%f,%f,%f,%f');
fclose(fid);

%creazione array dati
t = data{1};
accX = data{2};
accY = data{3};
accZ = data{4};
gyroX = data{5};
gyroY= data{6};
gyroZ = data{7};
angleX = data{8};
angleY = data{9};
angleZ = data{10};

figure('Name','Raw Data');
subplot(3,1,1)
plot(t,accX)
grid on;
grid minor;
title('accX')

subplot(3,1,2)
plot(t,accY)
grid on;
grid minor;
title('accY')

subplot(3,1,3)
plot(t,accZ)
grid on;
grid minor;
title('accZ')

%SEGMENTATION AND PLOT
%accX=accX
%accY=-accZ
%accZ=accY
t=t(10000:14500);
Real_accX=accX(10000:14500);
Real_accY=-accZ(10000:14500);
Real_accZ=accY(10000:14500);

figure('Name','Raw Data - 1 Stint');
subplot(3,1,1)
plot(t,Real_accX)
grid on;
grid minor;
title('accX')

subplot(3,1,2)
plot(t,Real_accY)
grid on;
grid minor;
title('accY')

subplot(3,1,3)
plot(t,Real_accZ)
grid on;
grid minor;
title('accZ')

%PREPROCESSING
%all following steps are based only on the first stint
figure('Name','Spectrogram');
spectrogram (Real_accX,[],[],[],[],'yaxis')

filt=designfilt('lowpassiir', 'PassbandFrequency', .10, 'StopbandFrequency', .15, 'PassbandRipple', 1, 'StopbandAttenuation', 60);

preproc_accX=filtfilt(filt,Real_accX);
preproc_accY=filtfilt(filt,Real_accY);
preproc_accZ=filtfilt(filt,Real_accZ);

figure('Name','Preprocessed Data');
subplot(3,1,1)
plot(t,preproc_accX)
grid on;
grid minor;
title('accX')

subplot(3,1,2)
plot(t,preproc_accY)
grid on;
grid minor;
title('accY')

subplot(3,1,3)
plot(t,preproc_accZ)
grid on;
grid minor;
title('accZ')

figure('Name','Raw Data & Preprocessed Data');
grid on
grid minor
subplot(3,1,1)
plot(t,[Real_accX,preproc_accX])
grid on;
grid minor;
title('accX')

subplot(3,1,2)
plot(t,[Real_accY,preproc_accY])
grid on;
grid minor;
title('accY')

subplot(3,1,3)
plot(t,[Real_accZ,preproc_accZ])
grid on;
grid minor;
title('accZ')

%FILTERING - Moving Average
n_samples = 20;
weight = ones(1, n_samples)/n_samples;

ma_accX = filtfilt(weight, 1, preproc_accX);
ma_accY = filtfilt(weight, 1, preproc_accY);
ma_accZ = filtfilt(weight, 1, preproc_accZ);

figure('Name','Moving Average')
plot(t,[Real_accX preproc_accX ma_accX])
legend('Raw Data','Preprocessed Data','Filtered Data','location','best')

figure('Name','Raw Data vs Filtered Data');
grid on
grid minor
subplot(3,1,1)
plot(t,[Real_accX,ma_accX])
grid on;
grid minor;
title('accX')

subplot(3,1,2)
plot(t,[Real_accY,ma_accY])
grid on;
grid minor;
title('accY')

subplot(3,1,3)
plot(t,[Real_accZ,ma_accZ])
grid on;
grid minor;
title('accZ')

%FILTERING - Convolutional
n_samples = 5;
h = ones(1, n_samples)/n_samples;
binomialCoeff = conv(h,h); %the convolution doubles the dimension of convolving array
for n = 1:4
    binomialCoeff = conv(binomialCoeff,h);
end

c_accX= filtfilt(binomialCoeff, 1, preproc_accX);
c_accY= filtfilt(binomialCoeff, 1, preproc_accY);
c_accZ= filtfilt(binomialCoeff, 1, preproc_accZ);

figure('Name','Weighted Moving Average')
plot(t,[Real_accX preproc_accX c_accX])
legend('Raw Data','Preprocessed Data','Filtered Data','location','best')

figure('Name','Raw Data vs Filtered Data');
grid on
grid minor
subplot(3,1,1)
plot(t,[Real_accX,c_accX])
grid on;
grid minor;
title('accX')

subplot(3,1,2)
plot(t,[Real_accY,c_accY])
grid on;
grid minor;
title('accY')

subplot(3,1,3)
plot(t,[Real_accZ,c_accZ])
grid on;
grid minor;
title('accZ')

%FILTERING - Exponential
alpha = 0.20;
e_accX = filtfilt(alpha, [1 alpha-1], preproc_accX);
e_accY = filtfilt(alpha, [1 alpha-1], preproc_accY);
e_accZ = filtfilt(alpha, [1 alpha-1], preproc_accZ);

figure('Name','Exponential Filter')
plot(t,[Real_accX preproc_accX e_accX])
legend('Raw Data','Preprocessed Data','Filtered Data','location','best')

figure('Name','Raw Data vs Filtered Data');
grid on
grid minor
subplot(3,1,1)
plot(t,[Real_accX,e_accX])
grid on;
grid minor;
title('accX')

subplot(3,1,2)
plot(t,[Real_accY,e_accY])
grid on;
grid minor;
title('accY')

subplot(3,1,3)
plot(t,[Real_accZ,e_accZ])
grid on;
grid minor;
title('accZ')

%FILTERING COMPARISON
figure('Name','Filter Comparison on X acceleration')
plot(t,[ma_accX c_accX e_accX])
legend('Moving Average','Convolutional','Exponential')

figure('Name','Filter Comparison');
grid on
grid minor
subplot(3,1,1)
plot(t,[ma_accX c_accX e_accX])
grid on;
grid minor;
title('accX')

subplot(3,1,2)
plot(t,[ma_accY c_accY e_accY])
grid on;
grid minor;
title('accY')

subplot(3,1,3)
plot(t,[ma_accZ c_accZ e_accZ])
grid on;
grid minor;
title('accZ')