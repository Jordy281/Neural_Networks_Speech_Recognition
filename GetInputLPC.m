function [inp] = getInputLPC(folder)
%% Return LPC coefficients as input
    % This function will return the LPC
    % coefficients as input for the neural net
    
%% Get the files for reading    
Fs=8000;

pathToTraining = fullfile(folder,'boy.wav');

% Create the list of files names
filelist = dir([fileparts(pathToTraining) filesep '*.wav']);
fileNames = {filelist.name}';
n = length(fileNames);
%display(length(fileNames));
%% Read each file and analyze it.
for k=1:n
    clear y1 y2 y3;
    [y1,fs]=wavread(fullfile(folder,fileNames{k}));

    y2=y1/(max(abs(y1)));
    
    % Run through a highpass filter to boost high frequencies,
    y3=[y2,zeros(1,3120-length(y2))];
    y=filter([1 -0.9],1,y3');
    
    %%frame blocking
    blocklen=240;%30ms block
    overlap=80;
    block(1,:)=y(1:240);
    
    for i=1:18
        block(i+1,:)=y(i*160:(i*160+blocklen-1));
    end
    w=hamming(blocklen);
    for i=1:19
        
        %finding auto correlation from lag -12 to 12
        a=xcorr((block(i,:).*w'),12);
       
        for j=1:12
            %forming autocorrelation matrix from lag 0 to 11
            auto(j,:)=fliplr(a(j+1:j+12));
        end
        
        %forming a column matrix of autocorrelations for lags 1 to 12
        z=fliplr(a(1:12));
        alpha=pinv(auto)*z';
        lpc(:,i)=alpha;
    end
    inp(k,:)=reshape(lpc,1,228);
end