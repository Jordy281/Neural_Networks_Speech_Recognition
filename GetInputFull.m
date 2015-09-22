function [ inp ] = GetInputFull(folder)
% This will read all the files from the folder
%   This function will take in the folder of the files, and output the top
%   10 frequencies of each sample, using the full file

%% Get all the sound files

pathToTraining = fullfile(folder,'boy.wav');

% Create the list of files names
filelist = dir([fileparts(pathToTraining) filesep '*.wav']);
fileNames = {filelist.name}';
n = length(fileNames);

% Create a temporary matrix, we can readjust size later
inp= zeros(n,50000);


%% For each File
max_size=0;
for k=1:n
   
   %Read the WAV file
   [y,fs]=wavread(fullfile(folder,fileNames{k}));
   len=length(y);
   inp(k,1:len)=y';
   if (len>max_size)
       max_size=len;
   end
     
end
inp(:,max_size+1:end)=[];

end