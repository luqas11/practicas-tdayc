function alpha = function_regresion(position_filt, angle_filt)
    y = position_filt(3:end);
    x1 = position_filt(2:end-1);
    x2 = position_filt(1:end-2);
    u = angle_filt(3:end);
    x = [x1 x2 u];

    alpha = inv(x' * x) * x' * y;
end