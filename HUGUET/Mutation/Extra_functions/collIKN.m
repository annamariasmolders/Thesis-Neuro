function IKNout = collIKN(IKN,IPN)
% Function to collect K-currents in neuron and make it global
global IKNg
IKNout = (IKN-2*IPN);
IKNg = IKNout;