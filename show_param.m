%% Parameter Selection
TAU = 2:10;
DELTA = 1:10;
res_delta = zeros(3,length(DELTA));
res_tau = zeros(3,length(TAU));
norm = normal_per_subj(1:5);
mmOSA = mmOSA_per_subj(1:5);
sOSA = sOSA_per_subj(1:5);
regrouped = {norm,mmOSA,sOSA};
colorlist = {[0 0.4470 0.7410],[0.9290 0.6940 0.1250],[0.8500 0.3250 0.0980]};

for pp = 1:3
    res_delta(pp,:) = get_result(regrouped{pp},DELTA);
    res_tau(pp,:) = get_result(regrouped{pp},TAU);
end

%% Visualization
figure(1)
for hh = 1:3
    plot(DELTA,res_delta(hh,:),'o-','linewidth',1.2,'color',colorlist{hh})
    hold on
end
legend('normal','mmOSA','sOSA','interpreter','latex','fontsize',12)
xlabel('Delay $\delta$','interpreter','latex','fontsize',12)
ylabel('VDfApEn','interpreter','latex','fontsize',12)


figure(2)
for hh = 1:3
    plot(TAU,res_tau(hh,:),'o-','linewidth',1.2,'color',colorlist{hh})
    hold on
end
legend('normal','mmOSA','sOSA','interpreter','latex','fontsize',12)
xlabel('Scale $\tau$','interpreter','latex','fontsize',12)
ylabel('VDfApEn','interpreter','latex','fontsize',12)

function res_arr = get_result(grp_cell,PARAM)
num_res = length(PARAM);
num_subj = length(grp_cell);
num_arr = length(grp_cell{1});

other_param = 3;  % delta = 3;

temp_en_per_subj = zeros(1,num_subj);
temp_en_per_arr = zeros(1,num_arr);
res_arr = zeros(1,num_res);

for ii = 1:num_res
    for jj = 1:num_subj
        for kk = 1:num_arr
            temp_en_per_arr(kk) = MyVDfApEn(grp_cell{jj}{kk},PARAM(ii),other_param);
        end
        temp_en_per_subj(jj) = mean(temp_en_per_arr);
    end
    res_arr(ii) = mean(temp_en_per_subj);
end
end
