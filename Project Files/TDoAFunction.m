function TDoA = TDoAFunction(x, y, samplef)
    % Cross-correlation
    R_M1_M2 = ifft(fft(x) .* conj(fft(y)));

    % Ensure R_M1_M2 is a 1D vector
    R_M1_M2 = R_M1_M2(:);  

    % Find the maximum peak in the cross-correlation result
    [max_peak_value, peak_index] = max(abs(R_M1_M2));

    % Visualize the cross-correlation result and the maximum peak
    figure;
    subplot(2, 1, 1);
    plot(R_M1_M2);
    title('Cross-Correlation Result');

    subplot(2, 1, 2);
    plot(abs(R_M1_M2));
    hold on;
    plot(peak_index, max_peak_value, 'ro');  % Mark the maximum peak in red
    title('Maximum Peak');

    % Delay index of the maximum peak
    peak_delay_index = peak_index;

    % Corresponding time delay (tau) in seconds
    tau = (peak_delay_index / samplef);

    % Return TDoA
    TDoA = tau;
end

%-------------------------------------------------------------------------

% Function call
% m1filtered = Signal (ref)
% m2filtered = Signal
% samplingf = Sampling frequency

% TDoA = estimateTDOA(m1filtered, m2filtered, samplingf);

% disp(['Estimated TDoA between M1 and M2: ' num2str(TDoA) ' seconds']);

%-------------------------------------------------------------------------

% function TDoA = TDoAFunction(x, y, samplef)
% tau = gccphat(x,y,samplef);
% TDoA = tau;
% end
