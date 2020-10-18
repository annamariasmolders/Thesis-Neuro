function INaAout = relINaA(t)
% Function to release the Na-current in the astrocyte (this is necessary to
% acces the global value)
global INaAg
INaAout = INaAg;