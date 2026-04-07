%% Define the sample frequency
fs = 256;

%% Select the data
% Dataset A
x1 = EEG.data(4,:);              %or EEG.data(14,:)
x2 = EEG.data(14,:);              

% Dataset B
x3 = EEG.data(4,:);
x4 = EEG.data(14,:);

%% Parameters for sliding window
window_size = 500; % Size of the sliding window
overlap = 0.5; % Overlap percentage between consecutive windows
num_windows = floor((length(x) - window_size) / (window_size * (1 - overlap)));


%% Compute signal morphology features on sliding windows
% Signal morphology features often involve analyzing the shape of the signal, 
% such as its mean, variance, skewness, and kurtosis. 
mean_values = zeros(1, num_windows);
standard_deviation_values =  zeros(1, num_windows);
variance_values = zeros(1, num_windows);
skewness_values = zeros(1, num_windows);
kurtosis_values = zeros(1, num_windows);

for i = 1:num_windows
    start_index = round((i-1) * window_size * (1 - overlap)) + 1;
    end_index = start_index + window_size - 1;
    windowed_signal = x(start_index:end_index);
    
    % Compute morphology features
    mean_values(i) = mean(windowed_signal);
    standard_deviation_values(i) = std(windowed_signal);
    variance_values(i) = var(windowed_signal);

    skewness_values(i) = skewness(windowed_signal);
    kurtosis_values(i) = kurtosis(windowed_signal);
end

% Plot the results
figure;

subplot(5,1,1);
plot(mean_values);
title('Mean');

subplot(5,1,2);
plot(standard_deviation_values);
title('Standard deviation');

subplot(5,1,3);
plot(variance_values);
title('Variance');

subplot(5,1,4);
plot(skewness_values);
title('Skewness');

subplot(5,1,5);
plot(kurtosis_values);
title('Kurtosis');
xlabel('Window Index');

sgtitle('Signal Morphology Features, Dataset B, Channel: F3');

%% Linear univariate analysis in time domain on sliding windows

% Compute autocovariance and autocorrelation
autocovariance = [];
autocorrelation = [];

for i = 1:(length(x)-window_size+1)
    % Extract the current window
    windowed_signal = x(i:i+window_size-1);
    
    % Compute autocovariance for the current window
    cov_result = xcov(windowed_signal, 'coeff');
    
    % Extract the autocorrelation part from the result
    autocorrelation_result = cov_result(window_size:end);
    
    % Store the autocovariance and autocorrelation results
    autocovariance = [autocovariance, cov_result(window_size)];
    autocorrelation = [autocorrelation, autocorrelation_result];
end

% Plot results
figure;
subplot(2, 1, 1);
plot(autocovariance);
title('Autocovariance');
xlabel('Window Index');
ylabel('Autocovariance');

subplot(2, 1, 2);
plot(autocorrelation);
title('Autocorrelation');
xlabel('Lag');
ylabel('Autocorrelation');

sgtitle('Dataset A, Channel: P3');

%% Linear univariate analysis in frequency domain on sliding windows
x = EEG.data(4,:);              %or EEG.data(14,:)

% Frequency bands
delta_band = [1 4]; % Delta frequency band (1-4 Hz)
theta_band = [4 8]; % Theta frequency band (4-8 Hz)
alpha_band = [8 13]; % Alpha frequency band (8-13 Hz)
beta_band = [13 30]; % Beta frequency band (13-30 Hz)

% Compute power spectrum
[Pxx, freq] = pwelch(x, hamming(window_size), window_size/2, window_size, fs);

% Find indices corresponding to frequency bands
delta_indices = find(freq >= delta_band(1) & freq <= delta_band(2));
theta_indices = find(freq >= theta_band(1) & freq <= theta_band(2));
alpha_indices = find(freq >= alpha_band(1) & freq <= alpha_band(2));
beta_indices = find(freq >= beta_band(1) & freq <= beta_band(2));

% Extract power in frequency bands
delta_power = sum(Pxx(delta_indices));
theta_power = sum(Pxx(theta_indices));
alpha_power = sum(Pxx(alpha_indices));
beta_power = sum(Pxx(beta_indices));

% Create the array that contains the values
% Plot power spectrum in frequency bands
figure;
plot(freq, 10*log10(Pxx));
hold on;

% Highlight frequency bands
yLimits = ylim;
patch([delta_band(1), delta_band(2), delta_band(2), delta_band(1)], [yLimits(1), yLimits(1), yLimits(2), yLimits(2)], 'r', 'FaceAlpha', 0.2);
patch([theta_band(1), theta_band(2), theta_band(2), theta_band(1)], [yLimits(1), yLimits(1), yLimits(2), yLimits(2)], 'g', 'FaceAlpha', 0.2);
patch([alpha_band(1), alpha_band(2), alpha_band(2), alpha_band(1)], [yLimits(1), yLimits(1), yLimits(2), yLimits(2)], 'b', 'FaceAlpha', 0.2);
patch([beta_band(1), beta_band(2), beta_band(2), beta_band(1)], [yLimits(1), yLimits(1), yLimits(2), yLimits(2)], 'm', 'FaceAlpha', 0.2);

