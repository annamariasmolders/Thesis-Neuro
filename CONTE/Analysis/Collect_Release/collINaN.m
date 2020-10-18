function INaNout = collINaN(INaN,INaPN,INaNMDA,IPN)
% Function to collect Na-currents in neuron and make it global
global INaNg
INaNout = (INaN + INaPN + INaNMDA + 3*IPN);
INaNg = INaNout;