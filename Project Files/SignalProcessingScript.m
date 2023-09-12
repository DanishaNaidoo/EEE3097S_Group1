sim_time = 2;
dt = 1/samplef;
t = 0:dt:sim_time ;
t = t';

N = 1;
low_freq = fs-100;
high_freq = fs+100;
nlow_f = low_freq/samplef/2;
nhigh_f = high_freq/samplef/2;
%Wn = [low_freq, high_freq] ./ (samplef / 2);
Wn = [nlow_f, nhigh_f];
%Wn = [0.19, 0.21];

% % Design the Butterworth bandpass filter
[B, A] = butter(N, Wn , 'bandpass');

spm1 = filter(B, A, out.m1out);
spm2 = filter(B, A, out.m2out);
spm3 = filter(B, A, out.m3out);
spm4 = filter(B, A, out.m4out);

% Plot the filtered signal
% tiledlayout(2,1)
% nexttile
% plot(t, out.m1out)
% title("No filter")
% 
% nexttile
% plot(t, spm1);
% title('Filtered Signal');

m1filtered = cat(2, t, spm1);
m2filtered = cat(2, t, spm2);
m3filtered = cat(2, t, spm3);
m4filtered = cat(2, t, spm4);

td12 = delay(2) - delay(1);
td13 = delay(3) - delay(1);
td14 = delay(4) - delay(1);

%-----------------------------------------------------------------------

% TDoA function calls
disp(['Expected result: ' num2str(td12) ' seconds']);
TDoA12 = TDoAFunction(spm2, spm1, samplef);
disp(['Estimated TDoA between M1 and M3: ' num2str(TDoA12) ' seconds']);

disp('---------------------------------------------------------------');

disp(['Expected result: ' num2str(td13) ' seconds']);
TDoA13 = TDoAFunction(spm3, spm1, samplef);
disp(['Estimated TDoA between M1 and M3: ' num2str(TDoA13) ' seconds']);

disp('---------------------------------------------------------------');

disp(['Expected result: ' num2str(td14) ' seconds']);
TDoA14 = TDoAFunction(spm4, spm1, samplef);
disp(['Estimated TDoA between M1 and M4: ' num2str(TDoA14) ' seconds']);

%-----------------------------------------------------------------------

%localization function call
syms x y;
 % td12 = delay(2) - delay(1);
 % td13 = delay(3) - delay(1);
 % td14 = delay(4) - delay(1);
 src
 LocalizationFunction(TDoA12, TDoA13, TDoA14);
 %x
 %y

