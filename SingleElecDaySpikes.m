% script to run on all 8 contrasts, one electrode, one day.
% gives the trends in area under curve(AUC) of reciever operating
% characteristics (ROC). the 2 distributions are obtained from the
% baseline, and from response epochs throughout the project
% this is spike count analysis.

% Sidrat TK - 09Apr14.
%---------------------------------------------------------------------
% options for loading data
monkeyName = 'abu'; gridType='Microelectrode'; ECoGFlag=0; protocolName ='SRC_001'; 
getSpikeElectrodesFlag=1; combineUniqueElectrodeData=0; unitID=1;spikeCutoff=25;snrCutoff=2;
[allGoodElecs,~,~,~,goodDays]=getGoodElectrodes(monkeyName,gridType,combineUniqueElectrodeData,getSpikeElectrodesFlag,unitID,spikeCutoff,snrCutoff,ECoGFlag);
[expDates,~,~,folderSourceString] = dataInformation(monkeyName,gridType,ECoGFlag);
%---------------------------------------------------------------------
num =1;
electrodeNum = allGoodElecs(num);                    % choose the "electrodeNum" electrode (1st,2nd 3rd... )
expDate = expDates{goodDays(num)};                   % expDate. choose day corresp to elec number.
chooseparams.cPos=8; chooseparams.aPos=1;                  % choose contrast, cPos, attend location, aPos
chooseparams.tPos=1; chooseparams.ePos=1; chooseparams.typePos=1;       % parameter values

hSpPsthPlot = getPlotHandles(1,8,[0.05 0.75 0.9 0.2], 0.01,0.01);
hSpDistPlot = getPlotHandles(1,8,[0.05 0.4 0.9 0.25], 0.01,0.01);
hSpRocPlot = getPlotHandles(1,8,[0.05 0.1 0.9 0.25], 0.01,0.01);

% ----- load spike data, info and timeVals for this electrode, this day
timeBL = [-0.45 -0.25]; timeST = [0.25 0.45];
for cPos = 1:8
    chooseparams.cPos=cPos;
    [spikeData,timeVals,spikeInfo]=loadReqdSpikes(monkeyName,gridType,ECoGFlag,unitID,protocolName,folderSourceString,electrodeNum,expDate,chooseparams);
    [H,timex]=psthplot(spikeData,1,[-0.5 0.5],4);
    plot(hSpPsthPlot(1,cPos),timex,H,'r'); ylim(hSpPsthPlot(1,cPos),[-1 50]);
    spikeCntBL = getSpikeCounts(spikeData,timeBL);
    spikeCntST = getSpikeCounts(spikeData,timeST);
    [H_bl(:,cPos),H_st(:,cPos),spkcnt(:,cPos)]= getRespDist(spikeCntBL,spikeCntST,0);
    [TP(:,cPos),FA(:,cPos)] = getROC(spikeCntBL,spikeCntST,spkcnt(:,cPos));
    AUCsp(:,cPos)= abs(trapz(FA(:,cPos),TP(:,cPos)));
    plot(hSpDistPlot(1,cPos),spkcnt(:,cPos),H_bl(:,cPos)); hold(hSpDistPlot(1,cPos),'on');
    plot(hSpDistPlot(1,cPos),spkcnt(:,cPos),H_st(:,cPos),'r'); 
    plot(hSpRocPlot(1,cPos),FA(:,cPos),TP(:,cPos),'LineWidth',2);
end
    
