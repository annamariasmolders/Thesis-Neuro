% NEURON-ASTROCYTE NETWORK, INCLUDING GAP JUNCTIONS
% Main file

clear all;
close all
clc

% Include functions used to easily access global parameters
addpath('./Extra_functions'); 

% 1D array of 50 neuron-astrocyte pairs
nN=50;
nA=50;
volN=2160; %[microm^3]
volA=2000; %[microm^3]
volE = 0.1*(volA+volN); 
SN=922; %[microm^2]
SA=1600; 
F=96485; %[C/mol]
rhoN = 5; %[µA/cm²]
rhoA = 5; %[µA/cm²]
sigma = 0.1;

Tend=60000;
dt = 1; %[ms], how many samples are saved 

Kinj_pos = [24:27]; % Positions of cells where K is injected
Kapp = zeros(1,nN);
Kapp(Kinj_pos) = 5*10^(-3)*ones(1,length(Kinj_pos)); % Rate at which K is injected
n = 3; % Number of neighbours astrocyte is connected to on each side
d = repmat(ones(nA,1),1,n);
d = [d,zeros(nA,1),d];
netconA = full(spdiags(d,-n:n,nA,nA));
OdeOpts=odeset('RelTol',10e-3,'AbsTol',10e-3,'Maxstep',25);

global INaNg IKNg INaAg IKAg flag
INaNg = ones(1,nN); IKNg = ones(1,nN);
INaAg = ones(1,nA); IKAg = ones(1,nN);
flag = 1;

eqnsN = {
    'dv/dt=-(@currentN)/CN; v(0)=-70*ones(1,nN);'
    'dNa_i/dt = -(10*SN/(F*volN))*collINaN(@INaN,@INaPN,@IPN);' 
    'Na_i(0) = 4.297*ones(1,nN);'
    'dK_i/dt = -(10*SN/(F*volN))*collIKN(@IKN,@IPN);'
    'K_i(0) = 138.116*ones(1,nN);'
    };
eqnsA = {
    'dv/dt=-(@currentA)/CA; v(0)=-75.1757;' 
    'dNa_i/dt = -(10*SA/(F*volA))*(collINaA(@INaA,@IPA)+@IgapNa);' 
    'Na_i(0) = 6.6*ones(1,nA);' 
    'dK_i/dt = -(10*SA/(F*volA))*(collIKA(@IKA,@IPA)+@IgapK);'
    'K_i(0) = 124*ones(1,nA);'
    };
s=[];
% Population for neurons
s.populations(1).name='N';
s.populations(1).size=nN;
s.populations(1).equations=eqnsN;
s.populations(1).mechanism_list={'INaNm','INaPNm','IKNm','ILNm','IPNm'};
s.populations(1).parameters={'CN',1, 'nN', nN,'F',F,'SN',SN,'volN',volN,'rhoN',rhoN};

% Population for astrocytes
s.populations(2).name='A';
s.populations(2).size=nA;
s.populations(2).equations=eqnsA;
s.populations(2).mechanism_list={'INaAm','IKAm','IPAm','Igap'}; 
s.populations(2).parameters={'CA',1,'nA',nA,'F',F,'SA',SA,'volA',volA,'rhoA',rhoA,'sigma',sigma,'nN',nN,'nA',nA,'netcon',netconA};

% Population for extracellular compartments
s.populations(3).name='EC';
s.populations(3).size=nN;
s.populations(3).equations={'dNa_e/dt= 0.00133*[0 diff(Na_e,2) 0] + @currNAE.*[0 ones(1,nN-2) 0]; Na_e(0)=133.574*ones(1,nN);' 
     'dK_e/dt=0.002*[0 diff(K_e, 2) 0] + @flag.*Kapp + @currKE.*[0 ones(1,nN-2) 0]; K_e(0)=3.5*ones(1,nN)'};
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

% Vary for different situations, as in Fig. 2 in paper
vary={
    {'N','rhoN',5;'A','rhoA',5;'A','sigma',0}
    {'N','rhoN',20;'A','rhoA',20;'A','sigma',0}
    {'N','rhoN',5;'A','rhoA',5;'A','sigma',0.1}
    };
data=dsSimulate(s,'solver','ode15s','matlab_solver_options',OdeOpts,'dt',dt,'tspan',[0 Tend],'parallel_flag',1,'vary',vary);
numPara=size(vary,1);
for i=1:numPara
    rhoN=vary{i,1}{1,3};
    rhoA=vary{i,1}{2,3};
    sigma=vary{i,1}{3,3};
    
    figure;
    plot(data(i).time/10^3,data(i).(data(i).labels{strcmpi(data(i).labels,'N_v')}))
    hold on
    xlabel('time [s]','fontsize',16);
    ylabel('Neuron membrane potential [mV]','fontsize',16);
    %title(sprintf('rho_{N,A}=%d, sigma=%d, n=%d,K^{+} injected for %d ms',rhoN,sigma,n,Kthresh));
    
    figure;
    imagesc(linspace(1,50,50),data(i).time/10^3,data(i).N_v);
    set(gca,'YDir','normal');
    colorbar;
    xlabel('Neuron number','fontsize',16)
    ylabel('time [s]','fontsize',16);
    %title(sprintf('rho_{N,A}=%d, sigma=%d, n=%d,K^{+} injected for %d ms',rhoN,sigma,n,Kthresh));
    
    figure;
    surfPlot=10*(data(i).N_v>-30);
    image(linspace(1,50,50),data(i).time/10^3,surfPlot);
    set(gca,'YDir','normal');
    xlabel('Neuron number','fontsize',16)
    ylabel('time [s]','fontsize',16);
    %title(sprintf('rho_{N,A}=%d, sigma=%d, n=%d,K^{+} injected for %d ms',rhoN,sigma,n,Kthresh));
end








