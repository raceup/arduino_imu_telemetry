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
fid = fopen('LOG1.CSV');
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

figure('Name','Accelerations');
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

figure('Name','Gyro Speed');
subplot(3,1,1)
plot(t,gyroX)
grid on;
grid minor;
title('gyroX')

subplot(3,1,2)
plot(t,gyroY)
grid on;
grid minor;
title('gyroY')

subplot(3,1,3)
plot(t,gyroZ)
grid on;
grid minor;
title('gyroZ')

figure('Name','Angle');
subplot(3,1,1)
plot(t,angleX)
grid on;
grid minor;
title('angleX')

subplot(3,1,2)
plot(t,angleY)
grid on;
grid minor;
title('angleY')

subplot(3,1,3)
plot(t,angleZ)
grid on;
grid minor;
title('angleZ')