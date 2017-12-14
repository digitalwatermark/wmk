
% Prototype:
% function y = walsh_gen(N, index)

function y = walsh_gen(N, index)
n = log2(N);
if ceil(n)~=n
    error('N must be integer power of 2');
end

if max(index)>N || min(index)<1
    error('Index must be in the range [1, N]');
end

G = dec2bin(0:N-1, n)-'0';
G = G.';           

index = dec2bin(index-1, n)-'0';

y = 1-2*mod(index*G, 2);
y = y.';

