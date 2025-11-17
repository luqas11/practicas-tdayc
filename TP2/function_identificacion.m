function medicion_filt = function_identificacion(medicion, Fc)
    Fs = 50;
    fc = Fc;                     % Hz (frecuencia de corte)
    Wn = fc/(Fs/2);             % frecuencia normalizada a Nyquist

    % Diseño del filtro (Butterworth 4to orden)
    [b,a] = butter(4, Wn, 'low');

    % Aplicación sin desfase (cero-fase)
    medicion_filt = filtfilt(b, a, medicion);
    L = length(medicion);
    f = Fs*(0:(L/2))/L;
    X = abs(fft(medicion)/L);
    Y = abs(fft(medicion_filt)/L);
    P1x = X(1:L/2+1);
    P1y = Y(1:L/2+1);
    P1x(2:end-1) = 2*P1x(2:end-1);
    P1y(2:end-1) = 2*P1y(2:end-1);
end