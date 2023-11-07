function plotFeatures(featVec,selChan,nFreq)
% function plotFeatureSpace(vec,ecog,nFreq)
%
% INPUT:
% featVec   - feature vector
% selChan   - selected channels (ecog.selectedChannels)
% nFreq     - number og frqeuencies in featVec
%
% Purpose:
% Plot feature space wit channels x frequencies
%

featMatr = reshape(featVec,length(selChan),nFreq);

plotMatr = zeros(40,nFreq);
plotMatr(selChan,:) = featMatr;

figure
imagesc(plotMatr)
xlabel('Frequencies','Fontsize',18)
set(gca,'xTick',[10 20 30 40 50 60 70 80],'xTickLabel',{'20' '40' '60' '80' '100' '120' '140' '160'});
ylabel('Channels/Electrodes','Fontsize',18)
colorbar