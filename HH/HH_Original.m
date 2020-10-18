% IMPLEMENTATION OF ONE NEURON, BASED ON THE ORIGINAL HODGIN-HUXLEY PAPER
close all;
eqns={
  % Conductances [m.mho/cm^2]
  'gNa=120; gK=36; gL=0.3;'
  % Reversal potentials [mV]
  'ENa=-115; EK=12; EL=-10.613;'
  % Membrane capacitance [microF/cm^2]
  'Cm=1'
  % Sodium current
  'INa(v,m,h) = gNa.*m.^3.*h.*(v-ENa)' 
  % Potassium current
  'IK(v,n) = gK.*n.^4.*(v-EK)' 
  % Leak current
  'IL(v) = gL.*(v-EL)'
  % Externally applied current
  'I = -5;'
  % Initial voltage
  'V0=0'
  % System of (differential) equations
  'dv/dt = (I-INa(v,m,h)-IK(v,n)-IL(v))/Cm;'
  'v(0) = V0;' % Initial membrane voltage
  
  'dn/dt = aN(v).*(1-n)-bN(v).*n;' 
  'n(0) = aN(V0)./(aN(V0)+bN(V0));'
  
  'dm/dt = aM(v).*(1-m)-bM(v).*m;' 
  'm(0) = aM(V0)./(aM(V0)+bM(V0));'
  
  'dh/dt = aH(v).*(1-h)-bH(v).*h;'
  'h(0) = aH(V0)./(aH(V0)+bH(V0));'
  
  'aN(v) = 0.01*(v+10)./(exp((v+10)/10) - 1)'
  'bN(v) = .125*exp(v/80)'
  'aM(v) = 0.1*(v+25)./(exp((v+25)/10) - 1)'
  'bM(v) = 4*exp(v/18)'
  'aH(v) = .07*exp(v/20)'
  'bH(v) = 1./(1+exp((v+30)/10))' 
  'monitor functions'
};
data = dsSimulate(eqns);

% PLOT MEMBRANE POTENTIAL
figure;
plot(data.time,-data.(data.labels{1}))
xlabel('time [ms]','fontsize',14);
title('Membrane potential as a function of time','fontsize',14)
