function IKNout = relIKN(t)
% Function to release the K-current in the neuron (this is necessary to
% acces the global value)
global IKNg
IKNout = IKNg;