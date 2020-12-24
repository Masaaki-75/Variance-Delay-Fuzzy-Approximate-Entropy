%% Create Non-Linear Signals

NUM = 100:50:1000;  % parallel fApEn/VDfApEn test for 10 different N
R = 0.1:0.05:1;     % parallel fApEn/VDfApEn test for 10 different r
TAU = 1:10;         % parallel VDfApEn test for 10 different tau
DELAY = 1:10;       % parallel VDfApEn test for 3 different delay
p_mix = [0.1,0.5,0.9];
num_of_test_times = 15;  % averaging the test results of 3 repeated experiments
colorlist = {[0 0.4470 0.7410],[0.9290 0.6940 0.1250],[0.8500 0.3250 0.0980]};

%% Parallel Tests for fApEn and VDfApEn on Different N and r

% test results of fApEn for 10 different N
fapen_vs_N_result = zeros(3,length(NUM));

% test results of fApEn for 10 different R
fapen_vs_R_result = zeros(3,length(R));

% test results of VDfApEn for 10 different N
vdfapen_vs_N_result = zeros(3,length(NUM));

% test results of VDfApEn for 10 different R
vdfapen_vs_R_result = zeros(3,length(R));

% find stable results by performing mean value correction
fapen_vs_N_result_mean = cell(1,num_of_test_times);
fapen_vs_R_result_mean = cell(1,num_of_test_times);
vdfapen_vs_N_result_mean = cell(1,num_of_test_times);
vdfapen_vs_R_result_mean = cell(1,num_of_test_times);

for nn = 1:num_of_test_times
    % Create MIX() Data and Corresponding Varience
    MIX_collection = [MIX(1000,p_mix(1));MIX(1000,p_mix(2));MIX(1000,p_mix(3))];
    MIX_collection = MIX_collection(:,1:100);  % select 100 samples
    var1_5_secs = var_every_n_sec(MIX_collection(1,:),5);
    var2_5_secs = var_every_n_sec(MIX_collection(2,:),5);
    var3_5_secs = var_every_n_sec(MIX_collection(3,:),5);
    var1_5_secs = N_points_interp(var1_5_secs,length(MIX_collection(1,:)),'linear');
    var2_5_secs = N_points_interp(var2_5_secs,length(MIX_collection(2,:)),'linear');
    var3_5_secs = N_points_interp(var3_5_secs,length(MIX_collection(3,:)),'linear');
    var_5_secs = [var1_5_secs;var2_5_secs;var3_5_secs];
    
    for ii = 1:size(fapen_vs_N_result,1)
        % ii = 1:3
        % each row stores the data for different p (0.1,0.5,0.9)
        for jj1 = 1:size(fapen_vs_N_result,2)
            % each col stores the data for different N or r
            
            % N varying, dim=2, r=0.2
            %test_signal1 = MIX(NUM(jj1),p_mix(ii));
            
            MIX_a = [MIX(100,p_mix(1));MIX(100,p_mix(2));MIX(100,p_mix(3))];
            test_signal0 = MIX_a(ii,:);
            
            test_signal1 = N_points_interp(test_signal0,NUM(jj1),'linear');
            fapen_vs_N_result(ii,jj1) = MyfApEn(test_signal1);
            
            % N=200, dim=2, r varying
            %test_signal2 = MIX(200,p_mix(ii));
            %test_signal2 = MIX_collection(ii,:);
            test_signal2 = N_points_interp(test_signal0,200,'linear');
            fapen_vs_R_result(ii,jj1) = MyfApEn(test_signal2,2,R(jj1));
           
            % N varying, tau=3, delta=1, dim=2, r=0.2
            %test_signal3 = MIX(NUM(jj1),p_mix(ii));
            %test_signal3 = MIX_collection(ii,:);
            test_signal3 = N_points_interp(test_signal0,NUM(jj1),'linear');
            vdfapen_vs_N_result(ii,jj1) = MyVDfApEn(test_signal3,3,1);
            
            % N=200, tau=3, delta=1, dim=2, r varying
            %test_signal4 = MIX(200,p_mix(ii));
            %test_signal4 = MIX_collection(ii,:);
            test_signal4 = N_points_interp(test_signal0,200,'linear');
            vdfapen_vs_R_result(ii,jj1) = MyVDfApEn(test_signal4,3,1,2,R(jj1));
        end
    end
    fapen_vs_N_result_mean{nn} = fapen_vs_N_result;
    fapen_vs_R_result_mean{nn} = fapen_vs_R_result;
    vdfapen_vs_N_result_mean{nn} = vdfapen_vs_N_result;
    vdfapen_vs_R_result_mean{nn} = vdfapen_vs_R_result;
