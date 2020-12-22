function [D] = bondduration(P,C,F,y,k,m,N)
%The price of the bond is the discount of the cash flow.
% Inputs:
% P:    Market price of the bond.
% C:    Interest.
% F:    Final value of the bond.
% y:    Yield to maturity.
% k:    Number of interest payment per year.
% N:    Total number of interest payment.
%
% Outputs:
% D:    Duration of the bond.

% Created in 2020-12-21 by XuSUN.

D1 = (m/k*C(:,end))/((1+y/k)^m);

D2 = zeros(1,N);

for n = 1:N
    D2(:,n) = ((m+n)/k)*C(:,n)./((1+y/k)^(n+m));
    D2 = sum(D2);
end

D3 = (m+N/k)*F/((1+y/k)^(N+m));
D = (D1+D2+D3)/P;

end

