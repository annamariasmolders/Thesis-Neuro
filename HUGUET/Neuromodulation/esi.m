% NEURON-ASTROCYTE NETWORK, INCLUDING GAP JUNCTIONS: Neuromodulation
% Function to simulate current applied at neuronal level

function out = esi(t,pulsestart,pulseduration,amp,per,dc)
out=(mod(t-pulsestart,per)<per*dc).*amp.*double(t>pulsestart & t<(pulsestart+pulseduration));
end

