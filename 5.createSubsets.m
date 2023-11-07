function [subSet1 subSet2] = createSubsets(dat,epoch,ratio)
% function [subSet1 subSet2] = createSubset(ecog,epoch,ratio)
%
% INPUT:
% ecog      - ecog struct with periodogram entry
% epoch     - epoch struct with label information
% ratio     - amount of data used for subsets ([0 1]; default: 0.2 ~ 20%)
%
% OUTPUT:
% subSet1   - subset of class 1
% subSet2   - subset of class 2
%
% Purpose:
% Creates random subsets for feature selction
%

% Check for input parameter and set ratio to default value if neccessary
if nargin < 3
    ratio = 0.2;
end

% Get class labels
class1 = find(epoch.label==20);
class2 = find(epoch.label==21);

nbClass1 = length(class1);
nbClass2 = length(class2);

% Get random subsets
subSet1_Idx = randperm(nbClass1,round(nbClass1*ratio));
subSet2_Idx = randperm(nbClass2,round(nbClass2*ratio));

subSet1 = dat(class1(subSet1_Idx),:,:);
subSet2 = dat(class2(subSet2_Idx),:,:);