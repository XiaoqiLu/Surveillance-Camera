function [A, E] = SparseLowrankDecomposition(D, lambda, tol)

if nargin < 3
    tol = 1e-2;
end

if nargin < 2
    m = size(D, 1);
    lambda = 1 / sqrt(m);
end

%% initialization
A = D;
E = D * 0;
Y = D; % Lagrange multiplier
mu = 1 / norm(D); % increasing constant
rho = 1.25; % increasing ratio
err = tol + 1;
nIter = 0;

while err > tol
    Aprev = A;
    Eprev = E;
    mu = mu * rho;
    [U, S, V] = svd(D + Y / mu - E, 'econ');
    A = U * wthresh(S,'s',1 / mu) * V';
    E = wthresh(D + Y / mu - A,'s',lambda / mu);
    Y = Y + mu * (D - A - E);
    err = norm(A - Aprev, 'fro') + norm(E - Eprev, 'fro');
    nIter = nIter + 1;
    disp(['Iteration:', num2str(nIter), ' err:', num2str(err)]);
end


end