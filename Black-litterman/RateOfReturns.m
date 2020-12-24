function [MeanReturn, VarReturn, ReturnMat] = RateOfReturns(data)
%RATEOFRETURNS 此处显示有关此函数的摘要
%   此处显示详细说明
L = length(data);
% Dataseq = ones(1,L);
% ReturnMat = zeros(1,L*(L+1)/2-L);
% pointer = 1;
% for j = 1:L
%     loadingdata = (data(j)*Dataseq - data)/data(j);
%     loadingdata = loadingdata((j+1):end);
%     len = length(loadingdata);
%     ReturnMat(pointer:(pointer+len-1)) = loadingdata;
%     pointer = pointer+len;
% end

ReturnMat = zeros(1,L-1);
for j = 1:L-1
    ReturnMat(j) = data(j+1)-data(j);
end

MeanReturn = mean(ReturnMat);
VarReturn = var(ReturnMat);
end
