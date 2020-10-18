function INaNout = relINaN(t)
% Function to release the Na-current in the neuron (this is necessary to
% acces the global value)
global INaNg
INaNout = INaNg;