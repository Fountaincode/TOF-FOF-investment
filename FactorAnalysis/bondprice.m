function [P] = bondprice(C,F,y,k,m,N)
%The price of the bond is the discount of the cash flow.
% Inputs:
% C:    Interest
% F:    Final value of the bond
% y:    Yield to maturity
% k:    Number of interest payment per year
% N:    Total number of interest payment
%
% Outputs:
% P:    Market price of the bond;
% Created in 2020-12-21 by XuSUN.

P1 = C(:,end)/((1+y/k)^m);

P2 = zeros(1,N);

for n = 1:N
    P2(:,n) = C(:,n)./((1+y/k)^(n+m));
    P2 = sum(P2);
end

P3 = F/((1+y/k)^(N+m));
P = P1+P2+P3;

end

