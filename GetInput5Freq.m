function [ inp ] = GetInput5Freq(folder)
% This will read all the files from the folder
%   This function will take in the folder of the files, and output the top
%   5 frequencies of each sample, using a Fast Fourier Transformation

%% Get all the sound files

pathToTraining = fullfile(folder,'boy.wav');

% Create the list of files names
filelist = dir([fileparts(pathToTraining) filesep '*.wav']);
fileNames = {filelist.name}';
n = length(fileNames);
%display(length(fileNames));
% for input of n samples, we use 5 peaks of frequency.
inp= zeros(n,6);


%% For each File

for k=1:n
   
   %Read the WAV file
   [y,fs]=wavread(fullfile(folder,fileNames{k}));
   
   
   y2= zeros(8000, 1);
   [m,o]=size(y);
   j=1:m;
    
   y2(j)=y(j);
   
   % Fast Fourier Transform
   nfft = 8000; %number of points in fourier fast transforms

   X=fftshift(fft(y2,nfft));
   X=X(1:nfft);
   peak = abs(X);
   f= -fs/2:fs/(nfft-1):fs/2;
   
   figure, plot X
   
   
   y2= zeros(8000, 1);
   [m,o]=size(y);
   j=1:m;
    
   y2(j)=y(j);
   
   %Sorting to get 5 peaks of DFT
   
   peak1 = peak;
   
   f1=f;
   sort=zeros(nfft,2);
   
   for i=1:nfft
       if f1(i)<=1
           peak1(i)=0;
       end
       sort(i,1)=peak1(i);
       sort(i,2)=f1(i);
   end
   
   sort1=sortrows(sort);
   sort2=sort1;
   %
   for i=nfft:-1:2
       if sort1(i,1)>sort1(i-1,1) && sort1(i,2)>sort1(i-1,2)
           sort2(i-1,1)=0;
       end
   end
   sort3=sortrows(sort2);
       
   sort4=sort3;
       
   for i=nfft:-1:2
       if sort3(i,1)>sort3(i-1,1) && sort3(i,2)-sort3(i-1,2)> -1
           sort4(i-1,1)=0;
       end
   end
   sort5=sortrows(sort4);
   %Get the length of WAV files
   len = m;
   
   %Input Vector for hte netwrok
   % 5 inputs from DFT
   % i inputs from Length of Audio
   
   
    inp(k,1:end)=[ sort5(nfft:-1:nfft-4,2)' len];
end




end