end

fapen_vs_N_result_mean = cellsum(fapen_vs_N_result_mean)/num_of_test_times;
fapen_vs_R_result_mean = cellsum(fapen_vs_R_result_mean)/num_of_test_times;
vdfapen_vs_N_result_mean = cellsum(vdfapen_vs_N_result_mean)/num_of_test_times;
vdfapen_vs_R_result_mean = cellsum(vdfapen_vs_R_result_mean)/num_of_test_times;


%% Parallel Tests for VDfApEn on Different tau and delay

% Frozen variables:
%   N = 200, dim = 2, r = 0.2
% Alternative variables:
%   tau = 1,2,3,4,5,6,7,8,9,10
%   delay = 1,2,3

% test results of VDfApEn for 10 different tau
vdfapen_vs_tau_result = zeros(3,length(TAU));

% test results of VDfApEn for 3 different delay
vdfapen_vs_delta_result = zeros(3,length(DELAY));

% find stable results by performing mean value correction
vdfapen_vs_tau_result_mean = cell(1,num_of_test_times);
vdfapen_vs_delta_result_mean = cell(1,num_of_test_times);

for nn = 1:num_of_test_times
    for ii = 1:size(vdfapen_vs_tau_result,1)
        % each row stores the data for different p (0.1,0.5,0.9)
        for jj1 = 1:size(vdfapen_vs_tau_result,2)
            % each col stores the data for different tau
            
            % N=200, tau varying, delay=1, dim=2, r=0.2
            test_signal5 = MIX_collection(ii,:);
            test_signal5 = N_points_interp(test_signal5,200,'spline');
            vdfapen_vs_tau_result(ii,jj1) = MyVDfApEn(test_signal5,TAU(jj1),1);
        end
        
        for jj2 = 1:size(vdfapen_vs_delta_result)
            % N=200, tau=3, delay varying, dim=2, r=0.2
            test_signal6 = MIX_collection(ii,:);
            test_signal6 = N_points_interp(test_signal6,200,'spline');
            vdfapen_vs_delta_result(ii,jj2) = MyVDfApEn(test_signal6,3,DELAY(jj2));
        end
    end
    vdfapen_vs_tau_result_mean{nn} = vdfapen_vs_tau_result;
    vdfapen_vs_delta_result_mean{nn} = vdfapen_vs_delta_result;
end

vdfapen_vs_tau_result_mean = cellsum(vdfapen_vs_tau_result_mean)/num_of_test_times;
vdfapen_vs_delta_result_mean = cellsum(vdfapen_vs_delta_result_mean)/num_of_test_times;

%% Visualization
figure(1)
for iii = 1:size(MIX_collection,1)
    subplot(1,size(MIX_collection,1),iii)
    plot(MIX_collection(iii,:),'linewidth',1), hold on
    plot(var_5_secs(iii,:),'linewidth',1)
    plot([0,100],[mean(var_5_secs(iii,:)),mean(var_5_secs(iii,:))],'r--')
    
    xlabel('Number of elements in nonlinear signals $i$',...
        'interpreter','latex','fontsize',12)
    ylabel(['MIX(',num2str(p_mix(iii)),') or varience'],...
        'interpreter','latex','fontsize',12)
    legend(['MIX(',num2str(p_mix(iii)),')'],'short-term var',...
        'interpreter','latex','fontsize',12,'location','southeast')
    axis([1 size(MIX_collection,2) -3 2.5])
