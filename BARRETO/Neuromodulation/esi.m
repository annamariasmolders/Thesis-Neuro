% SINGLE NEURON: NEUROMODULATION
% CONDUCTANCE-BASED MODEL EXTENDED WITH ION CONCENTRATION DYNAMICS
% Function to simulate current applied at neuronal level


% ESI ONLY
function out = esi(t,pulsestart,pulseduration,amp,per,dc) 
    out=(mod(t-pulsestart,per)<per*dc).*amp.*double(t>pulsestart & t<= (pulsestart+pulseduration)); 

% ESI + SYNAPTIC INUPT
% function out = esi(t,pulsestart,pulseduration,amp,per,dc,gsyn)
%     syn=((70)*gsyn*((t-42000)/5).*exp(-(t-42000)/5).*double(t>42000));
%     syn(isnan(syn))=0;
%     out=(mod(t-pulsestart,per)<per*dc).*amp.*double(t>pulsestart & t<= (pulsestart+pulseduration)) + syn;

end