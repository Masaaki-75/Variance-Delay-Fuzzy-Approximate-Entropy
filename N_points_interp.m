function varargout = N_points_interp(varargin)
% This function returns the interpolated array
%   with N points using certain method.
%----------------------INPUT ARGUMENTS----------------------%
% arr:    input array.
% N:      total number of the output array.
% method: string indicating the method of interpolation.
%----------------------INPUT SYNTAX-------------------------%
% interp_arr = N_points_interp(arr,N,method)

if nargin < 4
    if isnumeric(varargin{1})
        arr = varargin{1};
        if isscalar(varargin{2}) && varargin{2}>0
            N = varargin{2};
            if nargin == 3
                if ischar(varargin{3})
                    method = varargin{3};
                else
                    method = 'spline';
                end
            else
                method = 'spline';
            end
        end
    end
else
    n_arr = varargin{1};
    arr = varargin{2};
    N = varargin{3};
    method = varargin{4};
end

method_name = sanitycheckmethod(method);

if ~exist('n_arr','var')
    n_arr = 1:length(arr);
end

if length(arr) ~= length(n_arr)
    error('Input Error: input n_array should take the same size of input array.')
end

n_arr_interp = linspace(n_arr(1),n_arr(end),N+2);
n_arr_interp = n_arr_interp(1:end-1);
n_arr_interp = n_arr_interp(2:end);

interp_arr = interp1(n_arr,arr,n_arr_interp,method_name);

if nargout == 2
    varargout{1} = [n_arr(1), n_arr_interp, n_arr(end)];
    varargout{2} = interp_arr;
else
    varargout{1} = interp_arr;
end
end


function methodname = sanitycheckmethod(method_in)
method = char(method_in); %string support
if isempty(method)
    methodname = 'linear';
else
    if method(1) == '*'
        method(1) = [];
    end
    switch lower(method(1))
        case 'n'
            if strncmpi(method,'nex',3)
                methodname = 'next';
            else
                methodname = 'nearest';
            end
        case 'l'
            methodname = 'linear';
        case 's'
            methodname = 'spline';
        case 'c'
            methodname = 'pchip';
            warning(message('MATLAB:interp1:UsePCHIP'));
        case 'p'
            if strncmpi(method,'pr',2)
                methodname = 'previous';
            else
                methodname = 'pchip';
            end
        case 'v'  % 'v5cubic'
            methodname = 'cubic';
        case 'm'
            methodname = 'makima';
        otherwise
            error(message('MATLAB:interp1:InvalidMethod'));
    end
end
end