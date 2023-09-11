% TDOA Code 
% Takes input of paired filtered signals and passes them through TDOA
% algorithm

% Frequency domain equations
M1 = fft(m1filtered);
M2 = fft(m2filtered);

% Cross-correlation
Z_M1_M2 = M1 .* conj(M2);

% Absolute
Zabs_M1_M2 = Z_M1_M2 ./ abs(Z_M1_M2);
R_M1_M2 = ifft(Zabs_M1_M2);

% Find indices of local maxima
[~, peak_indices] = findpeaks(abs(R_M1_M2));  % Using findpeaks to find local maxima

% Get the delay index of the peak
peak_delay_index = peak_indices(1);

% The peak_delay_index represents the time delay between the two microphone signals
TDoA = (peak_delay_index / samplingf) * speed_of_sound;

-----------------------------------------------------------------------

% Expected range of time delay
% T as the maximum expected delay
T = 1;  % Adjust as needed
tau_values = -T:0.001:T;  

% Initialize an array to store the computed cross-correlation values
R_M1_M2 = zeros(size(tau_values));

% Loop through each time delay τ and compute R(M1, M2)(τ)
for i = 1:length(tau_values)
    tau = tau_values(i);
    
    % Calculate the integral using numerical approximation
    integral_result = trapz(omega_values, Z_M1_M2 .* exp(-1j * omega_values * tau));
    
    % Store the result in the R_M1_M2 array
    R_M1_M2(i) = integral_result;
end 

% Maximum value and its corresponding index in the cross-correlation function
[max_value, max_index] = max(abs(R_M1_M2));

% Find the corresponding time delay τ at the maximum
TDOA_value = tau_values(max_index);

% Displays the TDOA value
disp(['TDOA value between M1 and M2: ' num2str(TDOA_value) ' seconds']);

-------------------------------------------------------------------------

% Find the index of the maximum absolute value in R_M1_M2
[~, max_index] = max(abs(R_M1_M2));

% Calculate the corresponding time delay (tau)
tau = tau_values(max_index);

% The 'tau' variable now contains the estimated time delay

-------------------------------------------------------------------------

function TDoA = TDoAFunction(sig, refsig, fs)
    % Check if the input signals have the same length
    if length(sig) ~= length(refsig)
        error('Input signals must have the same length.');
    end
    
    % Compute the cross-correlation using the GCC-PHAT algorithm
    xcorr_result = xcorr(sig, refsig);
    
    % Calculate the time delay (tau) as the index of the peak in the cross-correlation
    [~, max_index] = max(abs(xcorr_result));
    
    % Convert the index to a time delay (tau) in seconds
    tau = (max_index - 1) / fs; % Subtract 1 because MATLAB uses 1-based indexing
    
    % Convert tau to multiples of the sample interval corresponding to the default sampling frequency of 1 Hz
    TDoA = tau * fs;
end

--------------------------------------------------------------------------

function TDoA = TDoAFunction(x, y, fs)

    % Compute the cross-power spectrum
    Z12 = fft(x) .* conj(fft(y));
    
    % Compute the inverse FFT to obtain the cross-correlation function
    R_Z1_Z2 = ifft(Z12);
    
    % Calculate the GCC-PHAT
    phi_12 = 1 ./ abs(Z12);
    
    % Apply the GCC-PHAT weighting to the cross-correlation function
    R_Z1_Z2_PHAT = R_Z1_Z2 .* phi_12;
    
    % Find the time delay (tau) that maximizes R_Z1_Z2_PHAT
    [~, idx] = max(abs(R_Z1_Z2_PHAT));
    tau_hat_samples = idx - 1;
    
    % Convert tau_hat_samples to seconds
    tau_hat_seconds = tau_hat_samples / fs;
    
    % Return TDoA
    TDoA = tau_hat_seconds;
end