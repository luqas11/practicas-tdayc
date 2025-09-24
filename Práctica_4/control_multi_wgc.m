% Transferencia del sistema
sys_cont
%bode(sys_cont)
pole(sys_cont)

% Parámetros del Bode
optionss=bodeoptions;
optionss.PhaseMatching='on';
optionss.PhaseMatchingValue=-180;
optionss.PhaseMatchingFreq=1;
optionss.Grid='on';

% Hago un primer diseño de control integral, veo en qué frecuencia C1*P0 resta 120°, y la elijo como mi wgc
C1 = zpk([], [0], 1);
%bode(C1*sys_cont, optionss)
% Vector de valores de wgc de 1 a 20
wgc_values = 1:0.1:7;

% Prealocación de resultados
phase_margin   = zeros(size(wgc_values));
overshoot      = zeros(size(wgc_values));
settling_time  = zeros(size(wgc_values));
closed_poles   = cell(size(wgc_values));

for i = 1:length(wgc_values)
    wgc = wgc_values(i);

    % Ganancia para que C2*P tenga 0 dB en la wgc
    k = 1/abs(evalfr(C1*sys_cont, 1j*wgc));
    C2 = C1*k;

    % Sistema compensado
    C = minreal(C2);
    L = minreal(C*sys_cont);
    T = minreal(L/(1+L));

    % Verificación de estabilidad
    closed_poles{i} = pole(T);

    % Verificación de sobrepico y margen de fase
    phase_margin(i)  = 180 + rad2deg(angle(evalfr(L, 1j*wgc))); % margen de fase
    info             = stepinfo(T);
    overshoot(i)     = info.Overshoot;
    settling_time(i) = info.SettlingTime;
end

% Mostrar resultados
table(wgc_values', phase_margin', overshoot', settling_time', ...
    'VariableNames', {'wgc', 'PhaseMargin_deg', 'Overshoot_%', 'SettlingTime_s'})
