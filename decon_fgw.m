clear; tic;


filelist = dir('~/data/V100.*RIS*LHZ*SAC');
h = 265;
H = 479;

% filelist = dir('~/data/V100*X9*LHZ*SAC');
% h = 301;
% H = 466;


% for i = 1:numel(filelist)
for i = 4:numel(filelist) % Use this for Ross.  data before this are wierd.
    data = readsac(['~/data/' filelist(i).name]);
    
    t0 = datenum(data.nzyear-1,12,31) + data.nzjday...
        + data.nzhour/24 + data.nzmin/1440 + data.nzsec/86400;

    v{i} = data.trace / 1e9; % Convert to m/s
    T = CalculateStress(v{i},1:numel(v{i}),h,H);
    stress{i} = abs(T);
    
    disp([datestr(t0) ' to ' datestr(t0 + numel(v{i})/86400) ', time: ' num2str(toc)]);

    time{i} = t0 + (1:numel(stress{i}))/86400;


end




s = []; t = s; z =s;
for i = 1:numel(filelist)
    s = [s; stress{i}];
    t = [t time{i}];
    z = [z; v{i}];
end



% Exclude the begining of the campaign on Amery.  People were dancing on
% the seismometers?
% range = find( t>datenum('11-Jan-2007'));
% s = s(range);
% t = t(range);


[v,x]=hist(s/1e3,1e3);



figure(1); 
% subplot(1,2,2);
semilogy(fliplr(x),cumsum(fliplr(v)),'o');
hold on;
% line(2.2*[1 1],ylim,'linesty','--','color',[0.8500    0.3250    0.0980]);
% line(.55*[1 1],ylim,'linesty','--','color',[0.9290    0.6940    0.1250]);
xlabel('Stress, kPa');
% legend('Cumulative time, s','Critical stress, marine ice', 'Critical stress, meteoric ice');


% save('Amery-FlexuralStresses-All.mat','s','t');
% save('Ross-FlexuralStresses-All.mat','s','t');
