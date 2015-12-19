% script for ROC spike analysis - all pooled
% across all days and all electrodes.

% Sidrat TK
% 09Apr14

preRunVals;


for cPos = 1:8
    chooseparams.cPos=cPos;
    SpikeResp={};
    
    for elec = 1:length(ElectrodeAllDays)   % for all unique electrodes
        electrodeNum = ElectrodeAllDays{elec}.electrodeNum;
        Dates = ElectrodeAllDays{elec}.dates;
        for day = 1:length(Dates)           % for all days
            expDate = ElectrodeAllDays{elec}.dates{day};
            protocolName = ElectrodeAllDays{elec}.protocolName{day};
            [spikeData,timeVals,spikeInfo]=loadReqdSpikes(monkeyName,gridType,ECoGFlag,unitID,...
                                            protocolName,folderSourceString,electrodeNum,expDate,chooseparams);
            SpikeResp = [SpikeResp spikeData];
            SpikeRespBL = getSpikeCounts(SpikeResp,timeBL);
            SpikeRespST = getSpikeCounts(SpikeResp,timeST);
        end
    end
    [H(:,cPos),timex]=psthplot(SpikeResp,1,[-0.5 0.5],4);
    [H_bl(:,cPos),H_st(:,cPos),spkcnt(:,cPos)]= getRespDist(SpikeRespBL,SpikeRespST,0);
    [TP(:,cPos),FA(:,cPos)] = getROC(SpikeRespBL,SpikeRespST,spkcnt(:,cPos));
    AUCspall(:,cPos)= abs(trapz(FA(:,cPos),TP(:,cPos)));
end
figure; colj=jet(10);
for cPos=1:8
    subplot(2,2,1);
    plot(FA(:,cPos),TP(:,cPos),'Color',colj(cPos+1,:),'LineWidth',2);
    hold on;
    subplot(2,2,2);
    plot(timex,H(:,cPos),'Color',colj(cPos+1,:));
    hold on; ylim([0 100])
end
