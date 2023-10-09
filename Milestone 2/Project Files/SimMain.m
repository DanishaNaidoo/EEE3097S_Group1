% Complete script for the simulation of a sound source being produced on an A1 grid with 4 microphones
% September 2023 EEE3097S
% Authors: Group 1 (Danisha Naidoo, Megan Sorour, Qailah Bhamjee)

% Define variables:

src = [0.3, 0.1]; %location of sound source

fs = 1000; %frequency of source

samplef = (2.5 * fs);  % sampling frequency relative to fs

amp = 3000; %amplitude of source (volume)
sigp = amp^2/2; %signal power

SNR = sigp;
SNRdb = 20*log(SNR);

np = sigp/SNR; %noise power
np = 0;

%positions of mics
m1 = [0, 0];
m2 = [0, 0.5];
m3 = [0.8, 0.5];
m4 = [0.8, 0];
m =  [m1;m2;m3;m4];

%calculating derived variables before simulation runs
mic_src_xy = abs(m - src);  % diff in xy coords on each mic and src
mic_src_d = sqrt(sum(mic_src_xy .^2, 2)); % distance between each mic and src
speed = 343.21; %speed of sound at T = 20C
delay = mic_src_d ./ speed;

fprintf('\n')
disp("Simulation report:");
disp('------------------------------------------------------------');
disp('Locations [x, y] in meters');
fprintf('\n')
disp(['Actual location of the sound source: [' num2str(src(1)) ', ' num2str(src(2)) ']' ]);

%running the simulation, outputs assigned to out
out = sim('SimPart1.slx');%for version R2023b
%out = sim('SimPart1a.slx'); %for version R2023a

%signal processing algorithm
sim_time = 2;
dt = 1/samplef;
t = 0:dt:sim_time ;
t = t';

tStart = tic;

N = 1; %order of the Butterworth filter
low_freq = fs-100;
high_freq = fs+100;
nlow_f = low_freq/samplef/2;
nhigh_f = high_freq/samplef/2;
Wn = [nlow_f, nhigh_f];

% % Design the Butterworth bandpass filter
[B, A] = butter(N, Wn , 'bandpass');

spm1 = filter(B, A, out.m1out);
spm2 = filter(B, A, out.m2out);
spm3 = filter(B, A, out.m3out);
spm4 = filter(B, A, out.m4out);

% Signal processing display results
% tiledlayout(2,1)
% nexttile
% plot(t, out.m1out)
% title("Original signal from mic 1")
% 
% nexttile
% plot(t, spm1);
% title('Filtered signal from mic 1');
 
% ideal tdoa values for modular testing of the localization algorithm
td12 = delay(2) - delay(1);
td13 = delay(3) - delay(1);
td14 = delay(4) - delay(1);

%-----------------------------------------------------------------------

% %TDoA function calls
% disp(['Expected result: ' num2str(td12) ' seconds']);
TDoA12 = TDoAFunction(spm2, spm1, samplef);
% disp(['Estimated TDoA between M1 and M3: ' num2str(TDoA12) ' seconds']);
% % 
% % disp('---------------------------------------------------------------');
% % 
% disp(['Expected result: ' num2str(td13) ' seconds']);
TDoA13 = TDoAFunction(spm3, spm1, samplef);
% disp(['Estimated TDoA between M1 and M3: ' num2str(TDoA13) ' seconds']);
% 
% disp('---------------------------------------------------------------');
% 
% disp(['Expected result: ' num2str(td14) ' seconds']);
TDoA14 = TDoAFunction(spm4, spm1, samplef);
% disp(['Estimated TDoA between M1 and M4: ' num2str(TDoA14) ' seconds']);

%-----------------------------------------------------------------------

%localization function call
LocalizationFunction(TDoA12, TDoA13, TDoA14, src);
tEnd = toc(tStart);

%report info
 fprintf('\n')
 disp(['Source signal frequency: ' num2str(fs) ' Hz']);
 disp(['Sampling frequency: ' num2str(samplef) ' Hz']);
 disp(['SNR at source: ' num2str(SNR) ' (' num2str(SNRdb) ' dB)']);
 disp(['Time taken to find location: ' num2str(tEnd) ' s']);
