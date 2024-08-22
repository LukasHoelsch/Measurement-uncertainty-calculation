function fig = AdjustSubplot(fig,Distance,PosConfiguration,vPlotDist)

NoPosConfigure = 0;
if sum(PosConfiguration == 0)
    NoPosConfigure = 1;
    PosConfiguration(4) = 0.95;
    PosConfiguration(2) = 0.08;
end

NPlots = length(fig.sp);

HandleStruct = zeros(NPlots,1);
PosArray = zeros(NPlots,4);
h = gcf;
Exponent = zeros(NPlots,1);
for i = 1 : NPlots
    HandleStruct(i) = fig.sp(i);
end
for i = 1 : NPlots
%     lim = get(HandleStruct(i),'ylim');
%     ytick = get(HandleStruct(i),'ytick');
%     dif = lim(2) - lim(1);
%     maxP = max(CA{i}.Data);
%     minP = min(CA{i}.Data);
%     difMin = minP - lim(1);
%     difMax = lim(2) - maxP;
    
    deltay = ((PosConfiguration(4) - PosConfiguration(2)) - Distance) / sum(vPlotDist) * vPlotDist;
    
%     if abs(difMin/dif) < 0.05
%         lim = [lim(1)+(ytick(1) - ytick(2)) lim(2)];
%     end
%     if abs(difMax/dif) < 0.05
%         lim = [lim(1) (lim(2) + ytick(length(ytick))- ytick(length(ytick)-1))];
%     end
%     set(HandleStruct(i),'ylim',lim);
    PosArray(i,:) = get(HandleStruct(i),'position');
    if i == 1
%         deltay = 0.8/NPlots;
%         deltay = 0.8 / sum(vPlotDist) * vPlotDist(i);
        PosArray(1,2) = PosConfiguration(4) - deltay(i);
        PosArray(1,4) = deltay(i);
        if NoPosConfigure == 0
            PosArray(i,1) = PosConfiguration(1);
            PosArray(i,3) = PosConfiguration(3) - PosConfiguration(1);
        end
        set(HandleStruct(i),'position',PosArray(i,:));
    end
    if i > 1
%         deltay = 0.8 / sum(vPlotDist) * vPlotDist(i);
%         PosArray(i,2) = PosConfiguration(4) - sum(deltay(1:(i))) - Distance / (NPlots-1) * (i-1);% - Distance / NPlots;
        PosArray(i,4) = deltay(i);
        PosArray(i,2) = PosArray(i-1,2) - PosArray(i,4) - Distance / (NPlots-1);
        if NoPosConfigure == 0
            PosArray(i,1) = PosConfiguration(1);
            PosArray(i,3) = PosConfiguration(3) - PosConfiguration(1);
        end
        set(HandleStruct(i),'position',PosArray(i,:));
        temp = get(HandleStruct(i),'ytick');
%         set(HandleStruct(i),'ytick',temp(1:length(temp)-1));
    end
    if i < NPlots
        set(HandleStruct(i),'xticklabel',[])
    end
end
fig.sp=HandleStruct;
end

