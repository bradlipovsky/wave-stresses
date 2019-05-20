clear; tic;

% filelist = dir('~/data/V100.*RIS*LH2*SAC');
filelist = dir('~/data/V100*X9*LHN*SAC');

Z = 2.07;

s=[];
time  = cell(size(filelist));

for i = 1:numel(filelist)
	data = readsac(['~/data/' filelist(i).name]);
    
    t0 = datenum(data.nzyear-1,12,31) + data.nzjday...
        + data.nzhour/24 + data.nzmin/1440 + data.nzsec/86400;
    
    v = data.trace/1e6; % velocity in mm/s
    s = [s; v*Z];
    time{i} = t0 + (1:numel(v))/86400;
%     plot(time{i},v); hold on;
end

 t = [];
for i = 1:numel(filelist)
    t = [t time{i}];
end

% Exclude the begining of the campaign on Amery.  People were dancing on
% the seismometers?
s = s( t>datenum('11-Jan-2007'));

figure(2);
[v,x]=hist(abs(s),1e3);
semilogy(fliplr(x),cumsum(fliplr(v)),'o'); hold on;
xlabel('Stress, kPa');

% save('Amery-ExtensionalStresses-All.mat','s','t');
% save('Ross-ExtensionalStresses-All.mat','s','t');