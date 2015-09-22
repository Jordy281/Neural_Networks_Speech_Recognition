close all, clear all

%% Analyze soundwaves to best recognize the speech using a Fast Fourier Transform and a Neural Net

% List of Targets:
% 'baby';
% 'boy';
% 'girl';
% 'man';
% 'woman';


%% Get Training Input

%Input consists of top 5 frequencies for each sample

inp=GetInputLPC('TrainingSetEdited');
trainInput=inp';

%% Create TARGETS for Training
% 25 Total Words
% 4 samples for each word,
% 100 samples

trainTarget = zeros(5, 150);

for a=1:5
    %go through and label each sample with correct target
    b=int64(a*30);
    c=int64(b-29);
    
    trainTarget(a, c:b)=1;
end

%% Create Net and Train it

layer1=24;
layer2=m;
layer3=512;
layer4=1;

display(k);


%initialize pattern neural net
net = patternnet([layer1]);%,layer2]);%,layer1,layer1]);
%set up training ratios
net.divideParam.trainRatio = 75/100;
net.divideParam.valRatio = 25/100;
net.divideParam.testRatio = 0/100;

%Train the netwrok
[net,tr] = train(net,trainInput,trainTarget);

%% Test The Network using different test set

% Get Input Set

inp=GetInputLPC('TestSetEdited');
testInput=inp';

%Create Targets from the set

testTarget = zeros(5,15);

for a=1:5
    %go through and label each sample with correct target
    testTarget(a,a*3-2:a*3)=1;
end

% Test the Network

outputs = net(testInput);
errors = gsubtract(testTarget,outputs);
performance = perform(net,testTarget,outputs);

% Plots
figure, plotconfusion(testTarget,outputs)






