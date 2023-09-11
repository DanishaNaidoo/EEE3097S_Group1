function TDoA = TDoAFunction(m1filtered, m2filtered, samplingf)
    speed_of_sound = 343;

    % Frequency domain equations
    M1 = fft(m1filtered);
    M2 = fft(m2filtered);

    % Cross-correlation
    Z_M1_M2 = M1 .* conj(M2);

    % Absolute
    Zabs_M1_M2 = Z_M1_M2 ./ abs(Z_M1_M2);
    R_M1_M2 = ifft(Zabs_M1_M2);

    % Indices of local maxima
    [~, peak_indices] = findpeaks(abs(R_M1_M2));

    % Delay index of the peak
    peak_delay_index = peak_indices(1);

    % Corresponding time delay (tau) in seconds
    tau = (peak_delay_index / samplingf);

    % Calculate TDoA based on speed_of_sound
    TDoA = tau * speed_of_sound;
end

% Function call
% m1filtered = Signal (ref)
% m2filtered = Signal
% samplingf = Sampling frequency

% TDoA = estimateTDOA(m1filtered, m2filtered, samplingf);

% disp(['Estimated TDoA between M1 and M2: ' num2str(TDoA) ' seconds']);

