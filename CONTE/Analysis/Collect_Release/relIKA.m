function IKAout = relIKA(t)
% Function to release the K-current in the astrocyte (this is necessary to
% acces the global value)
global IKAg
IKAout = IKAg;