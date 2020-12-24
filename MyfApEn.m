function entropy = MyfApEn(data,m,r)
%----------------------INPUT ARGUMENTS----------------------%
% data: Input data as a row vector.
% m   : The length of sequences to be compared (2 as default).
%         larger dim allows more detailed reconstruction of the
%         dynamic process. But a too large value is unfavorable 
%         due to the need of a very large N=length(data) 
%         leading to information loss.
% r   : Similarity tolerence (0.2 as default)
%----------------------INPUT SYNTAX-------------------------%
% entropy = MyfApEn(data);  % (m and r set as default)
% entropy = MyfApEn(data,dim);  % (r set as default)
% entropy = MyfApEn(data,dim,r);

%% Input Arguments Processing
if min(size(data)) ~= 1
    % input a matrix
    error('Input Error: input data should be a row vector.')
else
    if size(data,2) == 1 && size(data,1) > 1
        % convert col-vector data into a row vector.
        data = data';
    end
end

if min(size(data)) ~= 1
    % input a matrix
    error('Input Error: input data should be a row vector.')
else
    if size(data,2) == 1 && size(data,1) > 1
        % convert col-vector data into a row vector.
        data = data';
    end
end

% N = length(data);
if ~exist('dim','var') || ~isscalar(m) || m <= 0
    m = 2;
end
if ~exist('r','var') || ~isscalar(r) || r <= 0
    r = .2;
end
r = r*std(data);

%% Create data segment

% Reshape the data into a (N-m+1)-by-m matrix,
%   with each row containing a 1-by-m vector.
X = data_seg(data, m);
% Obtain mean vals of each row as a (N-m+1)-by-1 vector U.
U = mean(X,2);
% Replicate U as a (N-m+1)-by-m matrix.
U = repmat(U,1,m);
% Subtraction performed on each row of X with corresponding mean vals.
X = X - U;

Y = data_seg(data, m+1);
V = mean(Y,2);
V = repmat(V,1,m+1);
Y = Y - V;

%% Computing average similarity

phiX = get_similarity(X,m,r);
phiY = get_similarity(Y,m+1,r);

%% Approximate entropy
entropy = -log((phiY+1e-6)/(phiX+1e-6));

end

function seg = data_seg(data,dim)
% This function returns the consecutive segments
%   of the input data array, with dim the dimension
%   of each segments.
%----------------------INPUT ARGUMENTS----------------------%
% data: input data as a row vector.
% dim:  dimension of each segment of the data.
%----------------------INPUT SYNTAX-------------------------%
% seg = data_seg(data,dim)

% It also works with
% >> seg = reshape(data,[],dim)';
% However, to circumvent the problem of data leakage
%   which requires dynamic modulation when using reshape(),
%   here we simply apply for-loops.

% convert the input data into row vectors
if size(data,1) > size(data,2) && min(size(data)) == 1
    data = data';
end

Ndata = length(data);
seg = zeros(Ndata-dim+1,dim);
% segment the data into N-m+1 sub-array
% each sub-array contains m elements
for kk = 1:Ndata-dim+1
    seg(kk,:) = data(kk:kk+dim-1);
end
end


function phi = get_similarity(X,m,r,nf)
% This function returns the similarity
%   of the input matrix X, with dim the dimension
%   of each row in X.
%----------------------INPUT ARGUMENTS----------------------%
% X   : Input data as a matrix.
% m   : Dimension of each row of the data.
% r   : Width of the border.
% nf  : Gradient of boundary.
%----------------------INPUT SYNTAX-------------------------%
% seg = data_seg(data,dim)

if ~exist('nf','var') || ~isscalar(nf) || nf <= 0
    nf = 2;
end

% X as an (N-m+1)-by-m matrix.
N = size(X,1)+size(X,2)-1;
count_norm = zeros(1,N-m+1);
for ii = 1:N-m+1
    temp_i = X(ii,:);  % X_ii^m, 1-by-m
    temp_X = X;
    temp_X(ii,:) = [];  % remove the ii-th row
    % temp_X now is an (N-m)-by-m matrix
    
    % | temp_i - temp_j | for j in [1,N-m+1] and j ~= i
    distance_mat = abs(repmat(temp_i,N-m,1) - temp_X);  % (N-m)-by-m matrix
    %distance_mat = abs(ones(size(temp_X,1),1) * temp_i - temp_X);
    
    fuzzy_dist = zeros(1,size(distance_mat,1));  % 1-by-(N-m) matrix
    for jj = 1:size(distance_mat,1)
        fuzzy_dist(jj) = exp(-(max(distance_mat(jj,:)))^nf/r);
    end
    count_norm(ii) = nanmean(fuzzy_dist);
end
phi = nanmean(count_norm);
end