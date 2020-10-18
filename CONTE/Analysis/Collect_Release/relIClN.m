function IClNout = relIClN(t)
% Function to release the K-current in the astrocyte (this is necessary to
% acces the global value)
global IClNg
IClNout = IClNg;