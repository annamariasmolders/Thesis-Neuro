% SINGLE NEURON
% CONDUCTANCE-BASED MODEL EXTENDED WITH ION CONCENTRATION DYNAMICS
% Main file
clear all;
close all
clc

eqns = {'dv/dt = (-@current)/C; C=1; v(0)=-63.2823; {Na,K,Cl,IonConc};' 
    }; 
P='pop1';
% Use vary to automatically simulate different situations 
vary={
{P,'kbath',20; P,'eps',0.5; P,'G',10;P,'rho',0.9;P,'gamma',1} % Like Fig. 4D in the paper
    };
numPara=size(vary,1);
Tend=40000;

data=dsSimulate(eqns,'tspan',[0 Tend],'vary',vary);

% Plotting
for i=1:numPara
    kbath=vary{i,1}{1,3};
    eps=vary{i,1}{2,3};
    G=vary{i,1}{3,3};
    rho=vary{i,1}{4,3};
    
    figure(i);
    subplot(2,1,1);
    plot(data(i).time/10^3,data(i).(data(i).labels{strcmpi(data(i).labels,'pop1_v')}));
    xlabel('time [s]','fontsize', 14);
    ylabel('[mV]','fontsize', 14);
    title('Membrane potential','fontsize', 16);
    set(findobj('type','axes'),'fontsize',14);
    
    subplot(2,1,2)
    plot(data(i).time/10^3,data(i).(data(i).labels{strcmpi(data(i).labels,'pop1_IonConc_Ko')}))
    xlabel('time [s]','fontsize', 16);
    ylabel('Extracellular K^{+}','fontsize', 16)
    set(findobj('type','axes'),'fontsize',15)
    hold on
    plot(data(i).time/10^3,data(i).(data(i).labels{strcmpi(data(i).labels,'pop1_IonConc_Nai')}))
    xlabel('time [s]','fontsize', 14);
    ylabel('[mM]','fontsize', 14)
    title('Ion concentration dynamics', 'fontsize',16)
    set(findobj('type','axes'),'fontsize',14)
    legend('Extracellular K^{+}', 'Intracellular Na^{+}');
    
end

