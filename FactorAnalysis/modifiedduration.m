function [MD] = modifiedduration(D,y,k)
%The price of the bond is the discount of the cash flow.
% Inputs:
% D:    Duration of the bond.
% y:    Yield to maturity.
% k:    Number of interest payment per year.
%
% Outputs:
% MD:    Modified duration of the bond.

% Created in 2020-12-21 by XuSUN.
MD = D/(1+y/k);
end

