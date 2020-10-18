function IKNout = collIKN(IKN,IPN,IKNMDA)
% Function to collect K-currents in neuron and make it global
global IKNg
IKNout = (IKN+IKNMDA-2*IPN);
IKNg = IKNout;