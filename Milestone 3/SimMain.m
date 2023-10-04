% Script to get .wav from mics and process
% October 2023 EEE3097S
% Authors: Group 1 (Danisha Naidoo, Megan Sorour, Qailah Bhamjee)

%positions of mics
m1 = [0, 0];
m2 = [0, 0.5];
m3 = [0.8, 0.5];
m4 = [0.8, 0];
m =  [m1;m2;m3;m4];

fs = 500;
samplef = 48000;

fprintf('\n')
disp("Simulation report:");
disp('------------------------------------------------------------');
disp('Locations [x, y] in meters');
fprintf('\n')
%disp(['Actual location of the sound source: [' num2str(src(1)) ', ' num2str(src(2)) ']' ]);

%read wav files and split channels
[y1, Fs] = audioread('./Recordings/stereo1.wav');

m1 = y1(:, 1);
m2 = y1(:, 2);

% [y2, Fs] = audioread('./Recordings/stereo2.wav');
% 
% m3 = y2(:, 1);
% m4 = y2(:, 2);

%signal processing algorithm

tStart = tic;

N = 1; %order of the Butterworth filter
low_freq = fs-100;
high_freq = fs+100;
nlow_f = low_freq/samplef/2;
nhigh_f = high_freq/samplef/2;
Wn = [nlow_f, nhigh_f];

% % Design the Butterworth bandpass filter
[B, A] = butter(N, Wn , 'bandpass');

spm1 = filter(B, A, m1);
spm2 = filter(B, A, m2);
% spm3 = filter(B, A, m3);
% spm4 = filter(B, A, m4);

% Signal processing display results
tiledlayout(2,1)
nexttile
plot(m1)
title("Original signal from mic 1")

nexttile
plot(spm1);
title('Filtered signal from mic 1');

%-----------------------------------------------------------------------

% %TDoA function calls
% disp(['Expected result: ' num2str(td12) ' seconds']);
TDoA12 = TDoAFunction(spm2, spm1, samplef);
disp(['Estimated TDoA between M1 and M3: ' num2str(TDoA12) ' seconds']);
% % 
% % disp('---------------------------------------------------------------');
% % 
% disp(['Expected result: ' num2str(td13) ' seconds']);
% TDoA13 = TDoAFunction(spm3, spm1, samplef);
% disp(['Estimated TDoA between M1 and M3: ' num2str(TDoA13) ' seconds']);
% 
% disp('---------------------------------------------------------------');
% 
% disp(['Expected result: ' num2str(td14) ' seconds']);
% TDoA14 = TDoAFunction(spm4, spm1, samplef);
% disp(['Estimated TDoA between M1 and M4: ' num2str(TDoA14) ' seconds']);

%-----------------------------------------------------------------------

%localization function call
% LocalizationFunction(TDoA12, TDoA13, TDoA14, src);
tEnd = toc(tStart);

%report info
 fprintf('\n')
 disp(['Time taken to find location: ' num2str(tEnd) ' s']);
