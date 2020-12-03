%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Weak acid -- weak base diode
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Components

comp(1).type='acid';
comp(1).name='CH3COOH';
comp(1).abbrv='ha';
comp(1).diss=1.7782794e-005;  %disszociacios egyutthato
comp(1).c=[0 0.1];
comp(1).k=6e9;      %sebessegi egyutthato

comp(2).type='base';
comp(2).name='NH4OH';
comp(2).abbrv='boh';
comp(2).diss=1.8197009e-005;
comp(2).c=[0.1 0];
comp(2).k=6e9;

comp(3).type='salt';
comp(3).name='CH3COONH4';
comp(3).abbrv='ab';
comp(3).diss='Inf';
comp(3).c=[0 0];

comp(4).type='salt';
comp(4).name='NH4Cl';
comp(4).abbrv='bcl';
comp(4).diss='Inf';
comp(4).c=[0 0];

comp(5).type='salt';
comp(5).name='CH3COOK';
comp(5).abbrv='ka';
comp(5).diss='Inf';
comp(5).c=[0 0];

comp(6).type='salt';
comp(6).name='KCl';
comp(6).abbrv='kcl';
comp(6).diss='Inf';
comp(6).c=[0 0];


comp(7).type='fix_group';
comp(7).name='carboxylate';
comp(7).abbrv='fa0';
comp(7).diss=1e-4;
comp(7).c=4e-3;
comp(7).fix.name='FA';
comp(7).fix.abbrv='fa';
comp(7).fix.z=-1;
comp(7).fix.expr='c_fa0/(c_h/Kfa+1)';





