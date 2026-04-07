% Chosen electrodes (channels) : F3 (EEG.data(4,:)) and P3 (EEG.data(14,:))

%% Define the sample frequency
fs = 256;

%% Select the data
x = EEG.data(4,:);                  %Size of the signal = 30976

%% Computation and display of the power spectrum - Use of sliding windows
% Parameters for sliding window and STFT
window_size = 500;      % Size of the sliding window
overlap = 0.5;          % Overlap percentage between consecutive windows

% Compute power spectrum on sliding windows
% Find the number of windows
num_windows = floor((length(x) - window_size) / (window_size * (1 - overlap)));
power_spectrum = zeros(window_size/2 + 1, num_windows);

for i = 1:num_windows
    start_index = round((i-1) * window_size * (1 - overlap)) + 1;
    end_index = start_index + window_size - 1;
    windowed_signal = x(start_index:end_index);
    
    % Compute the power spectrum
    [spect, freq] = pwelch(windowed_signal, hamming(window_size), window_size/2, window_size, fs);
    
    % Store power spectrum
    power_spectrum(:, i) = spect;
end

% Display the power spectrum
figure;
imagesc((1:num_windows)*window_size/fs, freq, 10*log10(power_spectrum)); % Display in dB
colormap('jet');
colorbar;
ylabel('Frequency (Hz)');
title('Power Spectrum of EEG Signal on Sliding Windows, Channel: F3'); % or Channel: P3

%% Computation and display of the power spectrum - Use of STFT

% Parameters for STFT
window_size = 256; % Size of the window for each segment
overlap = 0.5; % Overlap percentage between consecutive windows

% Compute STFT
[spect, freq, times] = stft(x, fs, 'Window', hamming(window_size), 'OverlapLength', round(overlap * window_size));

% Compute power spectrum
power_spectrum = abs(spect).^2;

% Display the positive part of the power spectrum
positive_frequencies_mask = freq >= 0;
positive_frequencies = freq(positive_frequencies_mask);

figure;
imagesc(times, positive_frequencies, 10*log10(power_spectrum(positive_frequencies_mask, :))); % Display in dB
colormap('jet');
colorbar;
xlabel('Time (s)');
ylabel('Frequency (Hz)');
title('Power Spectrum of EEG Signal (STFT), Channel: F3');  % or Channel: P3

%% Computation and display of the power spectrum - Use of Wavelets
% Compute of the Continuous Wavelet Transform (CWT) - Using the Morlet wavelet

% Parameters for wavelet transform
scales = 1:128;        % Scales for wavelet transform
wavelet_type = 'morl'; % Morlet wavelet is commonly used in EEG analysis

% Compute Continuous Wavelet Transform (CWT)
[cwt_coeffs, freq] = cwt(x, scales, wavelet_type, fs);

% Compute power spectrum from CWT coefficients
power_spectrum = abs(cwt_coeffs).^2;

% Display the power spectrum
figure;
imagesc(t, freq, 10*log10(power_spectrum)); % Display in dB
colormap('jet');
colorbar;
xlabel('Time (s)');
ylabel('Frequency (Hz)');
title('Power Spectrum of EEG Signal using Wavelets, Channel: F3');