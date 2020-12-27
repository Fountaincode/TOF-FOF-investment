function [w] = RiskParity(ret)
%Risk parity model base on the SQP algorithm
% Input:
% ret:   Return of the assets, an n-by-m matrix;
% Output:
% W£º    Weights of the portfolio.

% Created in 2020-12-27 by XuSUN.

% Number of input assets
n = size(ret,2);

% Covariance of the return
cov_ret = cov(ret);

% Set the options of the optimized function;
options = optimoptions(@fmincon,'Algorithm','sqp','MaxIterations',1e4);

% Set the initial calculation point of the optimized function
x0 = ones(n,1).*(1/n);

% Conditions/constraints for Nonlinear programming solver
% A*x ¡Ü b,If no inequalities exist, set A = [] and b = [].
A = [];
b = [];

% set of lower and upper bounds on the design variables in x, so that the
% solution is always in the range lb ¡Ü x ¡Ü ub. If no equalities exist, set
% Aeq = [] and beq = []. 
Aeq = [1,1,1,1];
beq = 1;

% If x(i) is unbounded below, set lb(i) = -Inf, and if x(i) is unbounded
% above, set ub(i) = Inf.
lb = [0; 0; 0; 0];
ub = [1; 1; 1; 1];

w = fmincon(@(x) TRC(cov_ret,x,n) ,x0,A,b,Aeq,beq,lb,ub,[],options);

end

function y = TRC(cov , x, n)
%Nonlinear programming solver function: the total risk contribution
% find x = argmin(f(x)), with sum(x)=1,and 0<=x<=1;
% Input:
% cov:  Covariance of the return
% x:    weights
% Output:
% y:    f(x)

TRC_term = x.*(cov * x)./n;

len = length(TRC_term);

TRC = zeros(len,len);
for i = 1:len
    for j = 1:len
        TRC(i,j) = (TRC_term(i)-TRC_term(j))^2;
    end
end
y = sum(sum(TRC));
end
