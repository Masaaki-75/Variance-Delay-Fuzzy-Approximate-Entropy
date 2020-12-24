function varargout = get_freq_indices(signal,fs)
% This function returns the low-frequency power (LF)
%   and high-frequency power (HF) of an input row vector.
%----------------------INPUT ARGUMENTS----------------------%
% signal: input R-R sequence as a row vector.
% fs    : sampling frequency of the input signal.
%-------------------------OUTPUT----------------------------%
% LF    : low-frequency power of the input signal.
%         (0.04¨C0.15 Hz)
% HF    : high-frequency power of the input signal.
%         (0.15¨C0.4 Hz)
% TP    : total power of the input signal.
%         (0-0.4 Hz)
%----------------------INPUT SYNTAX-------------------------%
% [LF,HF] = get_freq_indices(signal,fs);
% [LF,HF,TP] = get_freq_indices(signal,fs);

signal = N_points_interp(signal,2*length(signal),'linear');
if ~exist('fs','var')
    fs = 2;
end

[y,fn] = pburg(signal,6,1024,fs);
delta_f = fn(2) - fn(1);

HF = y(fn>=0.15&fn<0.4);
LF = y(fn>=0.04&fn<0.15);

% Consider discretizing the integral 
%   into a summation TP = ¦²(y*f).
HF = sum(HF*delta_f);
LF = sum(LF*delta_f);

varargout{1} = LF;
varargout{2} = HF;

if nargout == 3
    TP = y(fn<=0.4);
    TP = sum(TP*delta_f);
    varargout{3} = TP;
end
    
end
