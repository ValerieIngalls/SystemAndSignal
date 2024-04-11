function [] = mySpectrogram(x, fs, fftSize)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

N = length(x);
frameStart = 1; % starting point
frameEnd = fftSize; % end of current frame
stepSize = round(fftSize/2);
k = 1; % iterator
win = hann(fftSize); % Hann window

% initialize output matrix
nFrames = floor(N/stepSize);
X = zeros(fftSize, nFrames);

while frameEnd < N
    frame = x(frameStart:frameEnd); % current frame
    frame = frame .* win; % apply window
    X(:, k) = fft(frame); % take fft, add it to results matrix
    % increment
    frameStart = frameStart + stepSize;
    frameEnd = frameEnd + stepSize;
    k = k + 1;
end

magnitudes = abs(X); % calculate magnitude
dbMag = 20*log10(magnitudes); % convert to dB SPL

frequency = (0:1:fftSize-1)'*(fs/fftSize); % (in Hz)
frequency = frequency / 1000; % (in kHz)

magnitudes = dbMag(1:fftSize/2,:); % take un-aliased half
frequency = frequency(1:fftSize/2);

sampleLength = N/fs; % total sample time in seconds
frameLength = sampleLength/nFrames; % nFrames defined earlier
time = (0:1:nFrames-1)*frameLength; % time vector
time = time * 1000; % seconds to ms

% Plot
figure
surface(time, frequency, magnitudes)
shading interp % smooth shading
colormap('jet')
view([0 90]) % set view to look down directly from above
xlim([time(1),time(end)]) % force tight bounderies
ylim([0,8]) % restrict frequency view; don't need more for speech
xlabel('Time (ms)','FontSize',12) % label axes
ylabel('Frequency (kHz)','FontSize',12)
hold off
end