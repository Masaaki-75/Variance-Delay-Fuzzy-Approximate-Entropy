function simul = MIX(varargin)
% This function returns the simulated signal.
%----------------------INPUT ARGUMENTS----------------------%
% p:   parameters of the distribution.
% eye: number of samples (i).
%----------------------INPUT SYNTAX-------------------------%
% simul = MIX(p);
% simul = MIX(p,eye);
% simul = MIX(eye,p);

if nargin == 1
    if isscalar(varargin{1}) 
        if varargin{1} <= 1 && varargin{1} >= 0
            p = varargin{1};
        else
            error('Input Error: p should be an integer in [0,1].')
        end
    else
        error('Input Error: p should be an integer in [0,1].')
    end
    eye = 1000;
else
    temp = sort(cell2mat(varargin));
    p = temp(1);
    eye = temp(2);
end

Xi = 2*sin(2*pi*[1:eye]/12);
Yi = 2*sqrt(3)*rand(1,eye) - sqrt(3);
Zi = binornd(1,p,1,eye);
simul = (1-Zi).*Xi + Zi.*Yi;
end