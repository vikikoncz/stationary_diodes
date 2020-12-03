const.U0=10;
const.magic=1.0;
const.L=1e-3;
const.R=8.314472;
const.T=298.15;
const.u=0;
const.epsilon=6.954e-10;
const.Kw=1e-14;

Kw=const.Kw;

%N_mesh=1000; % Default mesh resolution
N_mesh=3000;

if(mode=='sa_sb')  %if the diode contains strong acid and strong base

pname='magic'; % Default parameter
plist=[1e-10 1.01e-10 1e-8 1e-6 1e-4 1]; % Default parameter list
%plist=[1];
ntol=1e-8; % Default tolerance
maxiter=50; % Default max number of iterations
hnlin='on'; % Default: the problem is highly nonlinear
force='off'; % Default: use existing solution

end

if(mode=='wa_wb')  %if the diode contains weak acid and weak base

pname='magic'; % Default parameter
plist=[1e-6 1.01e-6 1e-5 5e-5 1e-4 2e-4 3e-4 4e-4 5e-4 6e-4 7e-4 8e-4 9e-4 1e-3 1.1e-3 5e-3 1e-2 5e-2 1e-1 5e-1 1]; % Default parameter list
%plist=[1e-8 1.01e-8 1.1e-8 1e-7 1e-6 1e-5 1e-4 1e-3 1e-2 1e-1 1];
ntol=1e-8; % Default tolerance
maxiter=50; % Default max number of iterations
hnlin='on'; % Default: the problem is highly nonlinear
force='off'; % Default: use existing solution

end
