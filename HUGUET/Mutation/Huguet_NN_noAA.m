% NEURON-ASTROCYTE NETWORK, INCLUDING GAP JUNCTIONS: Genetic defect
% Main file
% Run twice:
% Change differential equation for h in INaPNm.mech
% Save data to compare

clear all;
close all
clc

% Include functions used to easily access global parameters
addpath('./Extra_functions');
% 1D array of 50 neuron-astrocyte pairs
nN=50;
nA=50;
volN=2160; % [microm^3]
volA=2000; % [microm^3]
volE = 0.1*(volA+volN); 
SN=922; % [microm^2]
SA=1600; 
F=96485; % [C/mol]
rhoN = 5; % [µA/cm²]
rhoA = 5; % [µA/cm²]
sigmagap = 0.1;

Tend=60000;
dt = 1; % [ms], how many samples are saved 

Kinj_pos = [24:27]; % Positions of cells where K is injected
Kapp = zeros(1,nN);
Kapp(Kinj_pos) = 5*10^(-3)*ones(1,length(Kinj_pos)); % Rate at which K is injected
n = 3; % Number of neighbours astrocyte is connected to on each side
d = repmat(ones(nA,1),1,n);
d = [d,zeros(nA,1),d];
netconA = full(spdiags(d,-n:n,nA,nA));
OdeOpts=odeset('RelTol',1e-3,'AbsTol',1e-3,'Maxstep',25);

global INaNg IKNg INaAg IKAg flag
INaNg = ones(1,nN); IKNg = ones(1,nN);
INaAg = ones(1,nA); IKAg = ones(1,nN);
flag = 1;

eqnsN = {
    'dv/dt=-(@currentN)/CN; v(0)=-70*ones(1,nN);'
    'dNa_i/dt = -(10*SN/(F*volN))*collINaN(@INaN,@INaPN,@IPN);' %/100;'
    %'Na_i(0) = 8.5*ones(1,nN);'
    'Na_i(0) = 4.297*ones(1,nN);'
    'dK_i/dt = -(10*SN/(F*volN))*collIKN(@IKN,@IPN);' %/100;'    
    %'K_i(0) = 149.5*ones(1,nN);'
    'K_i(0) = 138.116*ones(1,nN);'
    };
eqnsA = {
    'dv/dt=-(@currentA)/CA; v(0)=-75.1757;' %v(0)=-75.15*ones(1,nA);'
    'dNa_i/dt = -(10*SA/(F*volA))*(collINaA(@INaA,@IPA)+@IgapNa);' %/100;'
    %'Na_i(0) = 14.6*ones(1,nA);'
    'Na_i(0) = 6.6*ones(1,nA);' %6.2*ones(1,nA);'
    'dK_i/dt = -(10*SA/(F*volA))*(collIKA(@IKA,@IPA)+@IgapK);' %/100;'
    %'K_i(0) = 133*ones(1,nA);'
    'K_i(0) = 124*ones(1,nA);'
    };
s=[];
% Population for neurons
s.populations(1).name='N';
s.populations(1).size=nN;
s.populations(1).equations=eqnsN;
s.populations(1).mechanism_list={'INaNm','INaPNm','IKNm','ILNm','IPNm'};
s.populations(1).parameters={'CN',1, 'nN', nN,'F',F,'SN',SN,'volN',volN,'rhoN',rhoN};%, 'netcon', netcon};

% Population for astrocytes 
s.populations(2).name='A';
s.populations(2).size=nA;
s.populations(2).equations=eqnsA;
s.populations(2).mechanism_list={'INaAm','IKAm','IPAm','Igap'}; 
s.populations(2).parameters={'CA',1,'nA',nA,'F',F,'SA',SA,'volA',volA,'rhoA',rhoA,'sigma',sigmagap,'nN',nN,'nA',nA,'netcon',netconA };%'netcon',netcon};

% Population for extracellular compartments
s.populations(3).name='EC';
s.populations(3).size=nN;
s.populations(3).equations={'dNa_e/dt= 0.00133*[0 diff(Na_e,2) 0] + @currNAE.*[0 ones(1,nN-2) 0]; Na_e(0)=133.574*ones(1,nN);' %Na_e(0)=138*ones(1,nN);' % Na_e(0)=130*ones(1,nN)
     'dK_e/dt=0.002*[0 diff(K_e, 2) 0] + @flag*Kapp + @currKE.*[0 ones(1,nN-2) 0]; K_e(0)=3.5*ones(1,nN)'}; %
% @flag: Inject K as long as non-injected cells are not depolarized above
% -40 mV yet
 s.populations(3).parameters={'nN', nN,'Kapp',Kapp};

% Update extracellular concentrations with neuronal intracellular currents
s.connections(1).direction='N->EC';
s.connections(1).mechanism_list='ConcExN';
s.connections(1).parameters={'F',F,'SN',SN,'SA',SA,'volE',volE};
% Update extracellular concentrations with astrocytal intracellular currents 
s.connections(2).direction='A->EC';
s.connections(2).mechanism_list='ConcExA';
s.connections(2).parameters={'F',F,'SN',SN,'SA',SA,'volE',volE};
% Link extracellular concentrations
s.connections(3).direction='EC->N';
s.connections(3).mechanism_list={'updateKe','updateNae'};
% Link extracellular concentrations
s.connections(4).direction='EC->A';
s.connections(4).mechanism_list={'updateKe','updateNae'};


data=dsSimulate(s,'solver','ode15s','matlab_solver_options',OdeOpts,'dt',dt,'tspan',[0 Tend],'parallel_flag',1); %,'vary',vary);
figure;
plot(data.time,data.(data.labels{strcmpi(data.labels,'N_v')}))
hold on
xlabel('time [ms]','fontsize',12);
ylabel('Neuron membrane potential [mV]','fontsize',12);

figure;
surfPlot=10*(data.N_v>-30);
image(surfPlot);
set(gca,'YDir','normal');
xlabel('Neuron number','fontsize',12)
ylabel('time [ms]','fontsize',12);







