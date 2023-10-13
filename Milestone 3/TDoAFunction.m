% function TDoA = TDoAFunction(x, y, samplef)
%     tau = gccphat(x,y,samplef);
%     TDoA = tau;
% end

%-------------------------------------------------------------------------

% Function call
% m1filtered = Signal (ref)
% m2filtered = Signal
% samplingf = Sampling frequency

% TDoA = estimateTDOA(m1filtered, m2filtered, samplingf);

% disp(['Estimated TDoA between M1 and M2: ' num2str(TDoA) ' seconds']);

%-------------------------------------------------------------------------

% function TDoA = TDoAFunction(x, y, samplef)
%     % Cross-correlation
%     R_M1_M2 = ifft((fft(x) .* conj(fft(y))));
% 
%     % Ensure R_M1_M2 is a 1D vector
%     R_M1_M2 = R_M1_M2(:);  
% 
%     % R_M1_M2 = R_M1_M2/abs(R_M1_M2);
%     % R_M1_M2 = ifft(R_M1_M2);
% 
%     % R_M1_M2 = xcorr(x, y);
% 
%     % Find the maximum peak in the cross-correlation result
%     [max_peak_value, peak_index] = max(abs(R_M1_M2));
% 
%     % Visualize the cross-correlation result and the maximum peak
%     % figure;
%     % subplot(2, 1, 1);
%     % plot(R_M1_M2);
%     % title('Cross-Correlation Result');
%     % 
%     % subplot(2, 1, 2);
%     % plot(abs(R_M1_M2));
%     % hold on;
%     % plot(peak_index, max_peak_value, 'ro');  % Mark the maximum peak in red
%     % title('Maximum Peak');
% 
%     % Delay index of the maximum peak
%     peak_delay_index = peak_index;
% 
%     % Corresponding time delay (tau) in seconds
%     tau = (peak_delay_index / samplef);
% 
%     % Return TDoA
%     TDoA = tau;
% end

% function tau = TDoAFunction(sig, ref, samplef)
%     peak1 = correlate(sig,ref);
%     fl = zeros(1,3*samplef);
%     sig_t = sig;
%     f = length(fl);
%     sig_t(peak1:peak1+f-1) = fl;
%     peak2 = correlate(sig_t,ref);
%     peaks = [peak1 peak2];
%     %cal = min(peaks)/samplef;
%     tau = max(peaks)/samplef;
% end
% 
% function val = correlate(sig2, sig1)
%     [Correlation_array, lag_array] = xcorr(sig2, sig1);
%     [~, lag_index] = max(abs((Correlation_array)));
%     val = lag_array(lag_index);
% end
%-----------------------------------------

function tau = TDoAFunction(sig, refsig, fs, max_tau, interp)
    %This function computes the offset between the signal sig and the reference signal refsig
    %using the Generalized Cross Correlation - Phase Transform (GCC-PHAT) method.

    %Check if optional parameters are provided, and set default values if not
    if nargin < 5
        interp = 16;
    end
    if nargin < 4
        max_tau = 0.1;
    end
    if nargin < 3
        fs = 48000;
    end

    %Make sure the inputs are column vectors
    sig = sig(:);
    refsig = refsig(:);

    %Make sure the length for the FFT is larger or equal to len(sig) + len(refsig)
    n = length(sig) + length(refsig);

    % Generalized Cross Correlation Phase Transform
    SIG = fft(sig, n);
    REFSIG = fft(refsig, n);
    R = SIG .* conj(REFSIG);

    cc = ifft(R ./ abs(R), interp * n);

    max_shift = floor(interp * n / 2);
    if max_tau
        max_shift = min(floor(interp * fs * max_tau), max_shift);
    end

    cc = [cc(end-max_shift+1:end); cc(1:max_shift+1)];

    % Find max cross correlation index
    [~, shift] = max(abs(cc));
    shift = shift - max_shift;

    tau = shift / (interp * fs);
end




