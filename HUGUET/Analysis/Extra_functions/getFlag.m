function out = getFlag( t,X )
%GETFLAG Summary of this function goes here
%   Detailed explanation goes here
global flag
flag=double(flag*(1-any(X > [-40*ones(1,23) Inf*ones(1,4) -40*ones(1,23)]))|t==0);
out=flag;
end

