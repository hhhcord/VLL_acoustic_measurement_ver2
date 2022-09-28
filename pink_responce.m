clear;clc;

[file,path] = uigetfile('*.wav');
if isequal(file,0)
    disp('User selected Cancel');
else
    disp(['User selected ', fullfile(path,file)]);
end

fs = 44.1e3;
samples = [1,5*fs-1];
clear pn fs;
[pn,fs] = audioread(file,samples);

flims = [20 20e3];
bpo = 3;
opts = {'FrequencyLimits',flims,'BandsPerOctave',bpo};

poctave(pn,fs,opts{:});
savefig('BandsPerOctave.fig');
close all

fig = open('BandsPerOctave.fig');
ax = fig.Children;
x = ax.Children.XData;
y = ax.Children.YData;

xHz = [20 25 31.5 40 50 63 80 100 125 160 200 250 315 400 500 630 800 1000 1250 1600 2000 2500 3150 4000 5000 6300 8000 10000 12500 16000 20000];

[pks,locs] = findpeaks(y);
plot(y);
hold on;
plot(locs,y(locs),'ro');
hold off;
savefig('peaks.fig');
close all

maxpks = maxk(pks,3);
for index = 1:numel(locs)
    if pks(index)==maxpks(1)
        a = index;
    elseif pks(index)==maxpks(2)
        b = index;
    elseif pks(index)==maxpks(3)
        c = index;
    end
end

nbins = 15;
histogram(y,nbins);
savefig('histogram.fig');
close all

[N,edges] = histcounts(y,nbins);
[NM,NI] = max(N);
modeN = (edges(NI)+edges(NI+1))/2;

No = [1;2;3];
Hz = {xHz(locs(a));xHz(locs(b));xHz(locs(c))};
dB = [-(pks(a)-modeN);-(pks(b)-modeN);-(pks(c)-modeN)];
mode_dB = [modeN;0;0];
T = table(No,Hz,dB,mode_dB)
writetable(T,'result_data.txt');
type result_data.txt