hold off;
xlabel('Frequency (Hz)');
ylabel('Power/Frequency (dB/Hz)');
title('Power Spectrum in EEG Frequency Bands, Dataset A, Channel: F3');
legend({'Power Spectrum', 'Delta Band', 'Theta Band', 'Alpha Band', 'Beta Band'}, 'Location', 'northeast');
grid on;

% Percentage for spectral edge frequency calculation
percentage = 95;
median = 50;

% Normalize the power spectrum to sum to 1
normalized_Pxx = Pxx / sum(Pxx);

% Calculate the spectral edge frequency
cumulative_power = cumsum(normalized_Pxx);
edge_index = find(cumulative_power >= percentage / 100, 1, 'first');
spectral_edge_frequency = freq(edge_index);

median_index = find(cumulative_power >= median / 100, 1, 'first');
median_frequency = freq(median_index);

% Plot the power spectrum with the spectral edge frequency
figure;
plot(freq, 10*log10(Pxx));
hold on;
plot([spectral_edge_frequency, spectral_edge_frequency], ylim, 'k--', 'LineWidth', 2);
plot([median_frequency, median_frequency], ylim, 'r--', 'LineWidth', 2);

hold off;

xlabel('Frequency (Hz)');
ylabel('Power/Frequency (dB/Hz)');
title(['Power Spectrum with Spectral edge and median frequencies']);
legend({'Power Spectrum', ...
    ['Spectral Edge Frequency: ', num2str(spectral_edge_frequency), ' Hz'], ...
    ['Median Frequency: ', num2str(median_frequency), ' Hz'] }, 'Location', 'northeast');
grid on;

%% Nonlinear univariate analysis in time domain
% ------ Calculation of the approximate entropy ----- 

m = 2;            % Embedding dimension
r1 = 0.2 * std(x1); % Tolerance for similarity criterion
r2 = 0.2 * std(x2); % Tolerance for similarity criterion
r3 = 0.2 * std(x3); % Tolerance for similarity criterion
r4 = 0.2 * std(x4); % Tolerance for similarity criterion

% Calculate approximate entropy (ApEn)
apen_result_1 = approximateEntropy(x1);
apen_result_2 = approximateEntropy(x2);
apen_result_3 = approximateEntropy(x3);
apen_result_4 = approximateEntropy(x4);

apen_results = [apen_result_1, apen_result_2, apen_result_3, apen_result_4];

% Bar plot
figure;
bar(apen_results);

xlabel('Signals');
ylabel('Approximate Entropy Values');
title('Approximate entropy');
xticklabels({'Channel F3, Dataset: A', 'Channel P3, Dataset: A', ...
             'Channel F3, Dataset: B', 'Channel P3, Dataset: B'}); % Adjust category labels
grid on;

% Display values on top of the bars
text(1:length(apen_results), apen_results, num2str(apen_results'), 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');


% ------ Calculation of the correlation dimension ----- 
corDim1 = correlationDimension(x1);
corDim2 = correlationDimension(x2);
corDim3 = correlationDimension(x3);
corDim4 = correlationDimension(x4);

corDim_results = [corDim1, corDim2, corDim3, corDim4];

% Bar plot
figure;
bar(corDim_results);

xlabel('Signals');
ylabel('Correlation Dimension Values');
title('Correlation Dimension');
xticklabels({'Channel F3, Dataset: A', 'Channel P3, Dataset: A', ...
             'Channel F3, Dataset: B', 'Channel P3, Dataset: B'}); % Adjust category labels
grid on;

% Display values on top of the bars
text(1:length(corDim_results), corDim_results, num2str(corDim_results'), 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');


%% Linear multivariate analysis in frequency domain
%%To compute the connectivity between two EEG signals, you can use various 
% measures such as coherence, cross-correlation, or mutual information.

% --------- Compute the coherence of signals that belong to the same recording -----------
window_size = 512; % Set the window size for coherence calculation
overlap = 256;     % Set the overlap between windows

[coherence1, f1] = mscohere(x1, x2, hamming(window_size), overlap, window_size, fs);

% Plot coherence
figure;
plot(f1, coherence1);
xlabel('Frequency (Hz)');
ylabel('Coherence');
title('Dataset A, Coherence between EEG signals');
grid on;

[coherence2, f2] = mscohere(x3, x4, hamming(window_size), overlap, window_size, fs);

% Plot coherence
figure;
plot(f2, coherence2);
xlabel('Frequency (Hz)');
ylabel('Coherence');
title('Dataset B, Coherence between EEG signals');
grid on;


% --------- Compute the cross-spectrum of signals that belong to the same recording -----------

[cross_spectrum1, f1] = cpsd(x1, x2, hamming(window_size), overlap, window_size, fs);
[cross_spectrum2, f2] = cpsd(x3, x4, hamming(window_size), overlap, window_size, fs);

% Plot cross-spectrum
figure;
plot(f1, abs(cross_spectrum1));
xlabel('Frequency (Hz)');
ylabel('Cross-Spectrum');
title('Dataset A, Cross-Spectrum between EEG signals');
grid on;

figure;
plot(f2, abs(cross_spectrum2));
xlabel('Frequency (Hz)');
ylabel('Cross-Spectrum');
title('Dataset B, Cross-Spectrum between EEG signals');
grid on;