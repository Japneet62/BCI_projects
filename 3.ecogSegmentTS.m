function [ecog]=ecogSegmentTS(ecog,triggerIdx,preDurSamp,postDurSamp)
% [ecog,bas]=ecogSegmentTS(ecog,triggerIdx,preDurSamp,postDurSamp) Createdatasegments around the indices in triggerIdx
%
% INPUT:
% ecog:           An ecog structure.
%               LEGACY SUPPORT: can be a matrix of data time series with time
%               along columns. Thus, values in triggerIdx are assumed to
%               refer to indices along the first dimension of tS.
% triggerIdx:   A vector of indices marking the segment start in the first
%               dimension of tS.
% preDurSamp:   The number of pre-trigger samples in the segment extracted.
% postDurSamp:  The number of pre-trigger samples in the segment extracted.
%
% OUTPUT:
% ecog:         An ecog structure with data segments in the dat field
%               An ND-array containing the segments with size
%               length(1:preDurSamp+postDurSamp) X size(tS,2) X length(triggerIdx)
%               correponding to segment length X number of channels X
%               number of segments. The baseline (mean(preDurSamp)) was
%               subtracted from each segment
% bas:          LEGACY: preDurSample is assumed
%               to reflect a baseline and the mena of it subtracted from the whole
%               segment. The means are resturned in bas. Size is
%               1 X size(tS,2) X length(triggerIdx).
%               TO BE DEPRECATED. USE ecogRemoveBaseline INSTEAD
% USAGE:
% [ecog, bas]=ecogSegmentTS(ecog,fingerMovOnsetIdx,200/sampDurMs,1500/sampDurMs);

% 081223 JR wrote it
% 110429 JR included support for ecog structure

if isstruct(ecog)
    seg=zeros(size(ecog.data,1),length(1:preDurSamp+postDurSamp),length(triggerIdx));
    for k=1:length(triggerIdx)
        seg(:,:,k)=ecog.data(:,triggerIdx(k)-preDurSamp+1:triggerIdx(k)+postDurSamp);
    end
    ecog.data=seg;
    if isfield(ecog,'refChanTS') && ~isempty(ecog.refChanTS)
        seg=zeros(size(ecog.refChanTS,1),length(1:preDurSamp+postDurSamp),length(triggerIdx));
        for k=1:length(triggerIdx)
            seg(:,:,k)=ecog.refChanTS(:,triggerIdx(k)-preDurSamp+1:triggerIdx(k)+postDurSamp);
        end
        ecog.refChanTS=seg;
    end
    if isfield(ecog,'triggerTS')
        seg=zeros(size(ecog.triggerTS,1),length(1:preDurSamp+postDurSamp),length(triggerIdx));
        for k=1:length(triggerIdx)
            seg(:,:,k)=ecog.triggerTS(:,triggerIdx(k)-preDurSamp+1:triggerIdx(k)+postDurSamp);
        end
        ecog.triggerTS=seg;
    end
    ecog.nSamp=size(seg,2);
    ecog.nBaselineSamp=preDurSamp;
    ecog.timebase=ecog.nBaselineSamp*ecog.sampDur:ecog.sampDur:(postDurSamp-1)*ecog.sampDur;
else %LEGACY SUPPORT
    % reserve space
    seg=zeros(length(1:preDurSamp+postDurSamp),size(ecog,2),length(triggerIdx));
    % get the segments
    for k=1:length(triggerIdx)
        seg(:,:,k)=ecog(triggerIdx(k)-preDurSamp+1:triggerIdx(k)+postDurSamp,:);
    end
    % subtract the baseline
    bas=mean(seg(1:preDurSamp+postDurSamp,:,:),1);
    seg=seg-repmat(bas,[size(seg,1),1,1]);
end
