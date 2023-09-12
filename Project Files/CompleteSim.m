% complete script for the Simulation
% Define variables:

%positions of mics
m1 = [0, 0];
m2 = [0, 0.5];
m3 = [0.8, 0.5];
m4 = [0.8, 0];
m = [m1;m2;m3;m4];

src = [0.6, 0.4]; %location of sound source

fs = 2000; %frequency of source
amp = 10; %amplitude of source (volume)

np = 0; %noise power

%calculating derived variables before simulation runs
samplef = (2.5 * fs);
mic_src_xy = abs(m - src);  % diff in xy coords on each mic and src
mic_src_d = sqrt(sum(mic_src_xy .^2, 2)); % distance between each mic and src
speed = 343.21; %speed of sound at T = 20C
delay = mic_src_d ./ speed;

disp(['Coordinates of sound source [x, y]: [' num2str(src(1)) ', ' num2str(src(2)) ']' ]);

%running the simulation, outputs assigned to out
out = sim('SimPart1.slx');
%out = sim('SimPart1a.slx'); %for older MATLAB versions

%signal processing algorithm
sim_time = 2;
dt = 1/samplef;
t = 0:dt:sim_time ;
t = t';

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

% m1filtered = cat(2, t, spm1);
% m2filtered = cat(2, t, spm2);
% m3filtered = cat(2, t, spm3);
% m4filtered = cat(2, t, spm4);

% Signal processing results
% tiledlayout(2,1)
% nexttile
% plot(t, out.m1out)
% title("Original signal from mic 1")
% 
% nexttile
% plot(t, spm1);
% title('Filtered signal from mic 1');

%expected tdoa values
td12 = delay(2) - delay(1);
td13 = delay(3) - delay(1);
td14 = delay(4) - delay(1);
% 
% %-----------------------------------------------------------------------
% 
% %TDoA function call 3x
disp(['Expected result: ' num2str(td12) ' seconds']);
TDoA = TDoAFunction(spm2, spm1, samplef);
disp(['Estimated TDoA between M1 and M3: ' num2str(TDoA) ' seconds']);
% 
% disp('---------------------------------------------------------------');
% 
disp(['Expected result: ' num2str(td13) ' seconds']);
TDoA = TDoAFunction(spm3, spm1, samplef);
disp(['Estimated TDoA between M1 and M3: ' num2str(TDoA) ' seconds']);
% 
% disp('---------------------------------------------------------------');
% 
disp(['Expected result: ' num2str(td14) ' seconds']);
TDoA = TDoAFunction(spm4, spm1, samplef);
disp(['Estimated TDoA between M1 and M4: ' num2str(TDoA) ' seconds']);

%-----------------------------------------------------------------------

%localization function call
syms x y;
% td12 = delay(2) - delay(1);
% td13 = delay(3) - delay(1);
% td14 = delay(4) - delay(1);
% src
% [x, y] = LocalizationFunction(td12, td13, td14);
% x
% y