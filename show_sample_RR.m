% run freq_indices_test.m first to get the following data
%load 'normal_per_subj';
%load 'mmOSA_per_subj';
%load 'sOSA_per_subj';

% 5-min sample array
n_subj = 30;
% 3 6(8) 24
%a = [randi(length(normal_per_subj)),...
%    randi(length(mmOSA_per_subj)),...
%    randi(length(sOSA_per_subj))];
a = [3,randi(length(mmOSA_per_subj)),24];
samps = {normal_per_subj{a(1)}{n_subj},...
    mmOSA_per_subj{a(2)}{n_subj},...
    sOSA_per_subj{a(3)}{n_subj}};
minlen = min([length(samps{1}),length(samps{2}),length(samps{3})]);
vars = zeros(3,minlen);
etp = zeros(2,3);
tltstr = {'normal subject',...
    'mild-moderate OSA subject',...
    'severe OSA subject'};

for ii = 1:3
    
    vars(ii,:) = N_points_interp(var_every_n_sec(samps{ii},5),minlen,'linear');
    vars(ii,:) = min_max_norm(vars(ii,:))*5;
    etp(1,ii) = MyfApEn(samps{ii});
    etp(2,ii) = MyVDfApEn(samps{ii},3,1);  % scale=3,delay=1
    
    subplot(3,1,ii)
    plot(samps{ii},'linewidth',1.2), hold on
    plot(vars(ii,:),'linewidth',1.2)
    xlabel('Time (s)','interpreter','latex','fontsize',12)
    ylabel({'RR interval or variance','(s or s$^2$)'},'interpreter','latex','fontsize',12)
    legend('RR interval','5-point variance',...
        'interpreter','latex','fontsize',12,'location','northwest')
    text(0.8,0.7,{['fApEn=',num2str(etp(1,ii))],['VDfApEn=',num2str(etp(2,ii))]},...
        'interpreter','latex','fontsize',12,'units','normalized')
    axis([1,minlen,0,5]);
    title(['RR segment of ',tltstr{ii}],'interpreter','latex','fontsize',14)
end


function var_n = var_every_n_sec(seq,n)
% This function computes the varience of the input 
%   time sequence in every n seconds.
%----------------------INPUT ARGUMENTS----------------------%
% seq: input data as a row vector.
% n  : number of samples in every n seconds.
%----------------------INPUT SYNTAX-------------------------%
% var_n = var_every_n_sec(seq,n)

seq_reshaped_in_rows = get_segmented_data(seq,n);
var_n = nanvar(seq_reshaped_in_rows,0,2);
% The 2nd argument takes 1 for normalization by N
%                        0 for normalization by N-1
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

function xnorm = min_max_norm(x)
minx = min(min(x));
maxx = max(max(x));
xnorm = (x-minx)/(maxx-minx+1e-12);
end