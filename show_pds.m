n_subj = 30;
%a = [3,6,24];
a = [3 8 24];
samps = {normal_per_subj{a(1)}{n_subj},...
    mmOSA_per_subj{a(2)}{n_subj},...
    sOSA_per_subj{a(3)}{n_subj}};
fs = 2;
tltstr = {'normal subject',...
    'mild-moderate OSA subject',...
    'severe OSA subject'};

for ii = 1:3
    signal = samps{ii};
    signal = N_points_interp(signal,2*length(signal),'linear');
    subplot(3,1,ii)
    pburg(signal,6,1024,fs)
    xlabel('Frequency (Hz)','interpreter','latex','fontsize',12)
    ylabel('Power (dB)','interpreter','latex','fontsize',12)
    title(tltstr{ii},'interpreter','latex','fontsize',14)
end
sgtitle('Power spectral density of RR segments',...
    'interpreter','latex','fontsize',16)
