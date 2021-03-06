close all

%%PLOT E ANALISI DATI IMU
%Race UP Team - 2019

%NOTE
    %ACCELEROMETRO:
        %L'IMU � posizionato sul fianco DX del pilota, il "sopra" guarda l'interno
        %della vettura.
        %L'asse x e' normale: coincide con l'asse longitudinale della macchina, il
        %verso e' concorde con l'avanzare della vettura.
        %L'asse y e' verticale, come se fosse l'asse z.
        %L'asse z e'come se fosse l'asse y, a segno invertito.
    %TEMPO:
        %Il tempo e' espresso in millisecondi. Il primo istante non e' 0 ma
        %il tempo trascorso dopo la configurazione del dispositivo.

%selezione file
[file,path] = uigetfile('*.CSV','Select One or More Files', ...
    'MultiSelect', 'on');

if isequal(file,0)
   disp('User selected Cancel');
else
   disp('User selected: ');
   disp([fullfile(path,file)]);
end

mkdir relevant_log
%fName = 'relevant_log\README.txt';

%% Apertura file di LOG

%se viene aperto un solo documento
if (class(file)=='char')
    fid = fopen(file);
    data = textscan(fid, '%f,%f,%f,%f,%f,%f,%f,%f,%f,%f');
    fclose(fid);
        
    %creazione array dati (con correzione assi dispositivo)
    t = data{1};
    accX = data{2};
    accY = -data{4};
    accZ = data{3};
    gyroX = data{5};
    gyroY= -data{7};
    gyroZ = data{6};
    angleX = data{8};
    angleY = -data{10};
    angleZ = data{9};
    
    [r, c] = size(t);
    
    % condizione che rende importante un log di test
    % che abbia sufficienti campioni interessanti (almeno 0.1 secondi)
    counter=0;
    for (i = 1:length(accX))
        if (abs(accX(i))>0.3)
            counter=counter+1;
        end
    end
    
    if ((r>13000) && (counter>100))
        
        %rm = fopen(fName,'w');
        %fprintf(rm,'The file %s is relevant!',file);

        %aggiungo il file alla cartella dei dati importanti
        copyfile(file,'relevant_log')

        %PREPROCESSING
        filt=designfilt('lowpassiir', 'PassbandFrequency', .10, 'StopbandFrequency', .15, 'PassbandRipple', 1, 'StopbandAttenuation', 60);

        preproc_accX=filtfilt(filt,accX);
        preproc_accY=filtfilt(filt,accY);
        preproc_accZ=filtfilt(filt,accZ);

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
        c_gyroX= filtfilt(binomialCoeff, 1, gyroX);
        c_gyroY= filtfilt(binomialCoeff, 1, gyroY);
        c_gyroZ= filtfilt(binomialCoeff, 1, gyroZ);
        
        %title of the graph
        dir='relevant_log\';
        s1 = file;
        s2 = '-ACC.fig';
        s3 = '-GYRO.fig';
        filename_acc = strcat(dir,s1,s2);
        filename_gyro = strcat(dir,s1,s3);
        
        fa = figure('Name',filename_acc);
        grid on;
        grid minor;
        hold on;
        subplot(3,1,1)
        plot(t,[accX,c_accX])
        grid on;
        hold on;
        grid minor;
        title('accX [g]')

        subplot(3,1,2)
        plot(t,[accY,c_accY])
        grid on;
        hold on;
        grid minor;
        title('accY [g]')

        subplot(3,1,3)
        plot(t,[accZ,c_accZ])
        grid on;
        hold on;
        grid minor;
        title('accZ [g]')
        
        % salva il grafico accelerazioni
        saveas(fa,filename_acc)
            
        fg = figure('Name',filename_gyro);
        grid on
        grid minor
        subplot(3,1,1)
        plot(t,[gyroX,c_gyroX])
        grid on;
        grid minor;
        title('roll [dps]')

        subplot(3,1,2)
        plot(t,[gyroY,c_gyroY])
        grid on;
        grid minor;
        title('pitch [dps]')

        subplot(3,1,3)
        plot(t,[gyroZ,c_gyroZ])
        grid on;
        grid minor;
        title('yaw [dps]')
        
        % salva il grafico giroscopio
        saveas(fg,filename_gyro)
        %fclose(rm);
    end
else
    
    %se vengono aperti pi� documenti
    for (n_file = 1:length(file))
        fid = fopen(file{n_file});
        data = textscan(fid, '%f,%f,%f,%f,%f,%f,%f,%f,%f,%f');
        fclose(fid);
        
        %creazione array dati (con correzione assi dispositivo)
        t = data{1};
        accX = data{2};
        accY = -data{4};
        accZ = data{3};
        gyroX = data{5};
        gyroY= -data{7};
        gyroZ = data{6};
        angleX = data{8};
        angleY = -data{10};
        angleZ = data{9};

        [r, c] = size(t);

        % condizione che rende importante un log di test
        % che abbia sufficienti campioni interessanti (almeno 0.1 secondi)
        counter=0;
        for (i = 1:length(accX))
            if (abs(accX(i))>0.3)
                counter=counter+1;
            end
        end
        
        if ((r>13000) && (counter>100))
            
            %rm = fopen(fName,'w');
            %fprintf(rm,'The file %s is relevant!',file{n_file});
        
            %aggiungo il file alla cartella dei dati importanti
            copyfile(file{n_file},'relevant_log')
        
            %PREPROCESSING
            filt=designfilt('lowpassiir', 'PassbandFrequency', .10, 'StopbandFrequency', .15, 'PassbandRipple', 1, 'StopbandAttenuation', 60);

            preproc_accX=filtfilt(filt,accX);
            preproc_accY=filtfilt(filt,accY);
            preproc_accZ=filtfilt(filt,accZ);

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
            c_gyroX= filtfilt(binomialCoeff, 1, gyroX);
            c_gyroY= filtfilt(binomialCoeff, 1, gyroY);
            c_gyroZ= filtfilt(binomialCoeff, 1, gyroZ);
            
            %title of the graph
            dir='relevant_log\';
            s1 = file{n_file};
            s2 = '-ACC.fig';
            s3 = '-GYRO.fig';
            filename_acc = strcat(dir,s1,s2);
            filename_gyro = strcat(dir,s1,s3);
            
            fa = figure('Name',filename_acc);
            grid on
            grid minor
            subplot(3,1,1)
            plot(t,[accX,c_accX])
            grid on;
            grid minor;
            title('accX [g]')

            subplot(3,1,2)
            plot(t,[accY,c_accY])
            grid on;
            grid minor;
            title('accY [g]')

            subplot(3,1,3)
            plot(t,[accZ,c_accZ])
            grid on;
            grid minor;
            title('accZ [g]')
            
            % salva il grafico accelerazioni
            saveas(fa,filename_acc)
            
            fg=figure('Name',filename_gyro);
            grid on
            grid minor
            subplot(3,1,1)
            plot(t,[gyroX,c_gyroX])
            grid on;
            grid minor;
            title('roll [dps]')

            subplot(3,1,2)
            plot(t,[gyroY,c_gyroY])
            grid on;
            grid minor;
            title('pitch [dps]')

            subplot(3,1,3)
            plot(t,[gyroZ,c_gyroZ])
            grid on;
            grid minor;
            title('yaw [dps]')
            
            % salva il grafico giroscopio
            saveas(fg,filename_gyro)
            %fclose(rm);
        end
    end
end