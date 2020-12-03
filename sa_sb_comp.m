%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Strong acid -- strong base diode
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Components

comp(1).type='acid';
comp(1).name='HCl';
comp(1).abbrv='hcl';
comp(1).diss='Inf';
comp(1).c=[0 0.1];

comp(2).type='base';
comp(2).name='KOH';
comp(2).abbrv='koh';
comp(2).diss='Inf';
comp(2).c=[0.1 0];

comp(3).type='salt';
comp(3).name='KCl';
comp(3).abbrv='kcl';
comp(3).diss='Inf';
comp(3).c=[0 0];

comp(4).type='fix_group';
comp(4).name='carboxylate';
comp(4).abbrv='fa0';
comp(4).diss=1e-4;
comp(4).c=4e-3;
comp(4).fix.name='FA';
comp(4).fix.abbrv='fa';
comp(4).fix.z=-1;
comp(4).fix.expr='c_fa0/(c_h/Kfa+1)';
