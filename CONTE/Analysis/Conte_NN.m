% NEURON-ASTROCYTE PAIR, INCLUDING NA-GL TRANSPORT & CA DYNAMICS
% Main file

clear all;
close all
clc

% Include functions used to easily access global parameters
addpath('./Collect_Release');

% Single neuron-astrocyte pair
nN=1;
nA=1;
volN=2160; %[microm^3]
volA=2000; %[microm^3]
alpha0=0.05;
volE=alpha0*volN; % extracellular volume is a fixed fraction of neuron's volume
SN=922; %[microm^2]
SA=1600; %[microm^2] 
F=96485; %[C/mol]

pcytosol=0.5;
minute=60;
second=1000;
per=0.1;
der=1000;
VC=pcytosol*minute*second/(per*der);
fi=0.01;

VER=(per*minute*second)/(per*der);

gNab=1*10^(-5); 
gKb=2*10^(-5); 
gClb=6*10^(-6); 
gCab=6*10^(-6); 

OdeOpts=odeset('RelTol',1e-8,'AbsTol',1e-8,'Maxstep',25);
Tend = 6000000;
dt = 1; %[ms], how many samples are saved 

global INaNg IKNg INaAg IKAg IClNg INaGlg
INaNg = ones(1,nN); IKNg = ones(1,nN); IClNg = ones(1,nN);
INaAg = ones(1,nA); IKAg = ones(1,nA); INaGlg = ones(1,nA);

eqnsN = {
    'dv/dt=-(@currentN)/CN; v(0)=-58.81137764996264*ones(1,nN);'
    'dNa_i/dt = -(10*SN/(F*volN))*collINaN(@INaN,@INaPN,@INaNMDA,@IPN)'; 
    'Na_i(0) = 1.285281166395606*ones(1,nN);'
    'dK_i/dt = -(10*SN/(F*volN))*collIKN(@IKN,@IPN,@IKNMDA)';   
    'K_i(0) = 149.1319593988436*ones(1,nN);'
    'dCl_i/dt = (10*SN/(F*volN))*collIClN(@IClN)'; 
    'Cl_i(0) = 12.52512787448607*ones(1,nN);'
    'dCa_i/dt = -fi*(10*SN/(F*volN))*@ICaNMDA - fi*(@Jserca - @Jerout)/VC;'
    'Ca_i(0)=0.0009387716976116532*ones(1,nN);'
    'dCa_ER/dt = fi*(@Jserca - @Jerout)/VER;'
    'Ca_ER(0)=0.05904737645069838*ones(1,nN);'
    'dCa_e/dt=(10*SN/(F*volE))*@ICaNMDA + gCab*(3-Ca_e);' 
    'Ca_e(0)=2.801142735550066*ones(1,nN);'
    };
eqnsA = {
    'dv/dt=-(@currentA)/CA; v(0)=-39.02998140466573*ones(1,nA)' 
    'dNa_i/dt = -(10*SA/(F*volA))*(collINaA(@INaA,@IPA)+3*collINaGl(@INaGl));'
    'Na_i(0) = 66.24314341750998*ones(1,nA);'
    'dK_i/dt = -(10*SA/(F*volA))*(collIKA(@IKA,@IPA)-collINaGl(@INaGl));'
    'K_i(0) = 71.95968297063686*ones(1,nA);'
    'Gl_i(t) = 1 + (volE/volA)*(0.001-@Gle);'
    };
s=[];
% Population for neuron
s.populations(1).name='N';
s.populations(1).size=nN;
s.populations(1).equations=eqnsN;
s.populations(1).mechanism_list={'IKN','INaN','INaPN','INMDA','IClN','IPN','JFluxes'};
s.populations(1).parameters={'CN',1,'nN',nN,'F',F,'SN',SN,'volN',volN,'volE',volE,'fi',fi,'gCab',gCab,'VC',VC,'VER',VER};

% Population for astrocytes
s.populations(2).name='A';
s.populations(2).size=nA;
s.populations(2).equations=eqnsA;
s.populations(2).mechanism_list={'IKA','INaA','IPA','INaGl'}; 
s.populations(2).parameters={'CA',1,'nN',nN,'nA',nA,'F',F,'SA',SA,'volA',volA,'volE',volE};

% Population for extracellular compartments
s.populations(3).name='EC';
s.populations(3).size=nN;
s.populations(3).equations={'dNa_e/dt= @currNAE.*ones(1,nN)+gNab*(140*ones(1,nN)-Na_e);Na_e(0)=116.0901080839575*ones(1,nN);'
    'dK_e/dt=@currKE.*ones(1,nN) + gKb*(4*ones(1,nN)-K_e); K_e(0)=16.41369332787475*ones(1,nN);'
    'dCl_e/dt= @currCLE.*ones(1,nN) + gClb*(110*ones(1,nN)-Cl_e);Cl_e(0)=111.3857579081404*ones(1,nN);'
    'dGl_e/dt=@currGLE.*ones(1,nN);Gl_e(0)=0.004525191854168424*ones(1,nN);'
    }; 
s.populations(3).parameters={'nN',nN,'nA',nA,'gNab',gNab,'gKb',gKb,'gClb',gClb};

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
s.connections(3).mechanism_list={'updateKe','updateNae','updateCle','updateGle'};
% Link extracellular concentrations 
s.connections(4).direction='EC->A';
s.connections(4).mechanism_list={'updateKe','updateNae','updateCle','updateGle'};

% vary={ % Vary to observe trends, as in Fig. 8 in paper
%     {'N','rhoN',5;'A','rhoA',0.08}
%     {'N','rhoN',4;'A','rhoA',0.1}
%     {'N','rhoN',2.5;'A','rhoA',0.08}
%     };
% numPara=size(vary,1);
% If vary not included in dsSimulate arguments
numPara=1;

data=dsSimulate(s,'solver','ode15s','dt',dt,'tspan',[0 Tend],'matlab_solver_options',OdeOpts,'parallel_flag',1);

% Plotting
for i=1:numPara
    figure;
    plot(data(i).time/10^3, data(i).N_v)
    xlabel('time [s]','fontsize',16)
    ylabel('[mV]','fontsize',16)
end

