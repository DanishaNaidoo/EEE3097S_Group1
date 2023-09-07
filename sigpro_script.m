% make array for time values
sim_time = 2;
fs = 2000;
samplingf = 2.5 * fs;
dt = 1/samplingf   ;
t = 0:dt:sim_time ;

%sample the signal

%bandpass filter around fs

B=1;
f0=fs;
w0=(2*pi)/f0;
%x = Sa(t);
h = 2*B*Sa.(pi*B*t)*cos(w0*t);
plot(t, h)
%fft of BPF and sig

%convolve

%ifft = processed_sig

%end

function [x] = Sa(u)
x = sin(u)./u;
end
