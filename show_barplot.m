%indN = indices_normal_mean;
%indM = indices_mmOSA_mean;
%indS = indices_sOSA_mean;

label = categorical({'N','M','S'});
label = reordercats(label,{'N','M','S'});
bar_ratio = [mean(indN(3,:)),mean(indM(3,:)),mean(indS(3,:))];
[errlow_ratio,errhigh_ratio] = errboundary(indN(3,:),indM(3,:),indS(3,:));
bar_fApEn = [mean(indN(4,:)),mean(indM(4,:)),mean(indS(4,:))];
[errlow_fApEn,errhigh_fApEn] = errboundary(indN(4,:),indM(4,:),indS(4,:));
bar_VDfApEn = [mean(indN(5,:)),mean(indM(5,:)),mean(indS(5,:))];
[errlow_VDfApEn,errhigh_VDfApEn] = errboundary(indN(5,:),indM(5,:),indS(5,:));

bar_all = [bar_ratio; bar_fApEn; bar_VDfApEn]';

ax1 = subplot(1,3,1);
b1 = bar(label,bar_ratio,'EdgeColor','none');
b1.FaceColor = 'flat';
b1.CData(1,:) = [0 0.4470 0.7410];
b1.CData(2,:) = [0.9290 0.6940 0.1250];
b1.CData(3,:) = [0.8500 0.3250 0.0980];
ylabel('LF/HF')
hold on
er = errorbar(label,bar_ratio,errlow_ratio,errhigh_ratio);    
er.Color = [0 0 0];                            
er.LineStyle = 'none'; 
set(ax1,'FontName','Latin Modern Math','Fontsize',12)

ax2 = subplot(1,3,2);
b2 = bar(label,bar_fApEn,'EdgeColor','none');
b2.FaceColor = 'flat';
b2.CData(1,:) = [0 0.4470 0.7410];
b2.CData(2,:) = [0.9290 0.6940 0.1250];
b2.CData(3,:) = [0.8500 0.3250 0.0980];
ylabel('Fuzzy Approx Entropy')
hold on
er = errorbar(label,bar_fApEn,errlow_fApEn,errhigh_fApEn);    
er.Color = [0 0 0];                            
er.LineStyle = 'none'; 
set(ax2,'FontName','Latin Modern Math','Fontsize',12)

ax3 = subplot(1,3,3);
b3 = bar(label,bar_VDfApEn,'EdgeColor','none');
b3.FaceColor = 'flat';
b3.CData(1,:) = [0 0.4470 0.7410];
b3.CData(2,:) = [0.9290 0.6940 0.1250];
b3.CData(3,:) = [0.8500 0.3250 0.0980];
ylabel('VD Fuzzy Approx Entropy')
hold on
er = errorbar(label,bar_VDfApEn,errlow_VDfApEn,errhigh_VDfApEn);    
er.Color = [0 0 0];                            
er.LineStyle = 'none'; 
set(ax3,'FontName','Latin Modern Math','Fontsize',12)

function [errlow,errhigh] = errboundary(indNr,indMr,indSr)
temp_mean = [mean(indNr),mean(indMr),mean(indSr)];
temp_std = [std(indNr),std(indMr),std(indSr)];
errlow = sigmoid(temp_mean - temp_std) - 0.5;
errhigh = sigmoid(temp_mean + temp_std) - 0.5;
end

function y = sigmoid(z)
y = 1./(1+exp(-z));
end