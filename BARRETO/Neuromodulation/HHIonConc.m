% SINGLE NEURON: NEUROMODULATION
% CONDUCTANCE-BASED MODEL EXTENDED WITH ION CONCENTRATION DYNAMICS
% Main file

clear all;
close all
clc

% With synaptic input: Add gsyn as argument is esi function
eqns = 'dv/dt = (esi(t,pulsestart,pulseduration,amp,per,dc)-@current)/C; C=1; v(0)=-63.2823; {Na,K,Cl,IonConc};' ;
P='pop1';

% Values for parametersweep
vary={ 
    {P,'pulsestart',25000;P,'pulseduration',45000;P,'amp',-1;P,'per',10;P,'dc',0.5}
%    {P,'pulsestart',0;P,'pulseduration',100000;P,'amp',-1;P,'per',1;P,'dc',1;P,'gsyn',0.43}
};
numSweep=size(vary,1);

Tend=100000;
dt=1;
data=dsSimulate(eqns,'tspan',[0 Tend],'vary',vary,'parallel_flag',1);

% Plotting
for i=1:numSweep
    figure;
    plot(data(i).time/10^3,data(i).pop1_v)
    xlabel('time [s]','fontsize',16);
    ylabel('[mV]','fontsize',16);
% Access parameters from vary, for each parameter set:
% (e.g. To use in titles/file names)
%     pulsestart=vary{i,1}{1,3};
%     duration=vary{i,1}{2,3};
%     amp=vary{i,1}{3,3};
%     per=vary{i,1}{4,3};
%     dc=vary{i,1}{5,3};
%     gsyn=vary{i,1}{6,3};

end

