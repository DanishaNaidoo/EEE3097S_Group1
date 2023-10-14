% Script to get .wav from mics and process
% October 2023 EEE3097S
% Authors: Group 1 (Danisha Naidoo, Megan Sorour, Qailah Bhamjee)

%positions of mics
m1 = [0, 0];
m2 = [0, 0.5];
m3 = [0.8, 0.5];
m4 = [0.8, 0];
m =  [m1;m2;m3;m4];

src = [0.4, 0.3];
TDoA12 = -0.00017447916666666667;
TDoA13 = 0.00584375;
TDoA14 = -0.00017447916666666667;

fs = 1000;
samplef = 48000;

%calcing ideal delay
mic_src_xy = abs(m - src);  % diff in xy coords on each mic and src
mic_src_d = sqrt(sum(mic_src_xy .^2, 2)); % distance between each mic and src
speed = 343.21; %speed of sound at T = 20C
delay = mic_src_d ./ speed;

% ideal tdoa values for modular testing of the localization algorithm
td12 = delay(2) - delay(1);
td13 = delay(3) - delay(1);
td14 = delay(4) - delay(1);

fprintf('\n')
disp("Simulation report:");
disp('------------------------------------------------------------');
disp('Locations [x, y] in meters');
fprintf('\n')
disp(['Actual location of the sound source: [' num2str(src(1)) ', ' num2str(src(2)) ']' ]);

%read wav files and split channels
[y1, Fs] = audioread('./Recordings/stereo1.wav');

cutoff = int32(0.5*10^5);

m1out = y1(:, 1); %left channel pi 1
m1out = m1out(cutoff:end);

m2out = y1(:, 2); %right channel pi 1
m2out = m2out(cutoff:end);

[y2, Fs] = audioread('./Recordings/stereo2.wav');

m3out = y2(:, 1); %left channel pi 2
m3out = m3out(cutoff:end);

m4out = y2(:, 2); %right channel pi 2
m4out = m4out(cutoff:end);

samplef= Fs;

%signal processing algorithm

tStart = tic;

N = 1; %order of the Butterworth filter
low_freq = fs-50;
high_freq = fs+50;
nlow_f = low_freq/samplef/2;
nhigh_f = high_freq/samplef/2;
Wn = [nlow_f, nhigh_f];

% % Design the Butterworth bandpass filter
%[B, A] = butter(N, Wn , 'bandpass');

% spm1 = filter(B, A, m1out);
% spm2 = filter(B, A, m2out);
% spm3 = filter(B, A, m3out);
% spm4 = filter(B, A, m4out);

spm1 = m1out;
spm2 = m2out;
spm3 = m3out;
spm4 = m4out;

% Signal processing display results
subplot(2, 1, 1);
plot(m1out)
title("Original signal from mic 1")

subplot(2,1,2);
plot(spm3);
title('Signal from mic 3');

%-----------------------------------------------------------------------


% %TDoA function calls
disp(['Expected result: ' num2str(td12) ' seconds']);
%TDoA12 = TDoAFunction(spm2, spm1, Fs);
disp(['Estimated TDoA between M1 and M2: ' num2str(TDoA12) ' seconds']);
% % 
% % disp('---------------------------------------------------------------');
% % 
disp(['Expected result: ' num2str(td13) ' seconds']);
%TDoA13 = TDoAFunction(spm3, spm1, Fs);
disp(['Estimated TDoA between M1 and M3: ' num2str(TDoA13) ' seconds']);
% 
% disp('---------------------------------------------------------------');
% 
disp(['Expected result: ' num2str(td14) ' seconds']);
%TDoA14 = TDoAFunction(spm4, spm1, Fs);
disp(['Estimated TDoA between M1 and M4: ' num2str(TDoA14) ' seconds']);
fprintf('\n')



%-----------------------------------------------------------------------

%localization function call

%ideal values
LocalizationFunction(TDoA12, TDoA13, TDoA14, src);

% actual values
%LocalizationFunction(td12, td13, td14, src);

tEnd = toc(tStart);

%report info
 fprintf('\n')
 disp(['Time taken to find location: ' num2str(tEnd) ' s']);