end
% sgtitle('','interpreter','latex','fontsize',14)

figure(2)
for iii = 1:size(fapen_vs_N_result,1)
    plot(NUM,fapen_vs_N_result_mean(iii,:),'o-','linewidth',1.2,'color',colorlist{iii}), hold on
    % stem(fapen_vs_N_result(iii,:),'filled','linestyle','none','markersize',8,'color','#6F88FC','#A163F7')
end
legend(['MIX(',num2str(p_mix(1)),')'],['MIX(',num2str(p_mix(2)),')'],['MIX(',num2str(p_mix(3)),')'],...
        'interpreter','latex','fontsize',12,'location','northeast')
xlabel('$N$','interpreter','latex','fontsize',12)
ylabel('Fuzzy Approx. Entropy','interpreter','latex','fontsize',12)

figure(3)
for iii = 1:size(fapen_vs_R_result,1)
    plot(R,fapen_vs_R_result_mean(iii,:),'o-','linewidth',1.2,'color',colorlist{iii}), hold on
    % stem(fapen_vs_N_result(iii,:),'filled','linestyle','none','markersize',8,'color','#6F88FC','#A163F7')
end
legend(['MIX(',num2str(p_mix(1)),')'],['MIX(',num2str(p_mix(2)),')'],['MIX(',num2str(p_mix(3)),')'],...
        'interpreter','latex','fontsize',12,'location','northeast')
xlabel('$r$','interpreter','latex','fontsize',12)
ylabel('Fuzzy Approx. Entropy','interpreter','latex','fontsize',12)

figure(4)
for iii = 1:size(vdfapen_vs_N_result,1)
    plot(NUM,vdfapen_vs_N_result_mean(iii,:),'o-','linewidth',1.2,'color',colorlist{iii}), hold on
    % stem(fapen_vs_N_result(iii,:),'filled','linestyle','none','markersize',8,'color','#6F88FC','#A163F7')
end
legend(['MIX(',num2str(p_mix(1)),')'],['MIX(',num2str(p_mix(2)),')'],['MIX(',num2str(p_mix(3)),')'],...
        'interpreter','latex','fontsize',12,'location','northeast')
xlabel('$N$','interpreter','latex','fontsize',12)
ylabel('Varience Delay Fuzzy Approx. Entropy','interpreter','latex','fontsize',12)

figure(5)
for iii = 1:size(vdfapen_vs_R_result,1)
    plot(R,vdfapen_vs_R_result_mean(iii,:),'o-','linewidth',1.2,'color',colorlist{iii}), hold on
    % stem(fapen_vs_N_result(iii,:),'filled','linestyle','none','markersize',8,'color','#6F88FC','#A163F7')
end
legend(['MIX(',num2str(p_mix(1)),')'],['MIX(',num2str(p_mix(2)),')'],['MIX(',num2str(p_mix(3)),')'],...
        'interpreter','latex','fontsize',12,'location','northeast')
xlabel('$r$','interpreter','latex','fontsize',12)
ylabel('Varience Delay Fuzzy Approx. Entropy','interpreter','latex','fontsize',12)

figure(6)
for iii = 1:size(vdfapen_vs_tau_result,1)
    plot(TAU,vdfapen_vs_tau_result_mean(iii,:),'o-','linewidth',1.2,'color',colorlist{iii}), hold on
    % stem(fapen_vs_N_result(iii,:),'filled','linestyle','none','markersize',8,'color','#6F88FC','#A163F7')
