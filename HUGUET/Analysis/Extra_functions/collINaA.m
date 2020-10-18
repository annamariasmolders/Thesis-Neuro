function INaAout = collINaA(INaA,IPA)
% Function to collect Na-currents in Astrocyte and make it global 
global INaAg
INaAout = (INaA+3*IPA);
INaAg = INaAout;