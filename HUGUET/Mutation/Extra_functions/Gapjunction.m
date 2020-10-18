function current=Gapjunction(V,C,N,netcon,sigma)

R=8.31*10^3; %[mJ/molK]
T=310; %[K]
F=96485; %[C/mol]


phijk =@(X) F/(R*T)*(repmat(X,N,1)-repmat(X',1,N));
dC =@(C) repmat(C,N,1)-repmat(C',1,N);


% we sum over rows ==> all diferent pre values must be subdevided over the rows ==> transpose pre 
gap_fun=@(X,Ci) phijk(X).*(repmat(Ci',1,N).*exp(-phijk(X))-repmat(Ci,N,1))./(exp(-phijk(X))-1*double(phijk(V)~=0));
% if sigma==0
%     current = zeros(1,N);
% else
    current = sigma*F*sum(netcon.*(gap_fun(V,C)+double((phijk(V)==0)).*dC(C)),1);
% end
end