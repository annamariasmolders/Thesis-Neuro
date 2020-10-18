% SINGLE NEURON: NEUROMODULATION
% CONDUCTANCE-BASED MODEL EXTENDED WITH ION CONCENTRATION DYNAMICS
% Varying kbath function to induce CSD

function out = kbathVar(t)
% Create kbath insult that caused 3 episodes of depolarization
out=((12*t/60000)+13).*double(t<=60000) + ((-12*t/10000)+97).*double(t>60000 & t<=70000) + 13.*double(t>70000);
end