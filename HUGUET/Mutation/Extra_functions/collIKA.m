function IKAout = collIKA(IKA,IPA)
% function to collect total K-current in astrocytes and make it global
global IKAg
IKAout = (IKA-2*IPA);
IKAg = IKAout;