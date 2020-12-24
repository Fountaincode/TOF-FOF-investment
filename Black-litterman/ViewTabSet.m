function [ViewTable] = ViewTabSet(AssetList,NumOfViews)
%VIEWTAB 此处显示有关此函数的摘要
%   此处显示详细说明

if ~isvarname(AssetList)
    AssetList = char(AssetList);
    len = size(AssetList,1);
    loc = find(AssetList(1,:)=='.');
    AssetList(:,loc) = [];
end
   
len = size(AssetList,1);
% Convert into string form to forming the naming rule of the table
% variable
AssetList = string(AssetList)';
P = zeros(NumOfViews,len);
q = zeros(NumOfViews,1);
Omega = zeros(NumOfViews);
ViewTable = array2table([P q diag(Omega)], 'VariableNames', ...
    [AssetList "View_Return" "View_Uncertainty"]) ;
end

