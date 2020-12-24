function entropy = MyVDfApEn(data,scale,delay,dim,r)
% This function returns the variance delay fuzzy approximate
%   entropy of an input row vector.
%----------------------INPUT ARGUMENTS----------------------%
% data   : input data as a row vector.
% scale  : scale of each data segment (tau).
% delay  : delay of each data segment (delta).
% dim    : dimension of each data segment (2 as default).
% r      : similarity tolerence (0.2 as default).
%-------------------------OUTPUT----------------------------%
% entropy: variance delay fuzzy approximate entropy, scalar.
%----------------------INPUT SYNTAX-------------------------%
% entropy = MyVDfApEn(data,tau,delay);  % (dim and r set as default)
% entropy = MyVDfApEn(data,tau,delay,dim);  % (r set as default)
% entropy = MyVDfApEn(data,tau,delay,dim,r);


%N = length(data);
if min(size(data)) ~= 1
    error('Input Error: input array should be a vector.')
end
if ~exist('dim','var') || ~isscalar(dim) || dim <= 0
    dim = 2;
end
if ~exist('r','var') || ~isscalar(r) || r <= 0
    r = .2;
end
r = r*nanstd(data);

%% Standardization
data_norm = (data - nanmean(data))./(nanstd(data)+1e-6);

%% Coarse-Grain
% Divide the RR series into a series of
%   non-overlapping segments
seq = get_coarse_grain(data_norm,scale);

%% Time Delay
seq_delayX = time_delay(seq,delay,dim);
seq_delayY = time_delay(seq,delay,dim+1);

%% Computing average similarity

phiX = get_similarity(seq_delayX,dim,r);
phiY = get_similarity(seq_delayY,dim+1,r);

%% Approximate entropy
entropy = -log((phiY+1e-6)/(phiX+1e-6));

end

function S = get_coarse_grain(W,tau)
% This function returns the coarse-grained version of the
%   input data array by grouping it into several scales and 
%   computing the variance of each scale as the final coarse
%   grain.
%----------------------INPUT ARGUMENTS----------------------%
% W  : input data as a row vector.
% tau: integer representing scale.
%-------------------------OUTPUT----------------------------%
% S  : coarse-grained data as a row vector. 
%----------------------INPUT SYNTAX-------------------------%
% S = get_coarse_grain(W,tau)

N = length(W);
C = floor(N/tau);
S = zeros(1,C);

for ll = 1:C
    start_ind = floor(tau*(ll-1) + 1);
    end_ind = floor(start_ind + tau - 1);
    %Wl = mean(W(start_ind:end_ind));
    %S(ll) = mean((W(start_ind:end_ind) - Wl).^2);
    S(ll) = nanvar(W(start_ind:end_ind),1);
end
end

function seq_delay = time_delay(S,delta,m)
% This function returns the delayed version
%   of the input data array.
%----------------------INPUT ARGUMENTS----------------------%
% S        : input data as a row vector.
% delta    : time delay, an integer (delta=1 meaning no delay).
% m        : dimension of the delayed sequences, an integer.
%-------------------------OUTPUT----------------------------%
% seq_delay: delayed version of the input data, a matrix. 
%----------------------INPUT SYNTAX-------------------------%
% seq_delay = time_delay(S,delta,m)

C = length(S);
seq_delay = zeros(floor(C-(m-1)*delta),m);
% each row of seq_delay contains an array
%   {s(ll),s(ll+delta),...,s(ll+(m-1)*delta)}

for ll = 1:size(seq_delay,1)
    seq_delay(ll,:) = S(ll:delta:(ll+(m-1)*delta));
end
end

function phi = get_similarity(X,m,r,nf)
if ~exist('nf','var') || ~isscalar(nf) || nf <= 0
    nf = 2;
end
% Here X is a matrix.
%N = size(X,2)+size(X,1)-1;
%count_norm = zeros(1,N-m+1);
num_row = size(X,1);
if m ~= size(X,2)
    disp(m)
    m = size(X,2);
    disp(m)
end
count_norm = zeros(1,num_row);


for ii = 1:num_row
    temp_i = X(ii,:);  % 1-by-m
    temp_X = X;
    temp_X(ii,:) = [];
    % | temp_i - temp_j | for j in [1,N-m+1] and j ~= i
    %distance_mat = abs(ones(size(temp_X,1),1) * temp_i - temp_X);
    %distance_mat = abs(repmat(temp_i,N-m,1) - temp_X);
    distance_mat = abs(repmat(temp_i,num_row-1,1) - temp_X);
    fuzzy_dist = zeros(1,size(distance_mat,1));
    for jj = 1:size(distance_mat,1)
        fuzzy_dist(jj) = exp(-(max(distance_mat(jj,:)))^nf/r);
    end
    count_norm(ii) = nanmean(fuzzy_dist);
end
phi = nanmean(count_norm);
end