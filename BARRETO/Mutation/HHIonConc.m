% SINGLE NEURON: GENETIC DEFECT
% CONDUCTANCE-BASED MODEL EXTENDED WITH ION CONCENTRATION DYNAMICS
% Main file

clear all;
close all
clc

eqns = {'dv/dt=(-@current)/C;v(0)=-63.2823;' 
    'monitor Na.functions;'
    };
eqnsMut = {'dvMut/dt=(-@current)/C;vMut(0)=-63.2823;' 
    'monitor NaMut.functions;'
    };
% Vary to observe different situations
%(but most interesting case: CSD-like, as in Fig. 4D in paper)
% vary={
%     {'Wild','kbath',20; 'Wild','eps',0.5; 'Wild','G',10;'Mutant','kbath',20; 'Mutant','eps',0.5; 'Mutant','G',10}
%     {'Wild','kbath',20; 'Wild','eps',0.133; 'Mutant','G',10; 'Mutant','kbath',20; 'Mutant','eps',0.133; 'Mutant','G',10;}
%     };
% numPara=size(vary,1);
s=[];
s.populations(1).name='Wild';
s.populations(1).size=1;
s.populations(1).equations=eqns;
s.populations(1).mechanism_list={'Na','K','Cl','IonConc'};
s.populations(1).parameters={'C',1};

s.populations(2).name='Mutant';
s.populations(2).size=1;
s.populations(2).equations=eqnsMut;
s.populations(2).mechanism_list={'NaMut','K','Cl','IonConc'};
s.populations(2).parameters={'C',1};

Tend=100000;
dt=1;

data = dsSimulate(s,'tspan',[0 Tend]); %,'vary',vary);


% When vary is not used
numPara=1;
% Plotting
for i=1:numPara
    figure;
    plot(data(i).time/10^3,data(i).(data(i).labels{strcmpi(data(i).labels,'Wild_v')}));
    hold on
    plot(data(i).time/10^3,data(i).(data(i).labels{strcmpi(data(i).labels,'Mutant_vMut')}));
    xlabel('time [s]','fontsize', 14);
    ylabel('[mV]','fontsize', 14)
    title('Membrane potential','fontsize', 16);
    set(findobj('type','axes'),'fontsize',14);
    
    figure;
    subplot(3,1,1);
    plot(data(i).(data(i).labels{strcmpi(data(i).labels,'Wild_v')}),data(i).(data(i).labels{strcmpi(data(i).labels,'Wild_Na_tauh')}));
    hold on
    plot(data(i).(data(i).labels{strcmpi(data(i).labels,'Mutant_vMut')}),data(i).(data(i).labels{strcmpi(data(i).labels,'Mutant_NaMut_tauhMut')}));
    xlabel('Membrane potential [mV]','fontsize', 14);
    ylabel('[Unitless]','fontsize', 14)
    title('Time constant gating variable h','fontsize', 16);
    set(findobj('type','axes'),'fontsize',14);
    legend('\tau_{h}', '\tau_{h}*');
    
    subplot(3,1,2);
    plot(data(i).time/10^3,data(i).(data(i).labels{strcmpi(data(i).labels,'Wild_Na_h')}));
    hold on
    plot(data(i).time/10^3,data(i).(data(i).labels{strcmpi(data(i).labels,'Wild_Na_hMut')}));
    xlabel('time [s]','fontsize', 14);
    ylabel('[Unitless]','fontsize', 14)
    title('Time constant gating variable h: Deinactivation','fontsize', 16);
    legend('h','h*');
    set(findobj('type','axes'),'fontsize',14);
    
    subplot(3,1,3);
    plot(data(i).time/10^3,data(i).(data(i).labels{strcmpi(data(i).labels,'Wild_Na_h')}));
    hold on
    plot(data(i).time/10^3,data(i).(data(i).labels{strcmpi(data(i).labels,'Wild_Na_hMut')}));
    xlabel('time [s]','fontsize', 14);
    ylabel('[Unitless]','fontsize', 14)
    title('Time constant gating variable h: Inactivation','fontsize', 16);
    legend('h','h*');
    set(findobj('type','axes'),'fontsize',14);
end