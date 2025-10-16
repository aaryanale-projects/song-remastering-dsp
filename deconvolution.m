% Deconvolution and Sound Enhancement
%
% Nonlinear filtering is required since the noise spectrum completely overlaps 
% with that of the voice signal, both occupying the frequency range of approximately 
% 200 Hz to 3.2 kHz.
%
% Two primary approaches can be used:
%
% 1. Amplitude-Based Partial Separation:
%    - Partially distinguish components based on their amplitude levels.
%    - Attenuate smaller, irregular frequency components (typically noise) 
%      while retaining dominant frequency components (voice).
%
% 2. Homomorphic Filtering:
%    - Transforms the nonlinear convolution problem into a linear one.
%    - Steps involved:
%        > Apply the Fourier Transform to convert convolution in time domain 
%          into multiplication in the frequency domain.
%        > Represent the signal as a product of the clean audio signal a[] 
%          and a gain or distortion function g[].
%        > Take the logarithm of the product: log(a[] * g[]) = log(a[]) + log(g[]).
%        > Apply a linear filter to pass or reject specific frequencies. 
%          (Since g[] mainly consists of low-frequency components, it can be 
%           suppressed using a high-pass filter.)
%        > Perform the inverse logarithm and inverse FFT (IFFT) to reconstruct 
%          the enhanced audio signal a[].
%
%    In essence, this process converts a[] * g[] into a[] — effectively isolating 
%    and restoring the desired clean signal.
%
% Reference:
% https://www.mathworks.com/help/signal/ref/designfilt.html#mw_83b47e78-46c6-434f-8114-5f986269f98d


function z = decon_function(nameIn,len,convState)

    [y,Fs] = audioread(nameIn);
    samples = [1, len*Fs];
    clear y Fs;
    [y,Fs] = audioread(nameIn,samples);

    Fn = Fs/2;                                              % Nyquist Frequency (Hz)
    Wp = 500/Fn;                                           % Passband Frequency (Normalised)
    Ws = 520/Fn;                                           % Stopband Frequency (Normalised)
    Rp =    60;                                               % Passband Ripple (dB)
    Rs =    160;                                               % Stopband Ripple (dB)
    [n,Ws] = cheb2ord(Wp,Ws,Rp,Rs);                         % Filter Order
    [z,p,k] = cheby2(n,Rs,Ws,'high');                        % Filter Design
    [soslp,glp] = zp2sos(z,p,k);                            % Convert To Second-Order-Section For Stability
%    figure(1);
%     freqz(soslp, 2^16, Fs);
%     title('High Pass Filter');
    if(convState == 1)
        disp('Starting convolution handling');
%         figure(2);
%         hold on;
        fd = fft(y);
        li = log(fd);
        outpFreq = filtfilt(soslp,glp,li);
        outpFreqInLog = exp(outpFreq);
        outpFreqFin = ifft(outpFreqInLog);
%         plot(1:length(outpFreq), -outpFreq, 'y');
%         plot(1:length(outpFreqInLog), -outpFreqInLog, 'b');
%         hold off;
%         
%         xlim([0 length(outpFreq)]);
%         ylim([0 8]);
%         title('Audio Signal');
%         xlabel('Samples');
%         ylabel('Amplitude');
%         legend({'Original Signal','Noise','Filtered Signal'},'Location', 'northeast');
         x = real(outpFreqFin);

    elseif(convState == 2)
        disp('No convolution');
        fd = y;
        li = log(fd);
        outpFreq = filtfilt(soslp,glp,li);     %filter(d, li);
        outpFreqFin = exp(outpFreq);
        x = real(double(outpFreqFin));
    end
     z = y - x;
     z = Second_Gaussian(z, Fs);
%      sound(y, Fs);
%      pause(32);
     sound(z, Fs);

%        d = designfilt('highpassfir', ...       % Response type
%        'StopbandFrequency',200, ...     % Frequency constraints
%        'PassbandFrequency',350, ...
%        'StopbandAttenuation',60, ...    % Magnitude constraints
%        'PassbandRipple',4, ...
%        'DesignMethod','kaiserwin', ...  % Design method
%        'ScalePassband',false, ...       % Design method options
%        'SampleRate',2000);
%    fvtool(d);                                       % Sampling Frequency (Hz)
%     at = filter(hpf,[li; zeros(D,1)]);
%     input = at(D+1:end);
%     z = filter(hpf,input);
    
end

%gaussian filter whole window, 50Hz high pass
function z = Second_Gaussian(y,Fs)
    w = gausswin(length(y)); % gaussian window
    w = [zeros(length(y) ,1); w; zeros(length(y),1)]; %zero pad signal
    
    %perform convolution
    a = fft(w);
    b = fft([zeros(length(y),1); y(:,1); zeros(length(y),1)]);
    c = fft([zeros(length(y),1); y(:,2); zeros(length(y),1)]);
    filteredSignal1 = ifft(a.*b);
    filteredSignal2 = ifft(a.*c);

    z(:,1) = highpass(filteredSignal1(1:length(y),1),50,Fs);
    z(:,2) = highpass(filteredSignal2(1:length(y),1),50,Fs);
end