end
legend(['MIX(',num2str(p_mix(1)),')'],['MIX(',num2str(p_mix(2)),')'],['MIX(',num2str(p_mix(3)),')'],...
        'interpreter','latex','fontsize',12,'location','northeast')
xlabel('$\tau$','interpreter','latex','fontsize',12)
ylabel('Varience Delay Fuzzy Approx. Entropy','interpreter','latex','fontsize',12)

figure(7)
for iii = 1:size(vdfapen_vs_delta_result,1)
    plot(DELAY,vdfapen_vs_delta_result_mean(iii,:),'o-','linewidth',1.2,'color',colorlist{iii}), hold on
    % stem(fapen_vs_N_result(iii,:),'filled','linestyle','none','markersize',8,'color','#6F88FC','#A163F7')
end
legend(['MIX(',num2str(p_mix(1)),')'],['MIX(',num2str(p_mix(2)),')'],['MIX(',num2str(p_mix(3)),')'],...
        'interpreter','latex','fontsize',12,'location','northeast')
xlabel('$\delta$','interpreter','latex','fontsize',12)
ylabel('Varience Delay Fuzzy Approx. Entropy','interpreter','latex','fontsize',12)

%% Functions
function var_n = var_every_n_sec(seq,n)
% This function computes the varience of the input 
%   time sequence in every n seconds.
%----------------------INPUT ARGUMENTS----------------------%
% seq: input data as a row vector.
% n  : number of samples in every n seconds.
%----------------------INPUT SYNTAX-------------------------%
% var_n = var_every_n_sec(seq,n)

seq_reshaped_in_rows = get_segmented_data(seq,n);
var_n = nanvar(seq_reshaped_in_rows,1,2);
% The 2nd argument takes 1 for normalization by N
var_n = var_n';

end

function Y = get_segmented_data(X,len)
N = length(X);
Y = zeros(floor(N/len),len);

% reshape() requires exact division of N and scale,
% not applied here.
for ii = 1:size(Y,1)
    if ii+len-1<=N
        start_ind = floor(len*ii - len + 1);
        end_ind = floor(start_ind + len - 1);
        Y(ii,:) = X(start_ind:end_ind);
    end
end
end

function sum_val = cellsum(c,dim)
% This function returns the sum of the matrices
%   contained in a cell array.
% e.g.:
% For a cell array c containing several 2x2 matrices:
%   c = { [1,2;3,4], [1,1;1,1], [0,0;0,1] };
%   c_sum = cellsum(c);
% The code above will return a matrix
%   c_sum == [2,3;4,6];
%----------------------INPUT ARGUMENTS----------------------%
% c      : input cell array containing matrices that
%          take the SAME size.
% dim    : integer representing the dimension of summation.
%-------------------------OUTPUT----------------------------%
% sum_val: sum of all the matrices contained in the input
%          cell array C, a matrix.
%----------------------INPUT SYNTAX-------------------------%
% sum_val = cellsum(c)
% sum_val = cellsum(c,dim)

if ~iscell(c)
    error('Input Error: Input should be a cell array.')
end

if ~exist('dim','var')
    dim = 3;
end

[row_c,col_c] = size(c);
[rows_of_each_array,cols_of_each_array] = cellfun(@size,c);
rowmax = max(max(rows_of_each_array));
rowmin = min(min(rows_of_each_array));
colmax = max(max(cols_of_each_array));
colmin = min(min(cols_of_each_array));

if (rowmax==rowmin) && (colmax==colmin)
    temp_arr = zeros(rows_of_each_array(1),cols_of_each_array(1));
    % TO-DO: finish the case of dim==1 and dim==2
    if dim == 3
        for rr = 1:row_c
            for cc = 1:col_c
                temp_arr = temp_arr + c{rr,cc};
            end
        end
        sum_val = temp_arr;
    else
        error('Input Error: Sorry, cases with dim~=3 has not been completed.')
    end
else
    error('Input Error: The arrays in the cell are not equal in size.')
end
end