function INaNout = collINaN(INaN,INaPN,IPN)
% Function to collect Na-currents in neuron and make it global
global INaNg
INaNout = (INaN + INaPN + 3*IPN);
INaNg = INaNout;