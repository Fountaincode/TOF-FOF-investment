function [wtsBL,wts] = BlackLittermanPortfolioOpt(assetRetns,benchRetn,ViewTable)
% The Black-Litterman model is an asset allocation approach that allows
% investment analysts to incorporate subjective views (based on investment
% analyst estimates) into market equilibrium returns. By blending analyst
% views and equilibrium returns instead of relying only on historical asset
% returns, the Black-Litterman model provides a systematic way to estimate
% the mean and covariance of asset returns.

% Inputs:
% assetRetns:   Return of the asset.
% benchRetn:    Return of the benchmark asset.
% ViewTable:    subjective views(based on investment analyst estimates.
%
% Outputs:
% wtsBL:    Weights of the assets according to Blacklitterman model.
% wts:      Weights of the assets according to the Mean Variance.
% Created in 2019-10-12 by XuSUN.

%% Determine P q Omega from the ViewTable
[m,n] = size(ViewTable);  
v = m;                              % Number of the views   
numAssets = n-2;
% Splite the ViewTable, Convert the data into 'double' class
ViewTable = table2array(ViewTable);
P = ViewTable(:,1:n-2);
q = ViewTable(:,n-1);
Omega =   diag(ViewTable(:,n-1));
if ViewTable(:,n-1)==0
    Omega =   eye(v);
end

%% Determine the covcariance from the historical assets returns
% assetRetns = assetRetns';
Sigma = cov(assetRetns);

%% Determine the uncertainty C
tau = 1/size(assetRetns, 1);
C = tau*Sigma;

%% Market implied equilibrium return (see local function below)
[wtsMarket, PI] = findMarketPortfolioAndImpliedReturn(assetRetns, benchRetn);

%% Compute the estimated mean return and covariance
mu_bl = (P'*(Omega\P) + inv(C)) \ ( C\PI + P'*(Omega\q));
cov_mu = inv(P'*(Omega\P) + inv(C));

%% Portfolio optimization
portBL = Portfolio('NumAssets', numAssets, 'lb', 0, ...
    'budget',1, 'Name', 'Mean Variance with Black-Litterman');

% Set the asset moment properties, given the mean and covariance of asset
% returns in the variables m and C.
portBL = setAssetMoments(portBL, mu_bl, Sigma + cov_mu);

port = Portfolio('NumAssets', numAssets, 'lb', 0, 'budget', 1, 'Name', 'Mean Variance');
port = setAssetMoments(port, mean(assetRetns), Sigma);

flag1 = mean(assetRetns);
flag1 = sum(flag>0)>0;
if flag1>0
    wts = estimateMaxSharpeRatio(port);
else
    wts = zeros(numAssets,1);
end
% Considering that the mean returm may contains the negtive value ,which
% indicates all the investment should be canceled, the precaution is
% achieved by the following statement.
flag2 = sum(mu_bl>0)>0;

if flag2>0
    wtsBL = estimateMaxSharpeRatio(portBL);
else
    wtsBL = zeros(numAssets,1);
end
end

% function [wtsMarket, PI] = findMarketPortfolioAndImpliedReturn(assetRetn, benchRetn)
% % Find the market portfolio that tracks the benchmark and its corresponding
% implied expected return.
% Sigma = cov(assetRetn);
% numAssets = size(assetRetn,2);
% LB = zeros(1,numAssets);
% Aeq = ones(1,numAssets);
% Beq = 1;
% opts = optimoptions('lsqlin','Algorithm','interior-point', 'Display',"off");
% wtsMarket = lsqlin(assetRetn, benchRetn, [], [], Aeq, Beq, LB, [], [], opts);
% shpr = mean(benchRetn)/std(benchRetn);
% delta = shpr/sqrt(wtsMarket'*Sigma*wtsMarket); 
% PI = delta*Sigma*wtsMarket;
% end