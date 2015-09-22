close all, clear all
%% This program will remove silences from a speech recording
    % It will do it by analyzin a frame of a soundwave, if the max
    % amplitude is under the threshold 0.04, then it will set its amplitude
    % to 0 in the new signal. If the max amplitude is over the threshold,
    % it will copy it to the new signal.
    % The script will then go on a fram by frame basis deleteing all frames
    % with a 0 amplitude
pathToTraining = fullfile('TestSetRaw','boy.wav');

%step 1 - break signal into 0.1 s section
filelist = dir([fileparts(pathToTraining) filesep '*.wav']);
fileNames = {filelist.name}';
n = length(fileNames);

for x=1:n
    inputFile= fullfile('TestSetRaw',fileNames{x});
	[ip,fs]=wavread(inputFile);
	frame_duration = 0.01;
	frame_len = frame_duration*fs;
	N = length(ip);
	num_frames = floor(N/frame_len);

	new_sig=zeros(N,1);
	count =0;
	for k=1: num_frames
	    %extract frame of speech
	    frame = ip((k-1)*frame_len +1 : frame_len*k);
	    
	    %Identify silence by finding if frame max amplitude id > 0.03
	    max_val = max(frame);
	    
	    if(max_val>0.04)
		count=count+1;
		new_sig((count-1)*frame_len +1: frame_len*count)=frame;
	    end
	end
	%get rid of extra space at end.
	for k=1: num_frames
    	%extract frame of speech
    	frame = new_sig((k-1)*frame_len +1 : frame_len*k);
    
	    %Identify silence by finding if frame max amplitude id > 0.03
	    max_val = max(frame);
	    
	    if(max_val<=0)
	  	new_sig(k*frame_len:end)=[];
        	break;
    	    end
    end
    
    fileOut=fullfile('TestSetEdited',fileNames{x});
    wavwrite(new_sig,fs,fileOut);
    
    
end



